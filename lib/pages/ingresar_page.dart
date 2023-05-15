import 'package:flutter/material.dart';
import '../modelos/datos.dart';
import 'pagina_inicial_page.dart';

class IngresarPage extends StatefulWidget {
  const IngresarPage({Key? key}) : super(key: key);

  @override
  _IngresarPageState createState() => _IngresarPageState();
}

class _IngresarPageState extends State<IngresarPage> {
  final _formKey = GlobalKey<FormState>();
  late String _dni;
  bool cargando = false;

  void irPaginaInicio() {
    setState(() => cargando = true);
    Datos.cargar().then((value) {
      setState(() => cargando = false);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => PaginaInicialPage()),
      );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
        'Punteo de votantes',
        style: TextStyle(fontSize: 30, color: Theme.of(context).primaryColor),
      )),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Container(
              width: 300,
              height: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Punteo YB", style: TextStyle(fontSize: 30, color: Theme.of(context).primaryColor)),
                  SizedBox(height: 30.0),
                  Text("Ingresar"),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: 'DNI', hintText: 'Ingrese su DNI'),
                    validator: validarDNI,
                    onSaved: (value) {
                      _dni = value!;
                    },
                  ),
                  SizedBox(height: 16.0),
                  this.cargando
                      ? CircularProgressIndicator()
                      : FilledButton(
                          onPressed: ingresar,
                          onLongPress: ingresarAlejandro,
                          child: Text('Ingresar'),
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
