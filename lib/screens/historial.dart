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
        future: getValue(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data?.length,
              itemBuilder: (context, index) {
                return Dismissible(
                  key: Key(
                      snapshot.data![index]['uID'].toString()), // Cambio aquí
                  onDismissed: (direction) async {
                    await deleteExpense(snapshot.data?[index]['uID']);
                    setState(() {
                      snapshot.data?.removeAt(index);
                    });
                  },
                  confirmDismiss: (direction) async {
                    bool result = false;

                    result = await showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text(
                            '¿Está seguro de que quiere eliminar el gasto de ${snapshot.data?[index]['nombre']}?',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context, false);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        'Se eliminó el gasto: ${snapshot.data?[index]['nombre']}'),
                                  ),
                                );
                              },
                              child: const Text(
                                'Cancelar',
                                style: TextStyle(color: Colors.redAccent),
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
                      snapshot.data?[index]['nombre'] ?? '',
                      style: TextStyle(fontSize: 25),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '\$${snapshot.data![index]['valor'].toString()}',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 17),
                        ),
                        if (snapshot.data?[index]['fecha'] != null)
                          Text(
                            DateFormat('dd/MM/yyyy HH:mm:ss').format(
                              (snapshot.data?[index]['fecha'] as Timestamp)
                                  .toDate(),
                            ),
                          )
                        else
                          Text('Fecha no disponible'),
                      ],
                    ),
                  ),
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
