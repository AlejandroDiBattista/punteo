import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

// import 'pages/encuesta_page.dart';
import 'colores.dart';
import 'modelos/datos.dart';
import 'pages/ingresar_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        title: 'Punteo YB ${Datos.version}',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          appBarTheme: AppBarTheme(color: Colores.comenzar),
          colorSchemeSeed: Colors.green,
          // colorSchemeSeed: Colores.comenzar,
          useMaterial3: true,
        ),
        home: const IngresarPage());
    // home: const EncuestaPage());
  }
}
