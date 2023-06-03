import 'package:flutter/material.dart';

import '../modelos/datos.dart';

class UsuarioCard extends StatelessWidget {
  final bool compacto;
  const UsuarioCard({this.compacto = false});

  @override
  Widget build(BuildContext context) {
    final usuario = Datos.usuarioActual;
    final escuela = Datos.escuelaActual;

    final nombre = TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor);
    final destacar = TextStyle(fontSize: 16, fontWeight: FontWeight.bold);
    return Card(
      color: Colors.white,
      elevation: 8,
      child: Container(
        width: 380,
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(usuario.nombre, style: nombre),
            if (!compacto) ...[
              Text('DNI: ${usuario.dni}', style: TextStyle(fontSize: 20)),
              Divider(height: 1),
              Text(usuario.domicilio, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text('Clase : ${usuario.clase < 0 ? "~" : ""}${usuario.clase.abs()}'),
                Text('Sexo : ${usuario.sexo == "M" ? "Masculino" : "Femenino"}'),
              ]),
            ],
            Divider(height: 1),
            Text(escuela.escuela, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Row(children: [
              Text(escuela.direccion, style: TextStyle(fontSize: 14)),
              Icon(Icons.location_on, color: Colors.red, size: 12)
            ]),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('Mesa : ${usuario.mesa}', style: destacar),
              Text('Orden: ${usuario.orden}', style: destacar)
            ]),
          ],
        ),
      ),
    );
  }
}
