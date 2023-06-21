import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/modelos/usuario.dart';
import '/utils.dart';

class UsuarioItem extends StatelessWidget {
  const UsuarioItem({super.key, required this.usuario, required this.index});

  final Usuario usuario;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        child: Row(children: [
          podio(index),
          SizedBox(width: 10),
          Row(children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.max, children: [
              nombre(),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                domicilio(),
                sesiones(),
                acceso(),
                extras(),
                mesasPrioritarias(),
              ])
            ]),
            favorito()
          ]),
        ]));
  }

  Widget acceso() {
    final estilo = TextStyle(fontSize: 16, color: usuario.activo ? Colors.red : Colors.black);

    return Text(usuario.activo ? 'En línea ahora' : 'Hace ${fecha(usuario.ultimoAcceso)}', style: estilo);
  }

  Widget sesiones() => Text("${usuario.cantidadSesiones.info('sesión')} | ${minutos(usuario.tiempoTrabajado)}",
      style: TextStyle(fontSize: 16, color: Colors.blue));

  Widget extras() => Text("Analizados: ${usuario.cantidadAnalizados} | Cerradas: ${usuario.mesasCerradas}",
      style: TextStyle(fontSize: 14, color: Colors.blue));

  Widget mesasPrioritarias() =>
      Text(usuario.mesasPendientes.info("Falta # mesa", "Faltan # mesas", "Mesas prioritarias completas 👏🏼👏🏼"),
          style: TextStyle(fontSize: 16, color: usuario.mesasPendientes > 0 ? Colors.red : Colors.green));

  Widget domicilio() => SizedBox(
      width: Get.width - 120,
      child: Row(children: [
        Text('DNI ${usuario.dni} | '),
        Text(usuario.domicilio, style: TextStyle(fontSize: 12)),
        Icon(Icons.location_on, color: usuario.conUbicacion ? Colors.red : Colors.grey, size: 12)
      ]));

  Widget nombre() => SizedBox(
      width: Get.width - 120,
      child: Text('${usuario.nombre}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)));

  Widget podio(int posicion) => switch (posicion) {
        < 0 => Icon(Icons.workspace_premium, color: Colors.yellow[700]),
        0 => Icon(Icons.military_tech, color: Colors.yellow[700]),
        1 => Icon(Icons.military_tech, color: Colors.grey),
        2 => Icon(Icons.military_tech, color: Colors.orange[800]),
        _ => SizedBox(width: 24, child: Text("${posicion + 1}", textAlign: TextAlign.center))
      };

  Widget favorito() {
    final favoritos = usuario.favoritos.length;
    final destacar = TextStyle(fontSize: 24, color: Colors.blue);
    return Row(
      children: [Text('$favoritos', style: destacar), SizedBox(width: 4), Icon(Icons.star, color: Colors.amber)],
    );
  }
}

String minutos(int tiempo) {
  final h = (tiempo / 60).truncate();
  final m = tiempo % 60;
  return '${h.info('hora')} ${m.info('minuto')}'.trim();
}

String fecha(DateTime startDate) {
  DateTime endDate = DateTime.now();
  Duration difference = endDate.difference(startDate);

  int days = difference.inDays;
  int hours = difference.inHours % 24;
  int minutes = difference.inMinutes % 60;
  if (difference.inMinutes < 60) return minutes.info('minuto');
  return '${days.info('día')} ${hours.info('hora')}'.trim();
}
