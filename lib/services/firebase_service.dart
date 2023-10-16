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

Future<double> calculateTotalExpensesForMonth(
    List gastos, DateTime month) async {
  double total = 0.0;
  for (final expense in gastos) {
    final DateTime fecha = expense['fecha'].toDate();
    if (fecha.year == month.year && fecha.month == month.month) {
      total += expense['valor'];
    }
  }
  return total;
}

Future<List<double>> calculateWeeklyExpenses() async {
  List gastos = await getValue();
  final now = DateTime.now();
  final startOfWeek = DateTime(
      now.year,
      now.month,
      now.day -
          now.weekday); // Ajusta para obtener el comienzo de la semana actual

  final weeklyTotals = List<double>.generate(7, (day) {
    final dayOfWeek = startOfWeek.add(Duration(days: day));
    final totalForDay = gastos.where((expense) {
      final expenseDate = expense['fecha'].toDate();
      return expenseDate.isAfter(dayOfWeek) &&
          expenseDate.isBefore(dayOfWeek.add(Duration(days: 1)));
    }).fold(0.0, (sum, expense) => sum + expense['valor']);
    return totalForDay;
  });

  return weeklyTotals;
}
