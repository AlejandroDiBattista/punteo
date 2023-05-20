import 'package:flutter/material.dart';

import '../colores.dart';
import '../modelos/datos.dart';
import 'pagina_inicial_page.dart';

class IngresarPage extends StatefulWidget {
  const IngresarPage({Key? key}) : super(key: key);

  @override
  _IngresarPageState createState() => _IngresarPageState();
}

class _IngresarPageState extends State<IngresarPage> {
  final _formKey = GlobalKey<FormState>();
  // late String _dni;
  bool cargando = false;
  final controlador = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: crearFondo(),
        alignment: Alignment.center,
        // color: Theme.of(context).primaryColorLight,r
        child: Container(
          width: 350,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                crearTitulo(context),
                crearVersion(context),
                SizedBox(height: 100.0),
                Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [crearIngresoDNI(), SizedBox(width: 10), crearIngresar()]),
                SizedBox(height: 16.0),
              ]),
            ),
          ),
        ),
      ),
    );
  }

  FilledButton crearIngresar() {
    return FilledButton(
      onPressed: ingresar,
      onLongPress: ingresarAlejandro,
      child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
          child: Text('Ingresar', style: TextStyle(fontSize: 16))),
    );
  }

  BoxDecoration crearFondo() => BoxDecoration(
          gradient: LinearGradient(
        colors: [
          Colores.comenzar,
          Colores.terminar,
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ));

  Text crearVersion(BuildContext context) =>
      Text("Versión ${Datos.version}", style: TextStyle(fontSize: 14, color: Theme.of(context).primaryColor));

  Text crearTitulo(BuildContext context) => Text("Punteo YB",
      style: TextStyle(
          fontSize: 50, color: Theme.of(context).primaryColor, fontFamily: "Oxanium", fontWeight: FontWeight.bold));

  Widget crearIngresoDNI() => Container(
        width: 150,
        child: TextFormField(
          keyboardType: TextInputType.number,
          controller: controlador,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18),
          decoration: InputDecoration(
            hintText: "Ingrese el DNI",
            filled: true,
            fillColor: Colors.white,
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(width: 1, color: Colors.grey),
            ),
          ),
          validator: validarDNI,
          onSaved: (value) {
            // Datos.usuario = int.parse(value!);
          },
        ),
      );

  void irPaginaInicio() {
    setState(() => this.cargando = true);
    print('antes: irPaginaInicio para ${Datos.usuario}');
    Datos.iniciar(() {
      print('despues: irPaginaInicio para ${Datos.usuario}');
      setState(() => this.cargando = false);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => PaginaInicialPage()));
    });
  }

  void ingresar() async {
    if (_formKey.currentState!.validate()) {
      irPaginaInicio();
    }
  }

  void ingresarAlejandro() {
    Datos.usuario = 18627585;
    irPaginaInicio();
  }

  String? validarDNI(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor ingrese un DNI';
    }
    final intDni = int.tryParse(value);
    if (intDni == null || intDni < 1000000 || intDni > 50000000) {
      return 'Por favor ingrese un DNI válido';
    }
    Datos.usuario = intDni;
    return null;
  }
}
