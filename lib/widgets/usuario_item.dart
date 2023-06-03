import 'package:flutter/material.dart';
import '/utils.dart';

// import '/modelos/datos.dart';
import '/modelos/favorito.dart';
import '/modelos/votante.dart';

class UsuarioItem extends StatelessWidget {
  const UsuarioItem({super.key, required this.usuario, required this.index});

  final Votante usuario;
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
              ])
            ]),
            favorito()
          ]),
        ]));
  }

  Widget acceso() {
    final activo = Favorito.esUsuarioActivo(usuario.dni);
    final ultimoAcceso = Favorito.ultimoAcceso(usuario.dni);
    final estilo = TextStyle(fontSize: 16, color: activo ? Colors.red : Colors.black);

    return Text(activo ? 'En línea ahora' : 'Hace ${fecha(ultimoAcceso)}', style: estilo);
  }

  Widget sesiones() {
    final cantidad = Favorito.calcularSesiones(usuario.dni).length;
    final tiempo = Favorito.calcularMinutosTrabajado(usuario.dni);

    return Text("${cantidad.info('sesión', 'sesiones')} | ${minutos(tiempo)}",
        style: TextStyle(fontSize: 16, color: Colors.blue));
  }

  Widget domicilio() => Row(children: [
        Text('DNI ${usuario.dni} | '),
        Text(usuario.domicilio, style: TextStyle(fontSize: 12)),
        Icon(Icons.location_on, color: usuario.conUbicacion ? Colors.red : Colors.grey, size: 12)
      ]);

  Widget nombre() => SizedBox(
      width: 280, child: Text('${usuario.nombre}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)));

  Widget podio(int posicion) => switch (posicion) {
        0 => Icon(Icons.military_tech, color: Colors.yellow[600]),
        1 => Icon(Icons.military_tech, color: Colors.grey),
        2 => Icon(Icons.military_tech, color: Colors.orange),
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

  return '${days.info('día')} ${hours.info('hora')}'.trim();
}
