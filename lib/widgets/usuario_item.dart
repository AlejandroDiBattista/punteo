import 'package:flutter/material.dart';

import '/colores.dart';
import '/modelos/datos.dart';
import '/modelos/favorito.dart';
import '/modelos/votante.dart';

class UsuarioItem extends StatelessWidget {
  const UsuarioItem({super.key, required this.usuario, required this.index});

  final Votante usuario;
  final int index;

  @override
  Widget build(BuildContext context) {
    final sesiones = Favorito.calcularSesiones(usuario.dni);
    final tiempo = Favorito.calcularMinutosTrabajado(usuario.dni);
    final activo = Favorito.esUsuarioActivo(usuario.dni);
    final ultimoAcceso = Favorito.ultimoAcceso(usuario.dni);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      child: Row(
        children: [
          Center(
              child: switch (index) {
            0 => Icon(Icons.military_tech, color: Colors.yellow[600]),
            1 => Icon(Icons.military_tech, color: Colors.grey),
            2 => Icon(Icons.military_tech, color: Colors.orange),
            _ => Text("${index + 1}")
          }),
          SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${usuario.nombre}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  FittedBox(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text('  ${Datos.cantidadFavoritos(usuario.dni)}  ',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20,
                              color: Colores.terminar,
                            )),
                        Icon(Icons.star, color: Colors.yellow, size: 16),
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Row(
                  children: [
                    Text('DNI ${usuario.dni} - ${usuario.domicilio} '),
                    if (usuario.longitude != 0) Icon(Icons.location_on, color: Colors.red, size: 14),
                  ],
                ),
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
                    style: TextStyle(fontSize: 16, color: activo ? Colors.red : Colors.black)),
              ),
            ],
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
