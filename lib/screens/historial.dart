import 'package:app_control_gastos/screens/homePage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:app_control_gastos/services/firebase_service.dart';
import 'package:intl/intl.dart';

class Historial extends StatefulWidget {
  const Historial({Key? key});

  @override
  _HistorialState createState() => _HistorialState();
}

class _HistorialState extends State<Historial> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const HomePage(),
              ),
            );
          },
        ),
        title: const Text('Historial de gastos'),
      ),
      body: FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('gastos')
            .orderBy('fecha', descending: true)
            .get(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            final expenses = snapshot.data!.docs;

            // Crear un mapa para agrupar gastos por fecha
            final groupedExpenses = <String, List<Map<String, dynamic>>>{};

            for (var expense in expenses) {
              final data = expense.data() as Map<String, dynamic>;
              final fecha = DateFormat('dd/MM/yyyy').format(
                (data['fecha'] as Timestamp).toDate(),
              );

              // Convertir el nombre a mayúsculas
              final nameUpper = (data['nombre'] as String).toUpperCase();

              if (!groupedExpenses.containsKey(fecha)) {
                groupedExpenses[fecha] = [];
              }
              groupedExpenses[fecha]!.add(data);
            }

            return ListView.builder(
              itemCount: groupedExpenses.length,
              itemBuilder: (context, index) {
                final fecha = groupedExpenses.keys.elementAt(index);
                final gastosDelDia = groupedExpenses[fecha]!;

                return Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(
                        top:
                            10.0, // Ajusta el valor del margen superior según tus preferencias
                        bottom:
                            1.0, // Ajusta el valor del margen inferior según tus preferencias
                      ),
                      child: Text(
                        fecha,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueGrey,
                        ),
                      ),
                    ),
                    for (var expense in gastosDelDia)
                      Container(
                        margin: const EdgeInsets.only(
                          left: 0.0,
                          right: 0.0,
                          bottom: 4.0,
                          top: 0.0,
                        ), // Establece el margen aquí
                        child: Dismissible(
                          key: Key(expense['uID'].toString()),
                          onDismissed: (direction) async {
                            await deleteExpense(expense['uID']);
                            setState(() {
                              gastosDelDia.remove(expense);
                            });
                          },
                          confirmDismiss: (direction) async {
                            final result = await showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text(
                                    '¿Está seguro de que quiere eliminar el gasto de ${expense['nombre']}?',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context, false);
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                                'Se eliminó el gasto: ${expense['nombre']}'),
                                          ),
                                        );
                                      },
                                      child: const Text(
                                        'Cancelar',
                                        style:
                                            TextStyle(color: Colors.redAccent),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context, true);
                                      },
                                      child: const Text('Sí, estoy seguro'),
                                    ),
                                  ],
                                );
                              },
                            );

                            return result;
                          },
                          background: Container(
                            color: Colors.redAccent,
                            child: const Icon(Icons.delete),
                          ),
                          direction: DismissDirection.endToStart,
                          child: ListTile(
                            title: Text(
                              expense['nombre'].toString().toUpperCase(),
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '\$${expense['valor'].toString()}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17,
                                  ),
                                ),
                                if (expense['fecha'] != null)
                                  Text(
                                    DateFormat('HH:mm:ss').format(
                                      (expense['fecha'] as Timestamp).toDate(),
                                    ),
                                  )
                                else
                                  Text('Fecha no disponible'),
                              ],
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              },
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return const Center(
              child: Text('No hay datos disponibles'),
            );
          }
        },
      ),
    );
  }
}
