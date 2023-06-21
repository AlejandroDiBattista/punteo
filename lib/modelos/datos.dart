import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:csv/csv.dart';

import '/utils.dart';
import '/sheets_api.dart';

import 'entrega.dart';
import 'escuela.dart';
import 'mesa.dart';
import 'votante.dart';
import 'favorito.dart';
import 'cierre.dart';
import 'usuario.dart';
import 'pregunta.dart';

class Datos {
  static String version = '2.1.5';
  static String cuando = "21/06 13:00";

  static const bool OnLine = false;
  static const bool UsaCache = true;

  static int usuario = 0;
  // static int usuario = 16176830; // Pia Quaia
  // static int usuario = 17041793; // Marcelo
  // static int usuario = 18627585; // Alejandro
  // static int usuario = 22664392; // Pia Juarez
  // static int usuario = 24409480; // Hernan
  // static int usuario = 37096832; // Santiago

  static Escuelas escuelas = [];
  static Mesas mesas = [];
  static Votantes votantes = [];

  static Favoritos favoritos = [];
  static Entregas entregas = [];
  static Cierres cierres = [];

  static Mesas prioridad = [];

  static Preguntas preguntas = [];
  static Usuarios usuarios = [];
  static Usuarios rankeados = [];
  static const admistradores = [18627585, 17041793, 24409480, 37096832]; // Susana  21327900 // Marcelo 17041793

  static Map<int, Votante> cache = {};
  static Votantes get ordenados => Datos.votantes.sortedBy((e) => e.nombre);

  static List<(String calle, String tag)> calles = [
    ("Anzorena", ":anzorena"),
    ("Av Aconquija", ":aconquija"),
    ("Bascary", ":bascary"),
    ("Boulevard 9 de Julio", ":boulevard"),
    ("Brasil", ":brasil"),
    ("Calle Este", ":calle :este"),
    ("Cariola", ":cariola"),
    ("Catamarca", ":catamarca"),
    ("Diego de Villarroel", ":villarroel"),
    ("Frias Silva", ":silva"),
    ("Italia", ":italia"),
    ("Ituzaingo", ":ituzaingo"),
    ("Lamadrid", ":lamadrid"),
    ("Las Rosas", ":rosas"),
    ("Los Ceibos", ":ceibos"),
    ("Paraguay", ":paraguay"),
    ("Pedro de Villalba", ":villalba"),
    ("Peru", ":peru"),
    ("Pringles", ":pringles"),
    ("Salas y Valdez", ":salas"),
    ("Santo Domingo", ":domingo"),
    ("Sarmiento", ":sarmiento"),
    ("Venezuela", ":venezuela"),
  ];

  static List<(String barrio, int votantes, int referente)> barrios = [
    ("Barrio Telefonico", 64, 37096832),
    ("Yerba Buena Country Club", 48, 24409480),
    ("Country Jockey Club", 45, 24409480),
    ("Country Las Yungas", 45, 37096832),
    ("Country Marcos Paz", 42, 22664392),
    // ("Barrio Las Marias", 26,0),
    ("Nuevo Country del Golf", 24, 24409480),
    ("Barrio Portal del Cerro", 11, 24409480),
    ("Barrio Las Acacias", 10, 24409480),
    ("Country Las Praderas", 9, 24409480),
    ("Barrio Apunt", 7, 37096832),
    ("Barrio Los Alisos", 6, 24409480),
    ("Barrio San Jose III", 5, 370968320),
    ("Barrio Horco Molle", 5, 24409480),
    // ("Barrio 200 viviendas", 5,0),
    // ("Barrio Los Aromos", 5,0),
    ("Country Los Azahares", 4, 24409480),
    // ("Barrio Nicolas Avellaneda IV", 4,0),
    ("Barrio Los Tipales", 4, 24409480),
    // ("Barrio Nicolas Avellaneda III", 4,0),
    // ("Barrio Los Olivos", 4,0),
    // ("Barrio La Esperanza", 4,0),
    // ("Barrio Juramento", 4,0),
  ];
  static Usuarios get usuariosExtras => [
        Usuario(18627585, 'Di Battista, Alejandro', 'Av Central 4124', 'M', -1967, 3333, 0, 0, 0, 0, -26.805819,
            -65.252722, "Av Central", 4124, false, false),
        Usuario(20559013, 'Martin, Andrea Fabina', 'San Juan 724 - 6A', 'F', 1968, 1001, 126, 0, 0, 0, -26.824868,
            -65.206791, "San Juan", 724, false, false),
        Usuario(26484383, 'Schargorodsky, Carolina', 'San Martin 866', 'F', 1978, 1001, 126, 0, 0, 0, -26.828602,
            -65.210158, "", 0, false, false),
      ];

