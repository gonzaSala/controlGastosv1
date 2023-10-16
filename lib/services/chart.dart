import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:app_control_gastos/services/firebase_service.dart';
import 'package:intl/intl.dart';

class OrderStats {
  final DateTime date;
  final String uID;
  final int valor;
  charts.Color? barColor;

  OrderStats({
    required this.date,
    required this.uID,
    required this.valor,
    this.barColor,
  }) {
    barColor = charts.ColorUtil.fromDartColor(Colors.blue);
  }
}

Future<List<OrderStats>> getOrderStatsFromFirestore() async {
  try {
    final gastos = await getValue();
    final orderStatsList = gastos.map((expense) {
      return OrderStats(
        date: expense['fecha'].toDate(),
        uID: expense['uID'],
        valor: int.parse(expense['valor'].toString()),
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
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday));
    final endOfWeek = startOfWeek.add(Duration(days: 7));

    final filteredStats = orderStats.where((stats) {
      return stats.date.isAfter(startOfWeek) && stats.date.isBefore(endOfWeek);
    }).toList();

    final seriesList = [
      charts.Series<OrderStats, String>(
        id: 'valor',
        data: filteredStats,
        domainFn: (OrderStats stats, _) {
          return DateFormat('E')
              .format(stats.date); // Formatear la fecha como abreviatura de día
        },
        measureFn: (OrderStats stats, _) => stats.valor,
      )
    ];

    return Container(
      height: 200, // Ajustar la altura según tus necesidades
      child: charts.BarChart(
        seriesList,
        animate: true,
      ),
    );
  }
}
