import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:app_control_gastos/services/firebase_service.dart';
import 'package:charts_common/common.dart' as commonCharts;

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
    barColor = charts.ColorUtil.fromDartColor(Colors.black);
  }
}

Future<List<OrderStats>> getOrderStatsFromFirestore() async {
  final gastos = await getValue();

  // Convierte los datos de Firestore en objetos OrderStats
  final orderStatsList = gastos.map((expense) {
    return OrderStats(
      date: expense['fecha'].toDate(),
      uID: expense['uID'],
      valor: int.parse(expense['valor'].toString()),
    );
  }).toList();

  return orderStatsList;
}

class CustomBarChart extends StatelessWidget {
  final List<OrderStats> orderStats;

  CustomBarChart({required this.orderStats});

  @override
  Widget build(BuildContext context) {
    final seriesList = [
      charts.Series<OrderStats, String>(
        id: 'valor',
        data: orderStats,
        domainFn: (OrderStats stats, _) {
          // Aquí puedes personalizar el formato de la fecha como desees.
          final dayOfWeek = stats.date.weekday;
          switch (dayOfWeek) {
            case 1:
              return 'Lun';
            case 2:
              return 'Mar';
            case 3:
              return 'Mié';
            case 4:
              return 'Jue';
            case 5:
              return 'Vie';
            case 6:
              return 'Sáb';
            case 7:
              return 'Dom';
            default:
              return '';
          }
        },
        measureFn: (OrderStats stats, _) => stats.valor,
      )
    ];

    return Container(
      height: 250, // Ajusta la altura según tus necesidades
      child: charts.BarChart(
        seriesList,
        animate: true,
      ),
    );
  }
}
