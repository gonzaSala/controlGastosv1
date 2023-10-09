import 'package:flutter/material.dart';
import 'package:app_control_gastos/services/firebase_service.dart';

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
                    color: Colors.red,
                    child: const Icon(Icons.delete),
                  ),
                  direction: DismissDirection.endToStart,
                  child: ListTile(
                    title: Text(
                        snapshot.data?[index]['nombre'] ?? ''), // Cambio aquí
                    onTap: () async {
                      await Navigator.pushNamed(context, '/edit', arguments: {
                        'nombre': snapshot.data?[index]['nombre'],
                        'uID': snapshot.data?[index]['uID'],
                      });
                      setState(() {});
                    },
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
