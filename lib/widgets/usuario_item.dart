import 'package:flutter/cupertino.dart';

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

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${usuario.nombre}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text('${Datos.cantidadFavoritos(usuario.dni)} favoritos',
                  style: TextStyle(fontSize: 14, color: Colores.comenzar)),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text('DNI ${usuario.dni} - ${usuario.domicilio} '),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text("${sesiones.length} sesiones, $tiempo minutos ${activo ? '(activo)' : ''}",
                style: TextStyle(fontSize: 16, color: Colores.comenzar)),
          ),
        ],
      ),
    );
  }
}