  static Usuarios calcularRanking() {
    final usuarios = [...Datos.usuarios];
    final anterior = Datos.usuario;
    usuarios.forEach((u) {
      Datos.usuario = u.dni;
      Datos.marcarTodo();

      final Sesiones sesiones = Favorito.calcularSesiones(u.dni);
      u.cantidadSesiones = sesiones.length;
      if (u.cantidadSesiones > 0) u.ultimaSesion = sesiones.last.$1;

      u.cantidadFavoritos = Datos.cantidadVotantesMarcados;
      u.cantidadAnalizados = Datos.cantidadVotantesCerrados;
      u.mesasCerradas = Datos.cantidadMesasCerradas;
      u.mesasPendientes = Datos.cantidadMesasPendientes;
      u.tiempoTrabajado = Favorito.calcularMinutosTrabajado(u.dni);
    });

    Datos.usuario = anterior;
    Datos.marcarTodo();

    usuarios.sort((a, b) => a.mesasPendientes == b.mesasPendientes
        ? b.cantidadFavoritos.compareTo(a.cantidadFavoritos)
        : a.mesasPendientes.compareTo(b.mesasPendientes));
    rankeados = usuarios;
    return usuarios;
  }

  static bool cargando = false;
  static bool cargado = false;
  static bool get estaCargado => cargado;

  static bool get esAdministrador => admistradores.contains(usuarioActual.dni);
  static bool get esSuperUsuario => Datos.usuario == 18627585;

  static Future<void> cargar({bool forzar = false}) async {
    if (forzar) cargado = false;
    if (cargando || cargado) return;
    cargando = true;

    comenzar('CARGANDO DATOS');

    await leerEscuelas();
    avanzar('1. Cargamos Escuelas (${escuelas.length})');

    await leerVotantes();
    avanzar('2. Cargamos Votantes (${votantes.length}) ');

    await cargarFavoritos();
    marcarFavoritos();
    avanzar('3. Cargamos Favoritos (${favoritos.length})');

    await cargarCierres();
    marcarCierres();
    marcarPrioridad();
    avanzar('4. Cargamos Cierres de Mesa (${cierres.length})');

    crearEscuelas();
    avanzar("5. Cargamos las escuelas");

    sincronizarEntregas();
    avanzar("6. Sincronizar Entregas");

    await cargarResultados();
    avanzar("7. Cargando resultados");
    // if (Datos.esSuperUsuario) {
    //   await cargarPreguntas();
    //   avanzar("7. Cargamos Preguntas");
    // }

    terminar();

    cargado = true;
    cargando = false;
  }

  static Future<void> cargarFavoritos() async {
    favoritos = await bajarFavoritos();
  }

  static Future<void> cargarCierres() async {
    cierres = await bajarCierres();
  }

  static Future<void> cargarPreguntas() async {
    preguntas = await bajarPreguntas();
  }

  static void marcarPrioridad() {
    final Map<int, bool> esPrioritaria = {};
    mesas.forEach((m) => esPrioritaria[m.numero] = m.esPrioridad && !m.esCerrada);

    final Map<int, int> contar = {};
    cierres.forEach((c) {
      if (esPrioritaria[c.mesa] ?? false) {
        contar[c.mesa] = (contar[c.mesa] ?? 0) + 1;
      }
    });

    var salida = contar.entries.sorted((a, b) {
      if (a.value == b.value) return a.key.compareTo(b.key);
      return a.value.compareTo(b.value);
    });

    prioridad = salida.where((e) => e.value <= 10).map((e) => Mesa.traer(e.key)).toList();

    // mostrarEscuelasPrioritarias();
    // mostrarMesasPrioritarias(salida);
  }

  static Future<void> sincronizarPrioridad() async {
    await bajarCierres();
    marcarCierres();
    marcarPrioridad();
  }

