import 'package:flutter/material.dart';

import '../colores.dart';
import '../modelos/datos.dart';
import '../widgets/progreso_widget.dart';
import 'pagina_inicial_page.dart';

class IngresarPage extends StatefulWidget {
  const IngresarPage({Key? key}) : super(key: key);

  @override
  _IngresarPageState createState() => _IngresarPageState();
}

class _IngresarPageState extends State<IngresarPage> {
  final _formKey = GlobalKey<FormState>();
  bool cargando = false;
  final controlador = TextEditingController();

  @override
  void initState() {
    this.cargando = true;
    print("IngresarPage.initState");
    Datos.cargar().then((_) {
      setState(() => this.cargando = false);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: crearFondo(),
          alignment: Alignment.center,
          child: Container(
            width: 350,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  // this.cargando
                  //     ? LinearProgressIndicator(backgroundColor: Colores.terminar, minHeight: 1)
                  //     : SizedBox(height: 2),
                  Progreso(this.cargando),
                  Expanded(child: Container()),
                  crearTitulo(context),
                  crearVersion(context),
                  SizedBox(height: 100.0),
                  Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [crearIngresoDNI(), SizedBox(width: 10), crearIngresar()]),
                  Expanded(child: Container()),
                ]),
              ),
            ),
          ),
        ),
      ),
    );
  }

  FilledButton crearIngresar() {
    return FilledButton.tonal(
      onPressed: ingresar,
      onLongPress: ingresarAlejandro,
      child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
          // child: Text('Ingresar', style: TextStyle(fontSize: 16))),
          child: Text('Ingresar', style: TextStyle(fontSize: 16))),
    );
  }

  BoxDecoration crearFondo() => BoxDecoration(
          gradient: LinearGradient(
        colors: [Colores.comenzar, Colores.terminar],
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

  void irPaginaInicio() async {
    setState(() => this.cargando = true);
    print('antes: irPaginaInicio para ${Datos.usuario}');

    // await Datos.cargar();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => PaginaInicialPage()));
    // });
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
