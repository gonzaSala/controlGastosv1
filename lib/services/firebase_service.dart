import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

Future<List> getValue() async {
  List gastos = [];

  CollectionReference collectionReferenceGastos = db.collection('gastos');

  QuerySnapshot queryGastos = await collectionReferenceGastos.get();

  queryGastos.docs.forEach((element) {
    gastos.add(element.data());
  });

  return gastos;
}
