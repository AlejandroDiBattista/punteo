import 'package:flutter/material.dart';

import '../modelos/datos.dart';
import '../modelos/escuela.dart';
import '../modelos/votante.dart';

class UsuarioCard extends StatelessWidget {
  final Votante usuario;
  final bool compacto;
  final bool referidos;
  final bool escuela;

  const UsuarioCard(this.usuario, {this.compacto = false, this.referidos = false, this.escuela = false});

  @override
  Widget build(BuildContext context) {
    // final usuario = Datos.usuarioActual;
    final nombre = TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor);
    final vota = Escuela.traer(usuario.mesa);
    final destacar = TextStyle(fontSize: 16, fontWeight: FontWeight.bold);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 380,
          child: Card(
            color: Colors.white,
            elevation: 8,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(usuario.nombre, style: nombre),
                  SizedBox(height: compacto ? 4 : 12),
                  if (!compacto) ...[
                    Text('DNI: ${usuario.dni}', style: TextStyle(fontSize: 18)),
                    Divider(height: 1),
                    Text(usuario.domicilio, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Text('Clase : ${usuario.clase < 0 ? "~" : ""}${usuario.clase.abs()}'),
                      Text('Sexo : ${usuario.sexo == "M" ? "Masculino" : "Femenino"}'),
                    ]),
                    Divider(height: 1),
                  ],
                  if (escuela) ...[
                    SizedBox(height: compacto ? 4 : 12),
                    Text(vota.escuela, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Row(children: [
                      Text(vota.direccion, style: TextStyle(fontSize: 14)),
                      Icon(Icons.location_on, color: Colors.red, size: 12)
                    ]),
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Text('Mesa : ${usuario.mesa}', style: destacar),
                      Text('Orden: ${usuario.orden}', style: destacar)
                    ]),
                  ],
                  if (referidos) ...[
                    SizedBox(height: 8),
                    Divider(height: 1),
                    SizedBox(height: 4),
                    ...mostrarReferidos(),
                  ],
                  // Text("U:${usuario.conUbicacion},${usuario.esUbicable} | ${usuario.calle} -> ${usuario.altura} ")
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> mostrarReferidos() {
    var ref = usuario.referentes.map((r) => Datos.traerUsuario(r)).toList();
    ref.sort((a, b) => a.nombre.compareTo(b.nombre));
    print("> LISTADO DE REFERENTES");
    ref.forEach((r) => print("- $r"));
    if (ref.length == 0) return [];
    return [
      Text("Referidos por ${usuario.referentes.length}", style: TextStyle(fontWeight: FontWeight.bold)),
      Container(
        width: 300,
        height: ref.length * 20,
        child: ListView.builder(itemCount: ref.length, itemBuilder: (a, i) => Text('${i + 1} ${ref[i].nombre}')),
      )
    ];
  }
}
