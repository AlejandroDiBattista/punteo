import 'dart:convert';
import '../utils.dart';

import 'datos.dart';
import 'favorito.dart';

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
  int escuela = 0;
  String textoCompleto = "";
  List<Favorito> referentes = [];

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
    textoCompleto = nombre.toLowerCase().sinEspacios.sinAcentos;
  }

  factory Votante.anonimo([int dni = 0]) =>
      Votante(dni, "Sin identificar", "sin domicilio", "X", 0, 0, 0, 0, 0, 0, 0, 0);

  Map<String, dynamic> toMap() {
    return {
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
    };
  }

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
    String favorito = " ",
  }) {
    return Votante(
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
    );
  }

  factory Votante.fromMap(Map<String, dynamic> map) {
    return Votante(
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
      map['longitude'],
    );
  }

  void cambiarFavorito() {
    this.favorito = !this.favorito;
  }

  String toJson() => json.encode(toMap());

  factory Votante.fromJson(String source) => Votante.fromMap(json.decode(source));

  @override
  String toString() => 'Votante(orden: $orden, dni: $dni, nombre: $nombre, domicilio: $domicilio, sexo: $sexo)';

  @override
  bool operator ==(Object other) => identical(this, other) || other is Votante && other.dni == dni;

  @override
  int get hashCode => dni.hashCode;

  static void organizar(List<Votante> votantes) {
    var apellido = "";

    for (final v in votantes) {
      if (v.nombre.contains(",")) {
        final nuevo = v.nombre.split(",").first;
        v.agrupar = nuevo == apellido;
        if (nuevo != apellido) {
          apellido = nuevo;
        }
      } else {
        apellido = "";
        v.agrupar = false;
      }
    }
  }

  static List<Votante> ordenarVotantes(List<Votante> votantes) {
    votantes.sort((a, b) => a.nombre.compareTo(b.nombre));
    Votante.organizar(votantes);
    return votantes;
  }

  static List<Votante> buscar(List<Votante> votantes, String texto) {
    List<Votante> salida = [];
    medir("Buscado '$texto'", () {
      texto = texto.sinEspacios.toLowerCase();

      if (texto.isEmpty) {
        salida = votantes;
      } else if (texto == 'mios') {
        salida = votantes.where((v) => v.favorito).toList();
      } else if (texto == 'todos' || texto == 'otros' || texto == 'repetidos') {
        final marcas = Favorito.contar(Datos.favoritos);
        final minimo = texto == 'repetidos' ? 2 : 1;
        salida = votantes.where((v) => (marcas[v.dni] ?? 0) >= minimo).toList();
        if (texto == 'otros') {
          salida = salida.where((v) => !v.favorito).toList();
        }
      } else if (RegExp(r'^[0-9]{4}$').hasMatch(texto)) {
        final mesa = int.parse(texto);
        salida = votantes.where((v) => v.mesa == mesa).toList();
      } else {
        final palabras = texto.palabras;
        salida = votantes.where((v) => v.textoCompleto.contienePalabras(palabras)).toList();
      }
      Votante.ordenarVotantes(salida);
      print(" - Encontrados ${salida.length} votantes");
    });

    return salida;
  }
}
