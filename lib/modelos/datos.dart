import 'dart:convert';
import 'package:collection/collection.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'cierre.dart';

import '../utils.dart';
import '../sheets_api.dart';
import 'escuela.dart';
import 'favorito.dart';
import 'mesa.dart';
import 'votante.dart';

class Datos {
  static int usuario = 0;
  // static int usuario = 18627585;

  static String version = "1.1.5";

  static const admistradores = [18627585, 17041793, 24409480, 37096832];
  // Susana  21327900
  // Marcelo 17041793
  static List<Votante> get usuariosExtras => [
        Votante(18627585, "Di Battista, Alejandro", "Av. Central 4124", "M", -1967, 3333, 0, 0, 0, 0, -26.805819,
            -65.252722),
        Votante(20559013, "Martin, Andrea Fabina", "San Juan 724 - 6A", "F", 1968, 1001, 126, 0, 0, 0, -26.824868,
            -65.206791),
      ];

  static List<Escuela> escuelas = [];
  static List<Votante> votantes = [];
  static List<Favorito> favoritos = [];
  static List<Cierre> cierres = [];
  static List<Votante> get usuarios =>
      favoritos.map((f) => f.referente).toSet().map((dni) => traerUsuario(dni)).toList();

  static Future<void> iniciar(Function alTerminar, {bool forzar = false}) async {
    if (forzar) Datos.cargado = false;

    // if (!Datos.cargado ) {
    //   await cargar();
    // } else {
    //   while (!Datos.estaCargado) {
    //     await Future.delayed(Duration(milliseconds: 100));
    //   }
    // }

    marcarFavoritos();
    marcarCierres();

    alTerminar();
  }

  static bool cargando = false;
  static bool cargado = false;
  static bool get estaCargado => cargado;

  static Future<void> cargar() async {
    if (cargando || cargado) return;
    cargando = true;

    print(">> Cargando datos..${DateTime.now().hora}");

    await cargarEscuelas();
    await cargarVotantes();
    print(" - Cargamos ${escuelas.length} escuelas & ${votantes.length} votantes");
    print("1. ${DateTime.now().hora}");

    await cargarFavoritos();
    await cargarCierres();
    print(" - Cargamos ${favoritos.length} Favoritos & ${cierres.length} Mesas Cerradas ");
    print("2. ${DateTime.now().hora}");

    crearEscuelas();
    marcarFavoritos();
    marcarCierres();

    print("Datos cargados.");
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
    print("Bajamos ${favoritos.length} favoritos");
  }

  static Future<void> cargarCierres() async {
    cierres = await bajarCierres();
    print("Bajamos ${cierres.length} cierres");
  }

  static Future<List<Favorito>> bajarFavoritos() async {
    final datos = await SheetsApi.traerFavoritos();
    final nuevos = datos.map((dato) => Favorito.fromMap(dato)).toList();
    return Favorito.compactar(nuevos);
  }

  static Future<List<Cierre>> bajarCierres() async {
    final datos = await SheetsApi.traerCierres();
    final nuevos = datos.map((dato) => Cierre.fromMap(dato)).toList();
    return Cierre.compactar(nuevos);
  }

  static void crearEscuelas() {
    print("crearEscuelas: Hay ${escuelas.length} escuelas y ${votantes.length} votantes");
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
        mesa.escuela = e;
        escuelas[e].agregar(mesa);
      }
      mesa.agregar(votante);
      votante.escuela = e;
    }

    escuelas.forEach((e) => e.ordenar());
  }

  static marcarFavoritos() {
    print("Hay ${favoritos.length} favoritos");

    final referente = Datos.usuario;

    final Map<int, bool> marcas = {};
    favoritos.where((f) => f.referente == referente).forEach((f) => marcas[f.dni] = f.favorito);

    for (final votante in votantes) {
      votante.favorito = marcas[votante.dni] ?? false;
    }
  }

  static marcarCierres() {
    print("Hay ${cierres.length} mesas cerradas");

    final referente = Datos.usuario;

    for (final e in escuelas) {
      for (final m in e.mesas) {
        m.cerrada = cierres.any((c) => c.referente == referente && c.mesa == m.numero && c.cerrada);
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
      mesa.numero,
      usuario,
      mesa.cerrada ? "cerrar" : "abrir",
      DateTime.now().fechaHora,
    ];

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
  static Escuela get escuelaActual => traerEscuela(usuarioActual.mesa);
  static get esAdministrador => admistradores.contains(usuarioActual.dni);

  static Votante traerUsuario(int dni) =>
      usuariosExtras.firstWhere((v) => v.dni == dni, orElse: () => traerVotante(dni));
  static Votante traerVotante(int dni) => votantes.firstWhere((v) => v.dni == dni, orElse: () => Votante.anonimo(dni));
  static Escuela traerEscuela(int mesa) =>
      escuelas.firstWhere((e) => e.desde <= mesa && mesa <= e.hasta, orElse: () => Escuela.noIdentificada());

  static get cantidadUsuarios => usuarios.length;

  static get cantidadVotantes => votantes.length;
  static get cantidadVotantesAnalizados => escuelas.map((e) => e.totalVotantesAnalizados).sum;
  static get cantidadVotantesMarcados => escuelas.map((e) => e.totalVotantesFavoritos).sum;

  static get cantidadMesas => escuelas.map((e) => e.cantidadMesas).sum;
  static get cantidadMesasAnalizadas => escuelas.map((e) => e.cantidadMesasAnalizadas).sum;
  static get cantidadMesasCerradas => escuelas.map((e) => e.cantidadMesasCerradas).sum;

  static get cantidadEscuelasCompletas => escuelas.where((e) => e.esCompleta).length;
  static get cantidadEscuelasAnalizadas => escuelas.where((e) => e.esAnalizada).length;

  static cantidadFavoritos(int referente) => favoritos.where((f) => f.referente == referente).length;

  static List<Votante> buscar(String texto) => Votante.buscar(Datos.votantes, texto);

  static Future<List<Favorito>> buscarActualizacionFavoritos() async {
    final nuevos = await bajarFavoritos();
    final actualizados = nuevos.where((n) => !favoritos.any((f) => f == n));
    print("Favoritos nuevos: ${actualizados.length}");
    for (final a in actualizados) {
      print(' - $a');
    }
    return nuevos;
  }

  static Future<List<Favorito>> buscarFavoritosPendientes() async {
    final nuevos = await bajarFavoritos();
    final actualizados = favoritos.where((n) => !nuevos.any((f) => f == n));
    print("Favoritos pendientes: ${actualizados.length}");
    for (final a in actualizados) {
      print(' - $a');
    }
    return nuevos;
  }

  static Future<void> sincronizarFavoritos() async {
    final pendientes = await buscarFavoritosPendientes();
    for (final f in pendientes) {
      final v = traerVotante(f.dni);
      v.favorito = f.favorito;
      await marcarFavorito(v);
    }
    await cargarFavoritos();
    marcarFavoritos();
  }
}
