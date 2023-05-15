import 'dart:js_interop';

import '../sheets_api.dart';
import './escuela.dart';
import './mesa.dart';
import './votante.dart';

import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class Datos {
  static List<Escuela> escuelas = [];
  static List<Votante> votantes = [];
  static Map<int, bool> favoritos = {};
  static Map<int, bool> cerradas = {};

  static int usuario = 18627585;

  static Future<void> cargarEscuelas() async {
    final texto = await rootBundle.loadString("datos/escuelas.json");
    final datos = json.decode(texto) as List<dynamic>;
    escuelas = datos.map((dato) => Escuela.fromMap(dato)).toList();
  }

  static Future<void> cargarVotantes() async {
    final texto = await rootBundle.loadString("datos/votantes.json");
    final datos = json.decode(texto) as List<dynamic>;
    votantes = datos.map((dato) => Votante.fromMap(dato)).toList();
  }

  static Future<void> cargarFavoritos() async {
    favoritos = await SheetsApi.traerFavoritos(usuario);
  }

  static Future<void> cargarMesas() async {
    cerradas = await SheetsApi.traerMesas(usuario);
  }

  static void crearEscuelas() {
    print("Hay ${escuelas.length} escuelas y ${votantes.length} votantes");
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
        mesa.ordenar();
      }
    }
  }

  static void marcarFavoritos() {
    print("Hay ${favoritos.length} favoritos y ${cerradas.length} mesas cerradas");
    for (final votante in votantes) {
      votante.favorito = favoritos[votante.dni] ?? false;
    }
    for (final e in escuelas) {
      for (final m in e.mesas) {
        m.cerrada = cerradas[m.numero] ?? false;
      }
    }
  }

  static final reloj = Stopwatch();
  static void comenzar() {
    reloj.reset();
    reloj.start();
  }

  static void terminar(String titulo) {
    reloj.stop();
    print("- $titulo > (${reloj.elapsedMilliseconds}ms)");
  }

  static Future<void> cargar() async {
    print("Cargando datos...");

    comenzar();
    await cargarEscuelas();
    await cargarVotantes();
    terminar('Cargando Escuelas (${escuelas.length}) y Votantes ${votantes.length}');

    comenzar();
    await cargarFavoritos();
    await cargarMesas();
    terminar("Cargando Favoritos (${favoritos.length}) y Mesas Cerradas (${cerradas.length})");

    comenzar();
    crearEscuelas();
    terminar("Creando Escuelas y Mesas");

    print("Datos cargados.");
  }

  static Future<void> marcar() async {
    print("Marcando datos...");

    comenzar();
    marcarFavoritos();
    terminar("Marcando Favoritos y Mesas Cerradas");

    print("Datos marcados.");
  }

  static Future<void> marcarFavorito(Votante votante) async {
    await SheetsApi.marcarFavorito(votante, usuario);
  }

  static void marcarMesa(Mesa mesa) async {
    await SheetsApi.marcarMesa(mesa, usuario);
  }

  static void borrarFavoritos(Mesa mesa) async {
    for (var votante in mesa.votantes) {
      if (votante.favorito) {
        votante.favorito = false;
        await SheetsApi.marcarFavorito(votante, Datos.usuario);
      }
    }
  }
}