  static Mesas prioridadPara(int referente) {
    Map<int, bool> cerrada = {};
    cierres.where((c) => c.referente == referente).forEach((c) => cerrada[c.mesa] = c.cerrada);

    return mesas.where((m) => m.esPrioridad && !(cerrada[m.numero] ?? false)).toList();
  }

  static void mostrarEscuelasPrioritarias() {
    var n = 0;
    final salida = escuelas.where((e) => e.esPrioridad).toList();
    print("Listado de Escuelas Prioritarias (son ${salida.length})");
    salida.forEach((e) {
      n++;
      print('- $n ${e.escuela} de: ${e.desde} - ${e.hasta}');
    });
  }

  static void mostrarMesasPrioritarias(List<MapEntry<int, int>> salida) {
    var n = 0;
    print("Listado de Mesas Prioritarias (son ${salida.length})");
    salida.forEach((e) {
      n++;
      final m = Mesa.traer(e.key);
      print('- $n ${e.key} = ${e.value} ${m.esPrioridad.info("Prioridad", "Común")} en ${m.escuela.escuela}');
    });
  }

  static Future<Favoritos> bajarFavoritos() async {
    if (UsaCache && favoritos.isNotEmpty) return favoritos; //CACHE
    if (!OnLine) return await leerFavoritos();

    final datos = await SheetsApi.traerFavoritos();
    final nuevos = datos.map((dato) => Favorito.fromMap(dato)).toList();
    return Favorito.compactar(nuevos);
  }

  static Future<Cierres> bajarCierres() async {
    if (UsaCache && cierres.isNotEmpty) return cierres; //CACHE
    if (!OnLine) return await leerCierres();

    final datos = await SheetsApi.traerCierres();
    final nuevos = datos.map((dato) => Cierre.fromMap(dato)).toList();

    return Cierre.compactar(nuevos);
  }

  static Future<Entregas> bajarEntregas() async {
    if (UsaCache && entregas.isNotEmpty) return entregas;
    if (!OnLine) return await leerEntregas();

    final datos = await SheetsApi.traerEntregas();
    final nuevos = datos.map((dato) => Entrega.fromMap(dato)).toList();
    return Entrega.compactar(nuevos);
  }

  static Future<Preguntas> bajarPreguntas() async {
    final datos = await SheetsApi.traerPreguntas();
    return datos.map((dato) => Pregunta.fromMap(dato)).toList();
  }

  static Future<List<dynamic>> leerJson(String origen) async {
    final texto = await rootBundle.loadString('datos/json/$origen.json');
    return json.decode(texto) as List<dynamic>;
  }

  static Future<void> leerVotantes() async {
    final datos = await leerJson('votantes');
    votantes = datos.map((dato) => Votante.fromMap(dato)).toList();
    votantes.forEach((v) => cache[v.dni] = v);
  }

  static Future<void> leerEscuelas() async {
    if (escuelas.isNotEmpty) return; // Cache

    final datos = await leerJson('escuelas');
    escuelas = datos.map((dato) => Escuela.fromMap(dato)).toList();
  }

  static Future<Favoritos> leerFavoritos() async {
    final datos = await leerJson('favoritos');
    return datos.map((dato) => Favorito.minimo(dato["dni"], dato["ref"])).toList();
  }

  static Future<Cierres> leerCierres() async {
    final datos = await leerJson('cierres');

    return datos.map((dato) => Cierre.minimo(dato["mesa"], dato["ref"], true)).toList(); //todo
  }

  static Future<Entregas> leerEntregas() async {
    final datos = await leerJson('entregas');
    final Map<String, int> marcar = {};
    barrios.forEach((e) {
      final barrio = e.$1;
      final ref = e.$3;
      if (ref > 0) marcar[barrio] = ref;
    });
    votantes.forEach((v) {
      if (marcar.containsKey(v.domicilio)) {
        datos.add({'dni': v.dni, 'ref': marcar[v.domicilio], 'entregado': 'E'});
      }
    });
    final salida =
        datos.map((dato) => Entrega.minimo(dato["dni"], dato["ref"], dato['entregado'] == 'E')).toList(); //todo
    return salida;
  }

