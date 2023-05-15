import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '/pages/ingresar_page.dart';
import '/pages/pagina_inicial_page.dart';

import 'modelos/datos.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Clasificar Vecinos v0.6',
      theme: ThemeData(primarySwatch: Colors.deepOrange, useMaterial3: false),
      debugShowCheckedModeBanner: false,
      home: Datos.usuario > 0 ? PaginaInicialPage() : IngresarPage(),
    );
  }
}
