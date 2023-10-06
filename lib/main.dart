import 'package:app_control_gastos/screens/addValue.dart';
import 'package:flutter/material.dart';

//FIREBASE
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
//HOME
import 'package:app_control_gastos/screens/homePage.dart';
import 'package:app_control_gastos/screens/addValue.dart';
//SERVICES

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(),
        '/add': (context) => AddNewExpense(),
      },
    );
  }
}
