import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:math';

import 'colores.dart';

extension DateTimeUtils on DateTime {
  String get fecha => DateFormat('dd/MM/yyyy').format(this);
  String get hora => DateFormat('HH:mm:ss').format(this);
  String get fechaHora => DateFormat('dd/MM/yyyy HH:mm:ss').format(this);
}

extension Utiles on String {
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

void medir(String mensaje, Function ejecutar) {
  final reloj = Stopwatch()..start();
  print('> $mensaje');
  ejecutar();
  reloj.stop();
  print("- (${reloj.elapsedMilliseconds}ms)");
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

// double distanciaEnMetros1(double lat1, double lon1, double lat2, double lon2) {
//   double x = (lon2 - lon1) * cos((lat1 + lat2) / 2);
//   double y = lat2 - lat1;
//   double distance = sqrt(x * x + y * y) * 111.319; // Factor de escala para convertir a kilómetros
//   return distance;
// }

// double distanciaAproximadaEnMetros(double lat1, double lon1, double lat2, double lon2) {
//   double dx = (lon1 - lon2) * 99168;
//   double dy = (lat1 - lat2) * 111101;
  // return sqrt(dx * dx + dy * dy);
// }
