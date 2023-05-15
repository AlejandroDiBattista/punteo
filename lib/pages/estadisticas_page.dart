import 'package:flutter/material.dart';
import 'package:myapp/pages/ingresar_page.dart';
import '../modelos/datos.dart';

class EstadisticasPage extends StatelessWidget {
  const EstadisticasPage({key});

  @override
  Widget build(BuildContext context) {
    final usuario = Datos.usuarioActual;
    final escuela = Datos.escuelaActual;
    return Scaffold(
      appBar: AppBar(title: Text('Estadisticas')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(child: SizedBox()),
          Text(usuario.nombre,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor)),
          Text('DNI: ${usuario.dni}', style: TextStyle(fontSize: 20)),
          Divider(),
          Text('Domilicio: ${usuario.domicilio}'),
          Text('Año nacimiento : ${usuario.clase}'),
          Text('Sexo: ${usuario.sexo}'),
          Divider(),
          Text('Escuela  : ${escuela.escuela}'),
          Text('Dirección: ${escuela.direccion}'),
          Text('Mesa : ${usuario.mesa}'),
          Text('Orden: ${usuario.orden}'),
          Divider(),
          Text('Escuelas Completas: ${Datos.cantidadEscuelasCompletas}'),
          Text('Mesas: ${Datos.cantidadMesas}'),
          Text('Mesas Cerradas: ${Datos.cantidadMesasCerradas}'),
          Divider(),
          Text('Votantes: ${Datos.cantidadVotantes}'),
          Text('- Analizados: ${Datos.cantidadVotantesAnalizados}'),
          Text('- Marcados: ${Datos.cantidadVotantesMarcados}'),
          Expanded(child: SizedBox()),
          FilledButton(onPressed: () => cerrarSesion(context), child: Text('Cerrar Sesión')),
          SizedBox(height: 20)
        ],
      ),
    );
  }

  void cerrarSesion(BuildContext context) {
    Datos.usuario = 0;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => IngresarPage()),
    );
  }
}
