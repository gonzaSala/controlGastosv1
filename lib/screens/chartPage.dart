import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class GraficoScreen extends StatefulWidget {
  final List<double> calculoGastosSemanal;

  GraficoScreen({Key? key, required this.calculoGastosSemanal})
      : super(key: key);

  @override
  State<GraficoScreen> createState() => _GraficoScreenState();
}

class _GraficoScreenState extends State<GraficoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gráfico de Gastos Diarios'),
      ),
      body: LineChart(
        LineChartData(
          gridData: FlGridData(show: false),
          titlesData: FlTitlesData(show: false),
          borderData: FlBorderData(
            show: true,
            border: Border.all(color: const Color(0xff37434d), width: 1),
          ),
          minX: 1, // Ajusta estos valores según tus necesidades.
          maxX: widget.calculoGastosSemanal.length
              .toDouble(), // Asegúrate de que coincida con la cantidad de datos.
          minY: 0, // Ajusta según tus datos.
          maxY: widget.calculoGastosSemanal.reduce((a, b) =>
              a > b ? a : b), // Encuentra el valor máximo en tus datos.
          lineBarsData: [
            LineChartBarData(
              spots: widget.calculoGastosSemanal
                  .asMap()
                  .entries
                  .map((entry) => FlSpot(entry.key.toDouble() + 1, entry.value))
                  .toList(),
              isCurved: true, // Puedes ajustar la apariencia del gráfico.
              colors: [
                const Color(0xff4af699)
              ], // Color de la línea del gráfico.
              barWidth: 4, // Grosor de la línea.
              isStrokeCapRound: true,
              belowBarData: BarAreaData(show: false),
            ),
          ],
        ),
      ),
    );
  }
}
