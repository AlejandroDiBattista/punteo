import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'modelos/datos.dart';
import 'pages/ingresar_page.dart';

import 'colores.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // await Datos.cargar();
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
        navigationBarTheme: NavigationBarThemeData(backgroundColor: Colores.comenzar),
        useMaterial3: true,
        // colorSchemeSeed: Colores.terminar,
        colorSchemeSeed: Colores.comenzar,
        // colorSchemeSeed: Colors.red,
      ),
      home: const IngresarPage(),
    );
  }
}
