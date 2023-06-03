import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:math';

import 'colores.dart';
import 'modelos/votante.dart';

extension DateTimeUtils on DateTime {
  String get fecha => DateFormat('dd/MM/yyyy').format(this);
  String get hora => DateFormat('HH:mm:ss').format(this);
  String get fechaHora => DateFormat('dd/MM/yyyy HH:mm:ss').format(this);
}

extension UtilesString on String {
  String get sinEspacios => this.trim().replaceAll(RegExp('\\s+'), ' ');
  String get sinAcentos => this
      .replaceAll('á', 'a')
      .replaceAll('é', 'e')
      .replaceAll('í', 'i')
      .replaceAll('ó', 'o')
      .replaceAll('ú', 'u')
      .replaceAll('Á', 'A')
      .replaceAll('É', 'E')
      .replaceAll('Í', 'I')
      .replaceAll('Ó', 'O')
      .replaceAll('Ú', 'U');

  List<String> get palabras => this.sinEspacios.split(' ').map((p) => p.sinAcentos).toList();
  bool contienePalabras(List<String> palabras) => palabras.every((palabra) => this.contains(palabra));
}

extension UtilesInt on int {
  String info([String singular = '', String? plural, String? vacio]) =>
      switch (this) { 0 => vacio ?? '', 1 => '$this $singular', _ => '$this ${plural ?? singular + 's'}' };
}

extension UtilesBool on bool {
  String info([String si = 'Si', String no = 'No']) => this ? si : no;
}

extension ListRandomExtension<E> on List<E> {
  E getRandomElement() {
    if (isEmpty) {
      throw Exception('La lista está vacía');
    }

    Random random = Random();
    int randomIndex = random.nextInt(length);
    return this[randomIndex];
  }
}

void medir(String mensaje, Function ejecutar) {
  final reloj = Stopwatch()..start();
  print('> $mensaje');
  ejecutar();
  reloj.stop();
  print('- (${reloj.elapsedMilliseconds}ms)');
}

AppBar crearTitulo(Widget titulo, {List<Widget>? actions}) => AppBar(
    title: titulo,
    centerTitle: true,
    flexibleSpace: Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
        colors: [Colores.comenzar, Colores.terminar],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      )),
    ),
    actions: actions);

BoxDecoration crearFondo() => BoxDecoration(
        gradient: LinearGradient(
      colors: [Colores.comenzar, Colores.terminar],
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    ));

Widget crearDomicilio(Votante votante) => Row(children: [
      Text(votante.domicilio),
      if (votante.longitude != 0) Icon(Icons.location_on, color: Colors.red, size: 14)
    ]);

Widget intencionVoto(Votante votante, {double ancho = 100}) {
  Widget sector(double ancho, Color color) => Container(width: ancho, height: 2, color: color);

  if (votante.cyb == 0 || votante.pj == 0) return sector(ancho, Colors.grey);
  final ajuste = ancho / (votante.pj + votante.ucr + votante.cyb);
  return Row(
    children: [
      sector(ajuste * votante.pj, Colors.blue),
      sector(ajuste * votante.ucr, Colors.red),
      sector(ajuste * votante.cyb, Colors.amber)
    ],
  );
}

double distanciaEnMetros(double lat1, double lon1, double lat2, double lon2) {
  double deg2rad(double deg) => deg * (pi / 180);
  double r = 6371000; // Radio de la Tierra en km
  double dLat = deg2rad(lat2 - lat1); // Diferencia de latitud en radianes
  double dLon = deg2rad(lon2 - lon1); // Diferencia de longitud en radianes
  double a = pow(sin(dLat / 2), 2) + cos(deg2rad(lat1)) * cos(deg2rad(lat2)) * pow(sin(dLon / 2), 2);
  double c = 2 * atan2(sqrt(a), sqrt(1 - a));
  double distance = r * c; // Distancia en metros
  return distance;
}
