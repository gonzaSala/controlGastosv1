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

Future<List> getExpensesForMonth(DateTime month) async {
  List gastos = await getValue();
  return gastos.where((expense) {
    final DateTime fecha = expense['fecha'].toDate();
    return fecha.year == month.year && fecha.month == month.month;
  }).toList();
}

double calculateTotalExpensesForMonth(List gastos, DateTime month) {
  double total = 0.0;
  for (final expense in gastos) {
    final DateTime fecha = expense['fecha'].toDate();
    if (fecha.year == month.year && fecha.month == month.month) {
      total += expense['valor'];
    }
  }
  return total;
}

List<double> calculateWeeklyExpenses(List gastos) {
  final now = DateTime.now();
  final daysOfWeek = [
    DateTime.monday,
    DateTime.tuesday,
    DateTime.wednesday,
    DateTime.thursday,
    DateTime.friday,
    DateTime.saturday,
    DateTime.sunday
  ];

  // Asegúrate de que 'gastos' tenga elementos antes de continuar
  if (gastos.isNotEmpty) {
    return daysOfWeek.map((day) {
      final totalForDay = gastos
          .where((expense) => expense['fecha'].toDate().weekday == day)
          .fold(0.0, (sum, expense) => sum + expense['valor']);
      return totalForDay;
    }).toList();
  } else {
    // Si 'gastos' está vacío, devuelve una lista de ceros o maneja el caso vacío según tus necesidades.
    return List.filled(7, 0.0);
  }
}
