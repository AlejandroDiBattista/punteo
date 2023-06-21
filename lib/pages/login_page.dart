// import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:punteo_yb/pages/menu_page.dart';

import '/modelos/datos.dart';
import '/utils.dart';
import '/widgets/boton_widget.dart';
import '/widgets/caratula_widtget.dart';
import '/widgets/progreso_widget.dart';
import '/widgets/version_widget.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  LoginPageState createState() => LoginPageState();
}

enum Estados {
  cargando,
  ingresando,
  ingresado,
}

class LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  Estados estado = Estados.cargando;
  final controlador = TextEditingController();

  @override
  void initState() {
    this.estado = Estados.cargando;
    Datos.cargar().then((_) async {
      if (Datos.usuario != 0) irPaginaInicio();
      this.estado = Estados.ingresando;
      actualizar();
    });
    super.initState();
  }

  void actualizar() => setState(() {});

  @override
  Widget build(BuildContext context) => SafeArea(
        child: Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
          body: Container(
            decoration: crearFondo(),
            child: Column(
              children: [
                Caratula(),
                Progreso(estado == Estados.cargando),
                Spacer(),
                if (estado == Estados.ingresando) crearIngreso(),
                Spacer(),
                Version(),
              ],
            ),
          ),
        ),
      );

  Widget crearIngreso() =>
      Row(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [
        crearIngresoDNI(),
        SizedBox(width: 10),
        Boton(
          icon: Icons.login,
          label: 'Ingresar',
          onPressed: ingresar,
          onLongPress: ingresarAlejandro,
        ),
      ]);

  Widget crearIngresoDNI() => Container(
        width: 150,
        child: TextFormField(
          keyboardType: TextInputType.number,
          controller: controlador,
          style: TextStyle(fontSize: 20),
          decoration: InputDecoration(
            hintText: "Ingrese DNI",
            filled: true,
            fillColor: Colors.white,
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(width: 1, color: Colors.grey),
            ),
          ),
          validator: validarDNI,
          // onSaved: (value) => Datos.usuario = int.parse(value!)
        ),
      );

  void cerrarSesion() => setState(() {
        Datos.usuario = 0;
        this.estado = Estados.ingresando;
        controlador.text = "";
      });

  void irPaginaInicio() async {
    Get.to(MenuPage());
  }

  void ingresar() async {
    final valor = controlador.text ?? "";
    final dni = int.tryParse(valor);
    if (dni != null && dni >= 1000000 && dni <= 50000000) {
      Datos.usuario = dni;
      irPaginaInicio();
    } else {
      Get.snackbar(
        'Ingreso al sistema',
        'Debe ingresar un DNI entre 10.000.000 y 50.000.000',
        icon: Icon(Icons.error, color: Colors.red),
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 4),
        dismissDirection: DismissDirection.horizontal,
      );
    }

    // if (_formKey.currentState!.validate()) {
    // }
  }

  void ingresarAlejandro() {
    Datos.usuario = 18627585;
    irPaginaInicio();
  }

  String? validarDNI(String? value) {
    if (value == null || value.isEmpty) return 'Debe ingresar DNI';

    final dni = int.tryParse(value);
    if (dni == null || dni < 1000000 || dni > 50000000) return 'Debe ingresar DNI';

    Datos.usuario = dni;
    return null;
  }
}
