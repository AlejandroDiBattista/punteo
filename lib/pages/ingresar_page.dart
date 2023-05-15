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

  void _ingresar() async {
    if (_formKey.currentState!.validate()) {
      await Datos.marcar();

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => PaginaInicialPage(cantidadVotantesAnalizados: 1, cantidadVotantesMarcados: 3)),
      );
    }
  }

  String? _validarDni(String? value) {
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
      appBar: AppBar(title: Text('Ingreso de DNI')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'DNI',
                  hintText: 'Ingrese su DNI',
                ),
                validator: _validarDni,
                onSaved: (value) {
                  _dni = value!;
                },
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _ingresar,
                child: Text('Ingresar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
