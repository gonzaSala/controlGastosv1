import 'package:app_control_gastos/screens/addValue.dart';
import 'package:app_control_gastos/screens/historial.dart';
import 'package:app_control_gastos/screens/chartPage.dart';

import 'package:flutter/material.dart';

//FIREBASE
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
//HOME
import 'package:app_control_gastos/screens/homePage.dart';
import 'package:app_control_gastos/screens/addValue.dart';
//SERVICES
import 'package:responsive_framework/responsive_framework.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
            backgroundColor: Color.fromARGB(146, 63, 28, 180)),
        primaryColor: Colors.black87, // Color principal de la aplicación
        hintColor: Color.fromARGB(255, 171, 190, 90), // Color de resaltado
        fontFamily: 'Roboto', // Tipo de fuente predeterminado
        textTheme: TextTheme(
          // Establece la tipografía para diferentes partes de la aplicación
          headline6: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      builder: (context, child) => ResponsiveWrapper.builder(child,
          maxWidth: 2460,
          minWidth: 480,
          defaultScale: true,
          breakpoints: [
            const ResponsiveBreakpoint.resize(480, name: MOBILE),
            const ResponsiveBreakpoint.autoScale(800, name: TABLET),
            const ResponsiveBreakpoint.resize(1080, name: DESKTOP),
            const ResponsiveBreakpoint.autoScale(2460, name: '4k'),
          ],
          background: Container(color: Color.fromARGB(255, 44, 42, 42))),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/add': (context) => const AddNewExpense(),
        '/his': (context) => const Historial(),
        '/chart': (context) => const chartPage(),
      },
    );
  }
}
