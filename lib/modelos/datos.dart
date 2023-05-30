import 'dart:convert';
import 'dart:math';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

import '../utils.dart';
import '../sheets_api.dart';
import 'cierre.dart';
import 'escuela.dart';
import 'votante.dart';
import 'favorito.dart';
import 'mesa.dart';

class Datos {
  static int usuario = 0;
  // static int usuario = 18627585;
  // static int usuario = 17041793;

  static String version = "1.6.3";

  static Escuelas escuelas = [];
  static Votantes votantes = [];
  static Favoritos favoritos = [];
  static Cierres cierres = [];

  static const admistradores = [18627585, 17041793, 24409480, 37096832]; // Susana  21327900 // Marcelo 17041793
  static Votantes get usuariosExtras => [
        Votante(18627585, "Di Battista, Alejandro", "Av. Central 4124", "M", -1967, 3333, 0, 0, 0, 0, -26.805819,
            -65.252722),
        Votante(20559013, "Martin, Andrea Fabina", "San Juan 724 - 6A", "F", 1968, 1001, 126, 0, 0, 0, -26.824868,
            -65.206791),
      ];

  static Votantes get usuarios => favoritos.map((f) => f.referente).toSet().map((dni) => traerUsuario(dni)).toList();

  static bool cargando = false;
  static bool cargado = false;
  static bool get estaCargado => cargado;

