import 'dart:convert';
import 'entrega.dart';

import '../utils.dart';

import 'datos.dart';
import 'escuela.dart';
import 'favorito.dart';
import 'mesa.dart';
import 'usuario.dart';

typedef Votantes = List<Votante>;

class Votante {
  int dni;
  String nombre;
  String domicilio;
  String sexo;
  int clase;
  int mesa;
  int orden;
  double pj;
  double cyb;
  double ucr;
  double latitude;
  double longitude;

  String calle = "";
  String tag = "";

  int altura = 0;
  bool barrio = false;
  bool country = false;

  bool favorito = false;
  bool busqueda = false;
  EstadoEntrega entrega = EstadoEntrega.desistir;

  int nroEscuela = 0;
  Set<int> referentes = {};

  String textoCompleto = '';

  bool get entregaPendiente => referentes.isNotEmpty && (entrega == EstadoEntrega.pendiente);
  String get nombreBarrio => (this.barrio || this.country) ? this.domicilio.split("-").first.trim() : '';

  int get precision {
    if (conUbicacion) return 0;
    if (esUbicable) return 1;
    if (barrio) return 4;
    if (country) return 5;
    return 3;
  }

  int get edad => 2023 - clase.abs();
  Escuela get escuela => Datos.escuelas[nroEscuela];

  bool get conCoordenas => this.latitude != 0 && this.longitude != 0;
  bool get conUbicacion => this.conCoordenas && !this.barrio && !this.country;
  bool get esUbicable => this.calle.isNotEmpty && !this.barrio && !this.country;
  bool get esNoUbicable => this.precision > 1;
  bool get conCalles => this.conCoordenas && this.calle.isNotEmpty && this.entregaPendiente;
  bool get enBarrios => this.entregaPendiente && (this.barrio || this.country);

  // List<int> get referentes => Datos.favoritos.where((f) => f.dni == dni).map((f) => f.referente).toList();
  Favoritos get favoritos => Datos.favoritos.where((f) => f.referente == dni && f.favorito).toList();

  Votante(
    this.dni,
    this.nombre,
    this.domicilio,
    this.sexo,
    this.clase,
    this.mesa,
    this.orden,
    this.pj,
    this.cyb,
    this.ucr,
    this.latitude,
    this.longitude,
    this.calle,
    this.altura,
    this.barrio,
    this.country,
  ) {
    prepararBusqueda();
  }

  void prepararBusqueda() {
    // textoCompleto = ' ${nombre.toLowerCase().replaceAll(", "," ")} ${domicilio.simplificar} $dni ';
    // textoCompleto = ' ${nombre.simplificar} ${domicilio.simplificar} $dni ';
    textoCompleto = ' ${nombre.simplificar} ';
    tag = calle.replaceAll(" ", "_");
  }

  factory Votante.anonimo([int dni = 0]) =>
      Votante(dni, 'Sin identificar', 'sin domicilio', 'X', 0, 0, 0, 0, 0, 0, 0, 0, "", 0, false, false);

  Map<String, dynamic> toMap() => {
        'dni': dni,
        'nombre': nombre,
        'domicilio': domicilio,
        'sexo': sexo,
        'clase': clase,
        'mesa': mesa,
        'orden': orden,
        'pj': pj,
        'cyb': cyb,
        'ucr': ucr,
        'latitude': latitude,
        'longitude': longitude,
        'calle': calle,
        'altura': altura,
        'barrio': barrio ? 'si' : 'no',
        'country': country ? 'si' : 'no'
      };

  Votante copyWith(
          {int? dni,
          String? nombre,
          String? domicilio,
          String? sexo,
          int? clase,
          int? mesa,
          int? orden,
          double? pj,
          double? cyb,
          double? ucr,
          double? latitude,
          double? longitude,
          String? calle,
          int? altura,
          bool? barrio,
          bool? country}) =>
      Votante(
        dni ?? this.dni,
        nombre ?? this.nombre,
        domicilio ?? this.domicilio,
        sexo ?? this.sexo,
        clase ?? this.clase,
        mesa ?? this.mesa,
        orden ?? this.orden,
        pj ?? this.pj,
        cyb ?? this.cyb,
        ucr ?? this.ucr,
        latitude ?? this.latitude,
        longitude ?? this.longitude,
        calle ?? this.calle,
        altura ?? this.altura,
        barrio ?? this.barrio,
        country ?? this.country,
      );

