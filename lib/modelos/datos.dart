import './escuela.dart';
import './mesa.dart';
import './votante.dart';

import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class Datos {
  static List<Escuela> escuelas = [];
  static List<Votante> votantes = [];

  static Future<void> cargarVotantes() async {
    final texto = await rootBundle.loadString("datos/votantes.json");
    final datos = json.decode(texto) as List<dynamic>;
    print(">> Cargando Votantes ${datos.length}");
    votantes = datos.map((dato) => Votante.fromMap(dato)).toList();
    print(">> Votantes cargados ${votantes.length}");
  }

  static Future<void> cargarEscuelas() async {
    final texto = await rootBundle.loadString("datos/escuelas.json");
    final datos = json.decode(texto) as List<dynamic>;
    print(">> Cargando Escuelas ${datos.length}");
    // print(datos.first);
    escuelas = datos.map((dato) => Escuela.fromMap(dato)).toList();
    print(">> Escuelas cargadas ${escuelas.length}");
  }

  static Future<void> cargar() async {
    print("Cargando datos");
    final stopwatch = Stopwatch()..start();
    await cargarEscuelas();
    await cargarVotantes();
    stopwatch.stop();
    print('cargar: ${stopwatch.elapsedMilliseconds} ms (escuelas: ${escuelas.length}, votantes: ${votantes.length})');

    stopwatch.start();
    for (var e in escuelas) {
      for (var m = e.desde; m <= e.hasta; m++) {
        var mesa = Mesa(m, 0, 0);
        for (var v = 0; v < votantes.length; v++) {
          var votante = votantes[v];
          if (votante.mesa == m) {
            mesa.inicial = v;
            mesa.agregar(votante);
          }
          mesa.cantidad++;
        }
        e.agregar(mesa);
      }
    }
    stopwatch.stop();
    print('agregar: ${stopwatch.elapsedMilliseconds}');
  }
}