  static Future<void> cargar() async {
    if (cargando || cargado) return;
    cargando = true;

    print(">> Cargando datos..${DateTime.now().hora}");

    print("1. Cargar Escuelas & Votantes ${DateTime.now().hora}");
    await cargarEscuelas();
    await cargarVotantes();
    print(" - Cargamos ${escuelas.length} escuelas & ${votantes.length} votantes");

    print("2. Cargar Favoritos & Cierres ${DateTime.now().hora}");
    await cargarFavoritos();
    await cargarCierres();
    print(" - Cargamos ${favoritos.length} Favoritos & ${cierres.length} Mesas Cerradas ");

    print("3. Crear Escuelas y Marcar ${DateTime.now().hora}");
    crearEscuelas();
    marcarFavoritos();
    marcarCierres();

    print("|| Datos cargados. ${DateTime.now().hora}");
    cargado = true;
    cargando = false;
  }

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
    favoritos = await bajarFavoritos();
    print(" - Bajamos ${favoritos.length} favoritos");
  }

  static Future<void> cargarCierres() async {
    cierres = await bajarCierres();
    print(" - Bajamos ${cierres.length} cierres");
  }

  static Future<Favoritos> bajarFavoritos() async {
    final datos = await SheetsApi.traerFavoritos();
    final nuevos = datos.map((dato) => Favorito.fromMap(dato)).toList();
    return Favorito.compactar(nuevos);
  }

  static Future<Cierres> bajarCierres() async {
    final datos = await SheetsApi.traerCierres();
    final nuevos = datos.map((dato) => Cierre.fromMap(dato)).toList();
    return Cierre.compactar(nuevos);
  }

  static void crearEscuelas() {
    votantes.sort((a, b) => (a.mesa * 1000 + a.orden).compareTo(b.mesa * 1000 + b.orden));

    int e = 0, m = 0;
    var mesa = Mesa(0);
    for (int v = 0; v < votantes.length; v++) {
      var votante = votantes[v];
      if (votante.mesa > escuelas[e].hasta) {
        e++;
        m = 0;
      }
      if (votante.mesa != m) {
        m = votante.mesa;
        mesa = Mesa(m);
        mesa.nroEscuela = e;
        escuelas[e].agregar(mesa);
      }
      mesa.agregar(votante);
      votante.nroEscuela = e;
    }

    escuelas.forEach((e) => e.ordenar());
  }

  static marcarFavoritos() {
    final referente = Datos.usuario;

    final Map<int, bool> marcas = {};
    favoritos.where((f) => f.referente == referente).forEach((f) => marcas[f.dni] = f.favorito);

    for (final votante in votantes) {
      votante.favorito = marcas[votante.dni] ?? false;
    }
  }

  static marcarCierres() {
    final referente = Datos.usuario;

    for (final e in escuelas) {
      for (final m in e.mesas) {
        m.esCerrada = cierres.any((c) => c.referente == referente && c.mesa == m.numero && c.cerrada);
      }
    }
  }

  static Future<void> marcarFavorito(Votante votante) async {
    final datos = [
      votante.dni,
      usuario,
      votante.favorito ? "S" : "N",
      votante.nombre,
      votante.mesa,
      DateTime.now().fechaHora
    ];

    favoritos.add(Favorito(dni: votante.dni, referente: usuario, favorito: votante.favorito, hora: DateTime.now()));
    favoritos = Favorito.compactar(favoritos);

    await SheetsApi.registrarFavorito(datos);
  }

  static void marcarMesa(Mesa mesa) async {
    final datos = [
      mesa.numero.toString(),
      usuario,
      mesa.esCerrada ? "cerrar" : "abrir",
      DateTime.now().fechaHora,
    ];

    debugPrint("marcarMesa: ${datos.join(", ")}");

    cierres.add(Cierre(mesa: mesa.numero, referente: usuario, hora: DateTime.now()));
    cierres = Cierre.compactar(cierres);

    await SheetsApi.registrarCierre(datos);
  }

  static void borrarFavoritos(Mesa mesa) async {
    for (var votante in mesa.votantes) {
      if (votante.favorito) {
        votante.favorito = false;
        await marcarFavorito(votante);
      }
    }
  }

  static Votante get usuarioActual => traerUsuario(Datos.usuario);
  static Escuela get escuelaActual => Escuela.traer(usuarioActual.mesa);
  static get esAdministrador => admistradores.contains(usuarioActual.dni);

  static Votante traerUsuario(int dni) =>
      usuariosExtras.firstWhere((v) => v.dni == dni, orElse: () => Votante.traer(dni));
  static get cantidadUsuarios => usuarios.length;

  static get cantidadVotantes => votantes.length;
  static get cantidadVotantesCerrados => escuelas.map((e) => e.totalVotantesCerrados).sum;
  static get cantidadVotantesAnalizados => escuelas.map((e) => e.totalVotantesAnalizados).sum;
  static get cantidadVotantesMarcados => escuelas.map((e) => e.totalVotantesFavoritos).sum;

  static get cantidadMesas => escuelas.map((e) => e.cantidadMesas).sum;
  static get cantidadMesasAnalizadas => escuelas.map((e) => e.cantidadMesasAnalizadas).sum;
  static get cantidadMesasCerradas => escuelas.map((e) => e.cantidadMesasCerradas).sum;

  static get cantidadEscuelasCompletas => escuelas.where((e) => e.esCompleta).length;
  static get cantidadEscuelasAnalizadas => escuelas.where((e) => e.esAnalizada).length;

  static cantidadFavoritos(int referente) => favoritos.where((f) => f.referente == referente).length;

  static Votantes buscar(String texto) => Votante.buscar(Datos.votantes, texto);

  static Favoritos buscarFavoritosPendientes(Favoritos actual) {
    final pendientes = favoritos.where((n) => !actual.any((f) => f == n)).toList();
    if (pendientes.length > 0) {
      print("Favoritos pendientes: ${pendientes.length}");
      for (final a in pendientes) {
        print(' - $a');
      }
    }
    return pendientes;
  }

  static Favoritos buscarFavoritosNuevos(Favoritos actual) {
    final nuevos = actual.where((n) => !favoritos.any((f) => f == n)).toList();
    if (nuevos.length > 0) {
      print("Favoritos Nuevos: ${nuevos.length}");
      for (final a in nuevos) {
        print(' - $a');
      }
    }
    return nuevos;
  }

  static Future<void> sincronizarFavoritos() async {
    final actual = await bajarFavoritos();

    final pendientes = buscarFavoritosPendientes(actual);
    buscarFavoritosNuevos(actual);

    for (final f in pendientes) {
      final v = Votante.traer(f.dni);
      v.favorito = f.favorito;
      actual.add(f);
      await marcarFavorito(v);
    }

    favoritos = Favorito.compactar(actual);

    marcarFavoritos();
  }

  static Mesa elegirMesa() {
    final escuelas = Datos.escuelas.where((e) => !e.esAnalizada).toList();
    final escuela = escuelas[Random().nextInt(escuelas.length)];
    final mesas = escuela.mesas.where((m) => !m.esAnalizada && !m.esCerrada).toList();
    final mesa = mesas[Random().nextInt(mesas.length)];
    return mesa;
  }
}