  factory Votante.fromMap(Map<String, dynamic> map) => Votante(
        map['dni'],
        map['nombre'] ?? '',
        map['domicilio'] ?? '',
        map['sexo'] ?? '',
        map['clase'],
        map['mesa'],
        map['orden'],
        map['pj'] ?? 0,
        map['cyb'] ?? 0,
        map['ucr'] ?? 0,
        map['latitude'] ?? 0,
        map['longitude'] ?? 0,
        map['calle'] ?? '',
        map['altura'],
        // false, false,
        map['barrio'] == 'si',
        map['country'] == 'si',
      );

  void cambiarFavorito() => this.favorito = !this.favorito;
  void marcarBuscar() => this.busqueda = true;

  String toJson() => json.encode(toMap());

  factory Votante.fromJson(String source) => Votante.fromMap(json.decode(source));

  @override
  String toString() => 'Votante(orden: $orden, dni: $dni, nombre: $nombre, domicilio: $domicilio, sexo: $sexo)';

  @override
  bool operator ==(Object other) => identical(this, other) || other is Votante && other.dni == dni;

  @override
  int get hashCode => dni.hashCode;

  static Votantes ordenarVotantes(Votantes votantes) {
    votantes.sort((a, b) => a.nombre.compareTo(b.nombre));
    // Votante.organizar(votantes);
    return votantes;
  }

  static Map<String, int> contarDomicilio(Votantes votantes) {
    final mapa = <String, int>{};
    for (final v in Datos.votantes) {
      mapa[v.domicilio] = (mapa[v.domicilio] ?? 0) + 1;
    }
    return mapa;
  }

  static int traerUsuario(String nombre) {
    nombre = nombre.simplificar;
    return Datos.usuarios.firstWhere((u) => u.nombre.simplificar.contains(nombre), orElse: () => Usuario.anonimo()).dni;
  }

