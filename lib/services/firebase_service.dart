import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

Future<List> getValue() async {
  List gastos = [];

  CollectionReference collectionReferenceGastos = db.collection('gastos');

  QuerySnapshot queryGastos = await collectionReferenceGastos.get();

  for (var doc in queryGastos.docs) {
    final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    final expense = {
      'nombre': data['nombre'],
      'valor': data['valor'],
      'uID': doc.id,
    };

    gastos.add(expense);
  }
  return gastos;
}

Future<void> addExpense(String name, int value) async {
  await db.collection('gastos').add({'nombre': name, 'valor': value});
}

Future<void> deleteExpense(String uID) async {
  await db.collection('gastos').doc(uID).delete();
}
