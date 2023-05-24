import 'dart:convert';
import '../utils.dart';

import 'datos.dart';
import 'escuela.dart';
import 'favorito.dart';

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

  bool favorito = false;
  bool agrupar = false;
  int nroEscuela = 0;

  int get edad => 2023 - clase.abs();
  Escuela get escuela => Datos.escuelas[nroEscuela];

  String textoCompleto = '';
  List<int> get referentes => Datos.favoritos.where((f) => f.dni == dni).map((f) => f.referente).toList();

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
  ) {
    textoCompleto = ' ${nombre.toLowerCase().sinEspacios.sinAcentos} ';
  }

  factory Votante.anonimo([int dni = 0]) =>
      Votante(dni, 'Sin identificar', 'sin domicilio', 'X', 0, 0, 0, 0, 0, 0, 0, 0);

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
        'longitude': longitude
      };

  Votante copyWith({
    int? dni,
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
    String favorito = ' ',
  }) =>
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
          longitude ?? this.longitude);

  factory Votante.fromMap(Map<String, dynamic> map) => Votante(
      map['dni'],
      map['nombre'] ?? '',
      map['domicilio'] ?? '',
      map['sexo'] ?? '',
      map['clase'],
      map['mesa'],
      map['orden'],
      map['pj'],
      map['cyb'],
      map['ucr'],
      map['latitude'],
      map['longitude']);

  void cambiarFavorito() => this.favorito = !this.favorito;

  String toJson() => json.encode(toMap());

  factory Votante.fromJson(String source) => Votante.fromMap(json.decode(source));

  @override
  String toString() => 'Votante(orden: $orden, dni: $dni, nombre: $nombre, domicilio: $domicilio, sexo: $sexo)';

  @override
  bool operator ==(Object other) => identical(this, other) || other is Votante && other.dni == dni;

  @override
  int get hashCode => dni.hashCode;

  static void organizar(Votantes votantes) {
    var apellido = '';

    for (final v in votantes) {
      if (v.nombre.contains(',')) {
        final nuevo = v.nombre.split(',').first;
        v.agrupar = nuevo == apellido;
        if (nuevo != apellido) {
          apellido = nuevo;
        }
      } else {
        apellido = '';
        v.agrupar = false;
      }
    }
  }

  static Votantes ordenarVotantes(Votantes votantes) {
    votantes.sort((a, b) => a.nombre.compareTo(b.nombre));
    Votante.organizar(votantes);
    return votantes;
  }

  static Map<String, int> contarDomicilio(Votantes votantes) {
    final mapa = <String, int>{};
    for (final v in Datos.votantes) {
      mapa[v.domicilio] = (mapa[v.domicilio] ?? 0) + 1;
    }
    return mapa;
  }

  static Votantes buscar(Votantes votantes, String texto) {
    final palabras = texto.toLowerCase().palabras;
    var origen = votantes;

    medir('Buscado "$texto"', () {
      for (final palabra in palabras) {
        if (palabra == 'mios') {
          origen = origen.where((v) => v.favorito).toList();
        } else if (palabra == 'repetidos') {
          final marcas = Favorito.contar(Datos.favoritos);
          origen = origen.where((v) => (marcas[v.dni] ?? 0) >= 2).toList();
        } else if (palabra == 'todos') {
          final marcas = Favorito.contar(Datos.favoritos);
          origen = origen.where((v) => (marcas[v.dni] ?? 0) >= 1).toList();
        } else if (palabra == 'familia') {
          final marcas = contarDomicilio(origen);
          origen = origen.where((v) => (marcas[v.domicilio] ?? 0) >= 2).toList();
        } else if (RegExp(r'^[0-9]{4}$').hasMatch(palabra)) {
          final mesa = int.parse(palabra);
          origen = origen.where((v) => v.mesa == mesa).toList();
        } else if ((RegExp(r'^[+-][0-9]{2}$').hasMatch(palabra))) {
          final edad = int.parse(palabra);
          origen = origen.where((v) => edad < 0 ? v.edad <= edad.abs() : v.edad >= edad).toList();
        } else if ((RegExp(r'^-[a-zñ]+$').hasMatch(palabra))) {
          final aux = ' ' + palabra.substring(1);
          origen = origen.where((v) => !v.textoCompleto.contains(aux)).toList();
        } else if ((RegExp(r'^[a-zñ]+$').hasMatch(palabra))) {
          final aux = ' ' + palabra;
          origen = origen.where((v) => v.textoCompleto.contains(aux)).toList();
        }
      }
      print('Hay ${origen.length} votantes');
    });

    Votante.organizar(origen);
    return origen;
  }

  static Votante traer(int dni) => Datos.votantes.firstWhere((v) => v.dni == dni, orElse: () => Votante.anonimo(dni));
}
