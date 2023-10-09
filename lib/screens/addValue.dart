import 'package:app_control_gastos/services/firebase_service.dart';
import 'package:flutter/material.dart';

class AddNewExpense extends StatefulWidget {
  const AddNewExpense({super.key});

  @override
  _AddNewExpenseState createState() => _AddNewExpenseState();
}

class _AddNewExpenseState extends State<AddNewExpense> {
  TextEditingController newExpenseControlName = TextEditingController();
  TextEditingController newExpenseControlCantidad = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Añadir nuevo gasto'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(children: [
          TextField(
            controller: newExpenseControlCantidad,
            decoration: const InputDecoration(hintText: 'Ingrese el monto'),
          ),
          TextField(
            controller: newExpenseControlName,
            decoration: const InputDecoration(hintText: 'Ingrese el nombre'),
          ),
          ElevatedButton(
              onPressed: () async {
                await addExpense(newExpenseControlName.text,
                        int.parse(newExpenseControlCantidad.text))
                    .then((_) {
                  Navigator.pop(context);
                });
              },
              child: Text('Guardar')),
          ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancelar')),
        ]),
      ),
    );
  }
}