  // Procesar

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
        mesas.add(mesa);
      }
      mesa.agregar(votante);
      votante.nroEscuela = e;
    }

    escuelas.forEach((e) => e.ordenar());
  }

  static marcarTodo() {
    marcarFavoritos();
    marcarCierres();
    marcarPrioridad();
    marcarEntregas();
  }

  static marcarFavoritos() {
    final referente = Datos.usuario;
    final Map<int, bool> marcas = {};

    favoritos.where((f) => f.referente == referente).forEach((f) => marcas[f.dni] = f.favorito);
    Map<int, Set<int>> referentes = {};

    final Set<int> usuarios = Set();
    favoritos.forEach((f) {
      usuarios.add(f.referente);
      if (!referentes.containsKey(f.dni)) referentes[f.dni] = {};
      referentes[f.dni]!.add(f.referente);
    });

    for (final votante in votantes) {
      votante.favorito = marcas[votante.dni] ?? false;
      votante.referentes = referentes[votante.dni] ?? {};
    }
    Datos.usuarios = usuarios.map((dni) => Datos.traerUsuario(dni)).toList();
  }

  static marcarCierres() {
    final referente = Datos.usuario;

    final Map<int, bool> cerradas = {};
    cierres.where((c) => c.referente == referente).forEach((f) => cerradas[f.mesa] = f.cerrada);

    for (final e in escuelas) {
      for (final m in e.mesas) {
        m.esCerrada = cerradas[m.numero] ?? false;
      }
    }
  }

  static marcarEntregas() {
    final Map<int, EstadoEntrega> marcas = {};
    entregas.forEach((e) => marcas[e.dni] = e.entrega);

    votantes.forEach((v) => v.entrega = marcas[v.dni] ?? EstadoEntrega.pendiente);
  }

  static Future<void> marcarFavorito(Votante votante) async {
    final datos = [
      votante.dni,
      usuario,
      votante.favorito ? 'S' : 'N',
      votante.nombre,
      votante.mesa,
      DateTime.now().fechaHora,
      votante.busqueda ? 'S' : 'N'
    ];

    favoritos.add(Favorito(
        dni: votante.dni,
        referente: usuario,
        favorito: votante.favorito,
        hora: DateTime.now(),
        busqueda: votante.busqueda));

    favoritos = Favorito.compactar(favoritos);

    await SheetsApi.registrarFavorito(datos);
  }

  static Future<void> marcarEntrega(Votante votante) async {
    final datos = [
      votante.dni,
      usuario,
      votante.entrega.clave,
      votante.nombre,
      DateTime.now().fechaHora,
      votante.domicilio,
      Usuario.traer(usuario).nombre
    ];

    entregas.add(Entrega(
      dni: votante.dni,
      referente: usuario,
      entrega: votante.entrega,
      hora: DateTime.now(),
    ));

    entregas = Entrega.compactar(entregas);

    await SheetsApi.registrarEntrega(datos);
  }

  static void marcarMesa(Mesa mesa) async {
    final datos = [
      mesa.numero.toString(),
      usuario,
      mesa.esCerrada ? 'cerrar' : 'abrir',
      DateTime.now().fechaHora,
    ];

    debugPrint('marcarMesa: ${datos.join(', ')}');

    cierres.add(Cierre(mesa: mesa.numero, referente: usuario, hora: DateTime.now()));
    cierres = Cierre.compactar(cierres);

    await SheetsApi.registrarCierre(datos);
  }

  static void guardarRespuestas(List<int> datos) async {
    await SheetsApi.registrarRespuestas(datos);
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

  static Usuario traerUsuario(int dni) =>
      usuariosExtras.firstWhere((v) => v.dni == dni, orElse: () => Usuario.from(Votante.traer(dni)));
  static get cantidadUsuarios => usuarios.length;

  static get cantidadVotantes => votantes.length;
  static get cantidadVotantesCerrados => escuelas.map((e) => e.totalVotantesCerrados).sum;
  static get cantidadVotantesAnalizados => escuelas.map((e) => e.totalVotantesAnalizados).sum;
  static get cantidadVotantesMarcados => escuelas.map((e) => e.totalVotantesFavoritos).sum;

  static get cantidadMesas => escuelas.map((e) => e.cantidadMesas).sum;
  static get cantidadMesasAnalizadas => escuelas.map((e) => e.cantidadMesasAnalizadas).sum;
  static get cantidadMesasCerradas => escuelas.map((e) => e.cantidadMesasCerradas).sum;
  static get cantidadMesasPendientes => mesas.where((m) => m.esPendiente).length;

  static get cantidadEscuelasCompletas => escuelas.where((e) => e.estado == EstadoEscuela.completa).length;
  static get cantidadEscuelasAnalizadas => escuelas.where((e) => e.estado == EstadoEscuela.pendiente).length;
  static get cantidadEscuelasIgnoradas => escuelas.where((e) => e.estado == EstadoEscuela.vacia).length;

  static cantidadFavoritos(int referente) => favoritos.where((f) => f.referente == referente).length;

  static Votantes buscar(String texto) => Votante.buscar(Datos.votantes, texto);

  static Favoritos buscarFavoritosPendientes(Favoritos actual) {
    final pendientes = favoritos.where((n) => !actual.any((f) => f == n)).toList();
    if (pendientes.length > 0) {
      print('Favoritos pendientes: ${pendientes.length}');
      for (final a in pendientes) {
        print(' - $a');
      }
    }
    return pendientes;
  }

  static Favoritos buscarFavoritosNuevos(Favoritos actual) {
    final nuevos = actual.where((n) => !favoritos.any((f) => f == n)).toList();
    if (nuevos.length > 0) {
      print('Favoritos Nuevos: ${nuevos.length}');
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

  static Future<void> sincronizarEntregas() async {
    entregas = await bajarEntregas();
    marcarEntregas();
  }

  static Future<void> sincronizarTodo() async {
    await sincronizarFavoritos();
    await sincronizarPrioridad();
  }

  static Mesas mesasCerradas(int referente) => Datos.cierres
      .where((c) => c.cerrada && c.referente == referente)
      .map((c) => c.mesa)
      .toSet()
      .map((n) => Mesa.traer(n))
      .toList();

  static int votantesRevisados(int referente) => mesasCerradas(referente).map((m) => m.votantes.length).sum;

  static void mostrarEntregas() {
    print("Listado de entregas x ${entregas.length}");
    var n = 1;
    entregas.forEach((e) {
      final v = Votante.traer(e.dni);
      print(" ${n++} ${v.nombre} (${v.entrega} > ${e.entrega})");
    });
  }

  static void listarReferidos() {
    final List<(Votante v, Usuario u)> lista =
        Datos.favoritos.map((f) => (Votante.traer(f.dni), Usuario.traer(f.referente))).toList();

    print("");
    print("");
    print("");

    print("id;nombre;dni;domicilio;latitude;longitude;referente");
    int n = 0;
    lista.where((i) => i.$1.conUbicacion).forEach((i) {
      final v = i.$1;
      final u = i.$2;
      n++;
      if (n >= 3000 && n < 4000) {
        print("$n;${v.nombre};${v.dni};${v.domicilio};${v.latitude};${v.longitude};${u.nombre}");
      }
    });
    print("");
    print("");
    print("");
  }

  static void sincronizarBusqueda() {
    votantes.forEach((v) => v.prepararBusqueda());
  }

  static Future<void> listarRankingCalles() async {
    await Datos.sincronizarEntregas();
    await Datos.sincronizarFavoritos();
    Datos.sincronizarBusqueda();
    List<Votante> lista = Datos.favoritos.map((f) => Votante.traer(f.dni)).toList();

    lista = lista.where((v) => v.conCalles).toList();
    Map<String, int> calles = {};
    lista.forEach((v) => calles[v.calle] = (calles[v.calle] ?? 0) + 1);
    int n = 0;

    var salida = calles.entries.sorted((a, b) => b.value.compareTo(a.value));

    if (1 > 2) {
      print("");
      print("");
      print("");
      print("id;calle;votos");
      salida.forEach((e) {
        final calle = e.key;
        final cantidad = e.value;
        n++;
        if (cantidad > 10) {
          print("$n;$calle;$cantidad");
        }
      });
      print("");
      print("");
      print("");
    }
  }

  static void listarFavoritos() {
    print("[");
    int n = 0;
    Datos.favoritos.forEach((f) {
      n++;
      if (4000 <= n && n < 5000) {
        final aux = f.toJson();
        print('$aux,');
      }
    });
    print("];");
  }

  static void listarCierres() {
    print("[");
    int n = 0;
    Datos.cierres.forEach((f) {
      n++;
      if (0000 <= n && n < 2000) {
        final aux = f.toJson();
        print('$aux,');
      }
    });
    print("];");
  }

  static Map<String, int> contarCalles() {
    Map<String, int> contar = {};
    final lista = votantes.where((v) => v.conCalles && v.entregaPendiente);
    lista.forEach((v) => contar[v.calle] = (contar[v.calle] ?? 0) + 1);
    return contar;
  }

  static Map<String, int> contarDomicilios() {
    final lista = votantes.where((v) => v.conCalles && v.entregaPendiente);

    final contar = Map<String, Set<String>>();
    lista.forEach((v) {
      if (!contar.containsKey(v.calle)) contar[v.calle] = Set<String>();
      contar[v.calle]!.add(v.domicilio);
    });

    Map<String, int> salida = {};
    contar.entries.forEach((e) => salida[e.key] = e.value.length);

    return salida;
  }

  static Map<String, DateTime> calcularActivos() {
    Map<String, DateTime> ultimo = {};
    entregas.forEach((e) {
      if (e.entrega == EstadoEntrega.entregado) {
        final calle = Votante.traer(e.dni).calle;
        ultimo[calle] = e.hora;
      }
    });
    return ultimo;
  }

  static Map<String, int> contarBarrios() {
    final lista = votantes.where((v) => v.enBarrios && v.entregaPendiente);

    final contar = Map<String, int>();
    lista.forEach((v) {
      final clave = v.nombreBarrio;
      contar[clave] = (contar[clave] ?? 0) + 1;
    });

    return contar;
  }

  static List<Votante> listarBarrios() {
    final lista = votantes.where((v) => v.enBarrios && v.entregaPendiente).sortedBy((e) => e.nombre);
    print("ListarBarrios: ${lista.length}");
    List<Votante> salida = [];
    Datos.barrios.forEach((barrio) {
      String nombre = barrio.$1;
      final aux = lista.where((votante) => votante.nombreBarrio == nombre);
      salida.addAll(aux);
    });

    return salida;
  }

  static Future<List<Map<String, dynamic>>> leerCsv(String origen) async {
    String csvData = await rootBundle.loadString('datos/$origen.csv');

    print("${csvData.length}");
    print("${csvData.substring(0, 441)}");

    final parser = CsvToListConverter(fieldDelimiter: ',', textDelimiter: '"');
    final csvTable = parser.convert(csvData);

    final headers = csvTable[0];
    final List<Map<String, dynamic>> jsonList = [];

    for (var i = 1; i < csvTable.length; i++) {
      final row = csvTable[i];
      final jsonMap = <String, dynamic>{};

      for (var j = 0; j < headers.length; j++) {
        final header = headers[j];
        final value = row[j];
        jsonMap[header] = value;
      }

      jsonList.add(jsonMap);
    }

    return jsonList;
  }

  static Future<List<Map<String, dynamic>>> convertirCSVaJSON(String origen) async {
    final csvData = await rootBundle.loadString('datos/$origen.csv');
    final List<List<dynamic>> rows = const CsvToListConverter(fieldDelimiter: ";").convert(csvData);

    final headers = rows[0].map<String>((header) => header.toString()).toList();
    print(">> heades: $headers");
    final List<Map<String, dynamic>> jsonList = [];

    for (var i = 1; i < rows.length; i++) {
      final row = rows[i];
      final jsonMap = <String, dynamic>{};

      for (var j = 0; j < headers.length; j++) {
        final header = headers[j];
        final value = row[j];
        jsonMap[header] = value;
      }

      jsonList.add(jsonMap);
    }

    return jsonList;
  }

  static Future<void> cargarResultados() async {
    final resultado = await leerJson('resultados');
    mesas.forEach((mesa) {
      final nro = mesa.numero;
      final aux = resultado.firstWhereOrNull((r) => r["mesa"] == nro);
      if (aux != null) {
        mesa.votaron = aux["total"];
        mesa.votos = aux["nosotros"];
        mesa.participacion = aux["participacion"];
      } else {
        print("No hay datos para $nro");
      }
    });
  }
}
