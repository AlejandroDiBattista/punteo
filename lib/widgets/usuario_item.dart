import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:punteo_yb/utils.dart';

import '/colores.dart';
import '/modelos/datos.dart';
import '/modelos/favorito.dart';
import '/modelos/votante.dart';

class UsuarioItem extends StatelessWidget {
  const UsuarioItem({
    super.key,
    required this.usuario,
  });

  final Votante usuario;

  @override
  Widget build(BuildContext context) {
    final sesiones = Favorito.calcularSesiones(usuario.dni);
    final tiempo = Favorito.calcularMinutosTrabajado(usuario.dni);
    final activo = Favorito.esUsuarioActivo(usuario.dni);
    final ultimoAcceso = Favorito.ultimoAcceso(usuario.dni);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${usuario.nombre}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              Text('${Datos.cantidadFavoritos(usuario.dni)} favoritos',
                  style: TextStyle(fontSize: 14, color: Colores.terminar)),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text('DNI ${usuario.dni} - ${usuario.domicilio} '),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Text("${sesiones.length} sesiones, $tiempo minutos",
                style: TextStyle(fontSize: 16, color: Colores.terminar)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Text(activo ? "En línea" : "Último acceso ${ultimoAcceso.fechaHora}",
                style: TextStyle(fontSize: 16, color: activo ? Colors.red : Colors.black)),
          ),
        ],
      ),
    );
  }
}
