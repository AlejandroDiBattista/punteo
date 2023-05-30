import 'dart:convert';
// import 'votante.dart';

import 'datos.dart';
import 'mesa.dart';
import 'package:collection/collection.dart';

typedef Escuelas = List<Escuela>;

class Escuela {
  String escuela;
  String direccion;
  String circuito;
  String departamento;
  String seccion;
  double latitude;
  double longitude;
  int desde;
  int hasta;
  Mesas mesas = [];

  Escuela(
      {required this.escuela,
      required this.direccion,
      required this.desde,
      required this.hasta,
      required this.circuito,
      required this.departamento,
      required this.seccion,
      required this.latitude,
      required this.longitude});

  Escuela copyWith({
    String? escuela,
    String? direccion,
    int? desde,
    int? hasta,
    String? circuito,
    String? departamento,
    String? seccion,
    double? latitude,
    double? longitude,
  }) =>
      Escuela(
          escuela: escuela ?? this.escuela,
          direccion: direccion ?? this.direccion,
          desde: desde ?? this.desde,
          hasta: hasta ?? this.hasta,
          circuito: circuito ?? this.circuito,
          departamento: departamento ?? this.departamento,
          seccion: seccion ?? this.seccion,
          latitude: latitude ?? this.latitude,
          longitude: longitude ?? this.longitude);

  factory Escuela.noIdentificada() => Escuela(
      escuela: "Sin definir",
      direccion: "sin dirección",
      desde: 0,
      hasta: 0,
      circuito: "",
      departamento: "",
      seccion: "",
      latitude: 0,
      longitude: 0);

  factory Escuela.fromMap(Map<String, dynamic> data) => Escuela(
      escuela: data['escuela'],
      direccion: data['direccion'],
      desde: data['desde'],
      hasta: data['hasta'],
      circuito: data['circuito'],
      departamento: data['departamento'],
      seccion: data['seccion'],
      latitude: data['latitude'],
      longitude: data['longitude']);

  factory Escuela.fromJson(String source) => Escuela.fromMap(json.decode(source));

  Map<String, dynamic> toMap() => {
        'escuela': escuela,
        'direccion': direccion,
        'desde': desde,
        'hasta': hasta,
        'circuito': circuito,
        'departamento': departamento,
        'seccion': seccion,
        'latitude': latitude,
        'longitude': longitude
      };

  String toJson() => json.encode(toMap());

  @override
  String toString() =>
      'Escuela(escuela: $escuela, direccion: $direccion, desde: $desde, hasta: $hasta, mesas: $mesas, votantes: $totalVotantes, circuito: $circuito, departamento: $departamento, seccion: $seccion, latitude: $latitude, longitude: $longitude)';

  // Acciones
  void agregar(Mesa mesa) => mesas.add(mesa);

  bool get esCompleta => cantidadMesasCerradas == cantidadMesas;
  bool get esAnalizada => cantidadMesasAnalizadas > 0;

  int get cantidadMesas => mesas.length;
  int get cantidadMesasAnalizadas => mesas.where((mesa) => mesa.esAnalizada).length;
  int get cantidadMesasCerradas => mesas.where((mesa) => mesa.esCerrada).length;

  int get totalVotantes => mesas.map((mesa) => mesa.votantes.length).sum;
  int get totalVotantesFavoritos => mesas.map((mesa) => mesa.favoritos.length).sum;
  int get totalVotantesAnalizados => mesas.map((m) => m.esAnalizada ? m.votantes.length : 0).sum;
  int get totalVotantesCerrados => mesas.map((m) => m.esCerrada ? m.votantes.length : 0).sum;

  get favoritos => mesas.map((mesa) => mesa.favoritos).expand((element) => element).toList();

  @override
  bool operator ==(Object other) => identical(this, other) || other is Escuela && other.escuela == escuela;

  @override
  int get hashCode => escuela.hashCode;

  void ordenar() => mesas.forEach((mesa) => mesa.ordenar());

  static Escuela traer(int mesa) =>
      Datos.escuelas.firstWhere((e) => e.desde <= mesa && mesa <= e.hasta, orElse: () => Escuela.noIdentificada());
}
