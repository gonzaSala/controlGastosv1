import 'package:app_control_gastos/screens/addValue.dart';
import 'package:app_control_gastos/screens/chartPage.dart';
import 'package:app_control_gastos/screens/historial.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:app_control_gastos/services/firebase_service.dart';
import 'package:flutter/material.dart';

//Icons
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Control de Gastos',
        ),
      ),
      body: Center(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              FutureBuilder<double>(
                future: calculateTotalExpense(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    final totalExpense = snapshot.data ?? 0;
                    return Column(
                      children: [
                        Text(
                          '\$$totalExpense',
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Total gastos',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueGrey,
                          ),
                        ),
                      ],
                    );
                  }
                },
              ),

              //
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: const Color.fromARGB(255, 163, 191, 240),
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
        backgroundColor: Colors.blueAccent,
        hoverColor: const Color.fromARGB(146, 0, 111, 166),
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