  static Votantes buscar(Votantes votantes, String filtro) {
    filtro = filtro.sinEspacios.replaceAll("por ", "@");
    final palabras = filtro.palabras;
    var origen = votantes;

    medir('Buscado "${filtro.sinEspacios}"', () {
      for (final palabra in palabras) {
        final texto = palabra.simplificar;

        if (palabra == 'mios' || palabra == 'mis') {
          origen = origen.where((v) => v.favorito).toList();
        } else if (palabra == 'repetidos') {
          final marcas = Favorito.contar(Datos.favoritos);
          origen = origen.where((v) => (marcas[v.dni] ?? 0) >= 2).toList();
        } else if (palabra == 'favoritos' || palabra == 'todos' || palabra == 'referidos') {
          final marcas = Favorito.contar(Datos.favoritos);
          origen = origen.where((v) => (marcas[v.dni] ?? 0) >= 1).toList();
        } else if (palabra == 'localizados' || palabra == 'ubicados') {
          origen = origen.where((v) => v.conUbicacion).toList();
        } else if (palabra == 'deslocalizados' || palabra == 'desubicados') {
          origen = origen.where((v) => !v.conUbicacion).toList();
        } else if (palabra == 'ubicable') {
          origen = origen.where((v) => v.esUbicable).toList();
        } else if (palabra == 'noubicable') {
          origen = origen.where((v) => !v.esUbicable).toList();
        } else if (palabra == 'prioridad') {
          origen = origen
              .where((v) => v.conUbicacion && !v.favorito && v.escuela.esPrioridad && Mesa.traer(v.mesa).esPrioridad)
              .toList();
        } else if (palabra == 'cerca') {
          final usuario = Datos.usuarioActual;
          if (usuario.conUbicacion) {
            origen = origen.where((v) => v.conUbicacion && (Votante.distancia(v, usuario) <= 300)).toList();
          }
        } else if (palabra == 'barrio') {
          origen = origen.where((v) => v.barrio).toList();
        } else if (palabra == 'country') {
          origen = origen.where((v) => v.country).toList();
        } else if (RegExp(r'[#][a-z]{3,}$').hasMatch(palabra)) {
          origen = origen.where((v) => v.tag == texto).toList();
        } else if (RegExp(r'[:][a-z]{3,}$').hasMatch(palabra)) {
          origen = origen.where((v) => v.conCalles && v.calle.toLowerCase().contains(texto)).toList();
        } else if ((RegExp(r'[@][a-z]{3,}$').hasMatch(palabra))) {
          final usuario = traerUsuario(texto);
          if (usuario > 0) origen = origen.where((v) => v.marcadoPor(usuario)).toList();
        } else if ((RegExp(r'^<[=]?[0-9]{3,}$').hasMatch(palabra))) {
          final usuario = Datos.usuarioActual;
          if (usuario.conUbicacion) {
            final distancia = int.parse(texto);
            origen = origen.where((v) => v.conUbicacion && (Votante.distancia(v, usuario) <= distancia)).toList();
          }
        } else if ((RegExp(r'^>[=]?[0-9]{3,}$').hasMatch(palabra))) {
          final usuario = Datos.usuarioActual;
          if (usuario.conUbicacion) {
            final distancia = int.parse(texto);
            origen = origen.where((v) => v.conUbicacion && (Votante.distancia(v, usuario) >= distancia)).toList();
          }
        } else if (['m', 'hombre', 'f', 'mujer'].contains(palabra)) {
          final sexo = palabra == 'hombre' || palabra == 'M' ? 'M' : 'F';
          origen = origen.where((v) => v.sexo == sexo).toList();
        } else if (palabra == 'familia') {
          final marcas = contarDomicilio(origen);
          origen = origen.where((v) => (marcas[v.domicilio] ?? 0) >= 2).toList();
        } else if (palabra == 'pendiente') {
          origen = origen.where((v) => v.entrega == EstadoEntrega.pendiente).toList();
        } else if (palabra == 'entregado') {
          origen = origen.where((v) => v.entrega == EstadoEntrega.entregado).toList();
        } else if (RegExp(r'^3[0-9]{3}$').hasMatch(palabra)) {
          final mesa = int.parse(texto);
          origen = origen.where((v) => v.mesa == mesa).toList();
        } else if (RegExp(r'^[0-9]{7,8}$').hasMatch(texto)) {
          final dni = int.parse(texto);
          origen = origen.where((v) => v.dni == dni).toList();
        } else if ((RegExp(r'^[+-][0-9]{2}$').hasMatch(palabra))) {
          final edad = int.parse(palabra);
          origen = origen.where((v) => edad < 0 ? v.edad <= edad.abs() : v.edad >= edad).toList();
        } else if ((RegExp(r'^-[A-ZÑa-zñ]+$').hasMatch(palabra))) {
          final aux = ' $texto ';
          origen = origen.where((v) => !v.textoCompleto.contains(aux)).toList();
        } else if ((RegExp(r'^[+][A-ZÑa-zñ]+$').hasMatch(palabra))) {
          final aux = ' $texto ';
          origen = origen.where((v) => v.textoCompleto.contains(aux)).toList();
        } else if (palabra.soloLetras) {
          final aux = ' $texto${palabra.esNombre ? ' ' : ''}';
          // print(" >> Busqueda normal [$aux]");
          origen = origen.where((v) => v.textoCompleto.contains(aux)).toList();
        }
        // print(" - $palabra (${palabra.esNombre.info()})> $texto > ${origen.length}");
      }
    });
    print('Hay ${origen.length} votantes para [$filtro]');
    // Votante.organizar(origen);
    return origen;
  }

  static double distancia(Votante a, Votante b) {
    if (a.latitude == 0 || b.latitude == 0) return double.infinity;
    return distanciaEnMetros(a.latitude, a.longitude, b.latitude, b.longitude);
  }

  // static Votante traer(int dni) => Datos.votantes.firstWhere((v) => v.dni == dni, orElse: () => Votante.anonimo(dni));
  static Votante traer(int dni) => Datos.cache[dni] ?? Votante.anonimo(dni);

  bool marcadoPor(int referente) => referentes.contains(referente);
}
