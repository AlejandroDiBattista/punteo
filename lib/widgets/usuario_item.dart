import 'package:flutter/material.dart';

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
              FittedBox(
                child: Row(
                  children: [
                    Text('${Datos.cantidadFavoritos(usuario.dni)}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colores.terminar,
                        )),
                    Icon(Icons.star, color: Colors.yellow, size: 20),
                  ],
                ),
              ),
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
            child: Text(
                activo
                    ? 'En línea ahora'
                    : 'Último acceso hace ${calculateDateDifference(ultimoAcceso, DateTime.now())} ',
                // Text(activo ? "En línea" : "Último acceso ${ultimoAcceso.fechaHora}",
                style: TextStyle(fontSize: 16, color: activo ? Colors.red : Colors.black)),
          ),
        ],
      ),
    );
  }
}

String calculateDateDifference(DateTime startDate, DateTime endDate) {
  Duration difference = endDate.difference(startDate);

  int days = difference.inDays;
  int hours = difference.inHours % 24;

  return '$days días y $hours horas';
}
