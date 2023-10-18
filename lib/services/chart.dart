import 'package:app_control_gastos/services/firebase_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_core/theme.dart';

class OrderStats {
  final DateTime date;
  final String uID;
  final int valor;

  OrderStats({
    required this.date,
    required this.uID,
    required this.valor,
  });
}

Future<List<OrderStats>> getOrderStatsFromFirestore() async {
  try {
    final gastos = await getValue();
    final orderStatsList = gastos.map((expense) {
      return OrderStats(
        date: expense['fecha'].toDate(),
        uID: expense['uID'],
        valor: expense['valor'],
      );
    }).toList();
    return orderStatsList;
  } catch (e) {
    print('Error al recuperar datos de Firestore: $e');
    return [];
  }
}

class CustomBarChart extends StatelessWidget {
  final List<OrderStats> orderStats;

  CustomBarChart({required this.orderStats});

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting('es', null);

    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday));
    final endOfWeek = startOfWeek.add(Duration(days: 7));

    final filteredStats = orderStats.where((stats) {
      return stats.date.isAfter(startOfWeek) && stats.date.isBefore(endOfWeek);
    }).toList();

    final List<ChartSampleData> chartData = filteredStats.map((stats) {
      return ChartSampleData(
        x: DateFormat('E', 'es')
            .format(stats.date), // Formatear la fecha como abreviatura de día
        y: stats.valor.toDouble(),
      );
    }).toList();

    return Container(
      height: 400, // Ajustar la altura según tus necesidades
      child: SfCartesianChart(
        plotAreaBorderWidth: 0,
        plotAreaBackgroundColor: const Color.fromARGB(255, 28, 28, 28),
        primaryXAxis: CategoryAxis(),
        series: <LineSeries<ChartSampleData, String>>[
          LineSeries<ChartSampleData, String>(
            width: 5,
            color: Color.fromARGB(255, 69, 91, 234),
            dataSource: chartData,
            xValueMapper: (ChartSampleData data, _) => data.x,
            yValueMapper: (ChartSampleData data, _) => data.y,
          )
        ],
      ),
    );
  }
}

class ChartSampleData {
  final String x;
  final double? y;

  ChartSampleData({
    required this.x,
    required this.y,
  });
}
