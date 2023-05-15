import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myapp/pages/ingresar_page.dart';
// import 'package:flutter/services.dart';
// import 'pages/escuela_widget.dart';
// import './pages/votantes_page.dart';
import './pages/escuelas_page.dart';
import 'sheets_api.dart';

import 'modelos/datos.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  Datos.cargar();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Clasificar Vecinos v0.5',
      theme: ThemeData(primarySwatch: Colors.green, useMaterial3: false),
      debugShowCheckedModeBanner: false,
      home: IngresarPage(),
    );
  }
}
