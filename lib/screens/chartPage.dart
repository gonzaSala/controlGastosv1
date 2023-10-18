import 'package:app_control_gastos/services/chart.dart';
import 'package:flutter/material.dart';

class chartPage extends StatefulWidget {
  const chartPage({super.key});

  @override
  _chartPage createState() => _chartPage();
}

class _chartPage extends State<chartPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gráfico semanal'),
      ),
      body: Center(
        child: Container(
            child: Column(
          children: [
            FutureBuilder<List<OrderStats>>(
              future: getOrderStatsFromFirestore(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  final orderStats = snapshot.data ?? [];
                  return Container(
                    height: 250,
                    padding: const EdgeInsets.all(10),
                    child: CustomBarChart(
                      orderStats: orderStats,
                    ),
                  );
                }
              },
            ),
          ],
        )),
      ),
    );
  }
}
