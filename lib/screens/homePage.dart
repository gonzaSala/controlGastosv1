import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:app_control_gastos/screens/addValue.dart';
import 'package:app_control_gastos/screens/chartPage.dart';
import 'package:app_control_gastos/screens/historial.dart';
import 'package:app_control_gastos/services/firebase_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map<int, String> dayNames = {
    1: 'Lunes',
    2: 'Martes',
    3: 'Miércoles',
    4: 'Jueves',
    5: 'Viernes',
    6: 'Sábado',
    7: 'Domingo',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Control de Gastos'),
      ),
      body: Center(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              FutureBuilder<List<double>>(
                future: calculateWeeklyExpenses(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    final weeklyTotals = snapshot.data ?? List.filled(7, 0.0);
                    return Column(
                      children: [
                        Text(
                          '\$${weeklyTotals.fold(0.0, (total, weeklyTotal) => total + weeklyTotal)}',
                          style: TextStyle(
                            fontSize: 50,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        Text(
                          'Total gastos por semana',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueGrey,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        // Puedes mostrar los totales diarios si es necesario
                        Container(
                          margin: EdgeInsets.only(
                              left: 107.0, top: 22.5), // Margen a la izquierda
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              for (int i = 0; i < weeklyTotals.length; i++)
                                Text(
                                  '${dayNames[i + 1]}: \$${weeklyTotals[i]}',
                                  style: TextStyle(
                                    fontSize: 25,
                                    color: Colors.blueGrey,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Color.fromARGB(142, 82, 2, 255),
        notchMargin: 4.0,
        shape: const CircularNotchedRectangle(),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            bottomAction(FontAwesomeIcons.clockRotateLeft, () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const Historial(),
                ),
              );
            }),
            bottomAction(FontAwesomeIcons.chartPie, () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => chartPage(),
                ),
              );
            }),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromARGB(255, 60, 26, 229),
        hoverColor: Color.fromARGB(146, 63, 28, 180),
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const AddNewExpense(),
            ),
          );
        },
      ),
    );
  }

  Widget bottomAction(IconData icon, Function() onTapCallback) {
    return InkWell(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Icon(icon),
      ),
      onTap: onTapCallback,
    );
  }
}
