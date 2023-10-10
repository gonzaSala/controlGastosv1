import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

Future<List> getValue() async {
  List gastos = [];

  CollectionReference collectionReferenceGastos = db.collection('gastos');

  QuerySnapshot queryGastos = await collectionReferenceGastos.get();

  for (var doc in queryGastos.docs) {
    final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    print('Fecha en Firestore: ${data['fecha']}');
    final expense = {
      'nombre': data['nombre'],
      'valor': data['valor'],
      'uID': doc.id,
      'fecha': data['fecha'],
    };

    gastos.add(expense);
  }
  return gastos;
}

Future<void> addExpense(String name, int value) async {
  final DateTime now = DateTime.now();
  final Timestamp timestamp = Timestamp.fromDate(now);

  print('Fecha a guardar: $now');

  await db.collection('gastos').add({
    'nombre': name,
    'valor': value,
    'fecha': DateTime.now(),
  });
}

Future<void> deleteExpense(String uID) async {
  await db.collection('gastos').doc(uID).delete();
}

Future<double> calculateTotalExpense() async {
  List gastos = await getValue();
  double total = 0;

  for (var gasto in gastos) {
    total += gasto['valor'];
  }

  return total;
}
