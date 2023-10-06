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
        ]),
      ),
    );
  }
}
