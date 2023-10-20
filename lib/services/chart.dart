import 'package:app_control_gastos/services/firebase_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class OrderStats {
  final DateTime fecha;
  final String uID;
  final int valor;

  OrderStats({
    required this.fecha,
    required this.uID,
    required this.valor,
  });
}

Future<List<OrderStats>> getOrderStatsFromFirestore() async {
  try {
    final gastos = await getValue();
    final orderStatsList = gastos.map((expense) {
      return OrderStats(
        fecha: expense['fecha'].toDate(),
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
  List<String> diasDeLaSemana = [
    'Lun',
    'Mar',
    'Mié',
    'Jue',
    'Vie',
    'Sáb',
    'Dom'
  ];

  CustomBarChart({required this.orderStats});

  @override
  Widget build(BuildContext context) {
    Map<String, double> calcularGastosDiarios(List<OrderStats> orderStats) {
      final gastosDiarios = Map<String, double>.fromIterable(diasDeLaSemana,
          key: (dia) => dia, value: (_) => 0);

      for (var stats in orderStats) {
        final dia = DateFormat('E', 'es').format(stats.fecha).toString();
        if (stats.valor != null) {
          gastosDiarios[dia] ??= 0.0;
          gastosDiarios[dia] = gastosDiarios[dia]! + stats.valor.toDouble();
        } else {
          gastosDiarios[dia] ??= 0.0;
        }
      }

      return gastosDiarios;
    }

    final gastosDiarios = calcularGastosDiarios(orderStats);

    final todosLosDias = diasDeLaSemana.map((dia) {
      final valor = gastosDiarios[dia] ?? 0.0;
      return ChartSampleData(
        x: dia, // Día de la semana
        y: valor, // Valor total de gastos
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
            dataSource: todosLosDias,
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
  final double y;

  ChartSampleData({
    required this.x,
    required this.y,
  });
}
