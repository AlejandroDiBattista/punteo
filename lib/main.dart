import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '/pages/ingresar_page.dart';
import 'modelos/datos.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  print("ANTES");
  await Datos.cargar();
  print("DESPUES");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Punteo YB v${Datos.version}',
      theme: ThemeData(primarySwatch: Colors.green, useMaterial3: false),
      debugShowCheckedModeBanner: false,
      home: IngresarPage(),
    );
  }
}
