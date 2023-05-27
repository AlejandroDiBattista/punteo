import 'package:flutter/material.dart';

import '../modelos/datos.dart';

class UsuarioCard extends StatelessWidget {
  final bool compacto;
  const UsuarioCard({this.compacto = false});

  @override
  Widget build(BuildContext context) {
    final usuario = Datos.usuarioActual;
    final escuela = Datos.escuelaActual;

    final nombre = TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor);
    return Card(
      color: Colors.white,
      elevation: 8,
      child: Container(
        width: 380,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(usuario.nombre, style: nombre),
            if (!compacto) ...[
              Text('DNI: ${usuario.dni}', style: TextStyle(fontSize: 20)),
              Divider(),
              Text(usuario.domicilio, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text('Clase : ${usuario.clase < 0 ? "~" : ""}${usuario.clase.abs()}'),
                Text('Sexo : ${usuario.sexo == "M" ? "Masculino" : "Femenino"}'),
              ]),
            ],
            Divider(),
            Text(escuela.escuela, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text(escuela.direccion, style: TextStyle(fontSize: 16)),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('Mesa : ${usuario.mesa}', style: TextStyle(fontSize: 18)),
              Text('Orden: ${usuario.orden}', style: TextStyle(fontSize: 18))
            ]),
          ],
        ),
      ),
    );
  }
}
