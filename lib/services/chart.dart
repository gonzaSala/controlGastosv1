import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:app_control_gastos/services/firebase_service.dart';

class ChartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Obtén la lista de gastos de tu fuente de datos, por ejemplo, tu función getValue()
    final Future<List> gastos = getValue();

    // Modifica esta línea para obtener los gastos del día de la semana actual
    final List<double> weeklyExpenses = calculateWeeklyExpenses(gastos as List);

    return Scaffold(
      appBar: AppBar(
        title: Text('Gráfico de Gastos por Día de la Semana'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceAround,
            maxY: weeklyExpenses.reduce((value, element) {
                  return value > element ? value : element;
                }) +
                100, // Ajusta el valor máximo según tus datos
            titlesData: FlTitlesData(
              leftTitles: SideTitles(showTitles: true, reservedSize: 30),
              bottomTitles: SideTitles(
                showTitles: true,
                getTitles: (double value) {
                  // Map values to days of the week
                  switch (value.toInt()) {
                    case 0:
                      return 'Lun';
                    case 1:
                      return 'Mar';
                    case 2:
                      return 'Mié';
                    case 3:
                      return 'Jue';
                    case 4:
                      return 'Vie';
                    case 5:
                      return 'Sáb';
                    case 6:
                      return 'Dom';
                    default:
                      return '';
                  }
                },
                margin: 8,
              ),
            ),
            borderData: FlBorderData(
              show: true,
              border: Border(
                bottom: BorderSide(
                  color: const Color(0xff37434d),
                  width: 1,
                ),
                left: BorderSide(
                  color: Colors.transparent,
                ),
                right: BorderSide(
                  color: Colors.transparent,
                ),
                top: BorderSide(
                  color: Colors.transparent,
                ),
              ),
            ),
            barGroups: List.generate(
              7,
              (index) => BarChartGroupData(
                x: index,
                barRods: [
                  BarChartRodData(
                    y: weeklyExpenses[index], // Use the amount for comparison
                    width: 16,
                    colors: [Colors.accents[index % Colors.accents.length]],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Modifica esta función para calcular los gastos para cada día de la semana
  List<double> calculateWeeklyExpenses(List gastos) {
    final now = DateTime.now();
    final daysOfWeek = [
      DateTime.monday,
      DateTime.tuesday,
      DateTime.wednesday,
      DateTime.thursday,
      DateTime.friday,
      DateTime.saturday,
      DateTime.sunday
    ];

    return daysOfWeek.map((day) {
      final totalForDay = gastos
          .where((expense) => expense['fecha'].toDate().weekday == day)
          .fold(0.0, (sum, expense) => sum + expense['valor']);
      return totalForDay;
    }).toList();
  }
}
