import 'dart:convert';
import './mesa.dart';

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
  List<Mesa> mesas = [];

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

  void agregar(Mesa mesa) {
    mesas.add(mesa);
  }

  factory Escuela.fromMap(Map<String, dynamic> data) {
    return Escuela(
      escuela: data['escuela'],
      direccion: data['direccion'],
      desde: data['desde'],
      hasta: data['hasta'],
      circuito: data['circuito'],
      departamento: data['departamento'],
      seccion: data['seccion'],
      latitude: data['latitude'],
      longitude: data['longitude'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'escuela': escuela,
      'direccion': direccion,
      'desde': desde,
      'hasta': hasta,
      'circuito': circuito,
      'departamento': departamento,
      'seccion': seccion,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

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
  }) {
    return Escuela(
      escuela: escuela ?? this.escuela,
      direccion: direccion ?? this.direccion,
      desde: desde ?? this.desde,
      hasta: hasta ?? this.hasta,
      circuito: circuito ?? this.circuito,
      departamento: departamento ?? this.departamento,
      seccion: seccion ?? this.seccion,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }

  String toJson() => json.encode(toMap());

  factory Escuela.fromJson(String source) => Escuela.fromMap(json.decode(source));
  get completa => totalCerradas == totalMesas;

  get totalMesas => mesas.length;
  get totalCerradas => mesas.where((mesa) => mesa.cerrada).length;

  get totalVotantes => mesas.map((mesa) => mesa.votantes.length).reduce((value, element) => value + element);
  get totalFavoritos => mesas.map((mesa) => mesa.favoritos.length).reduce((value, element) => value + element);
  @override
  String toString() =>
      'Escuela(escuela: $escuela, direccion: $direccion, desde: $desde, hasta: $hasta, mesas: $mesas, votantes: $totalVotantes, circuito: $circuito, departamento: $departamento, seccion: $seccion, latitude: $latitude, longitude: $longitude)';

  @override
  bool operator ==(Object other) => identical(this, other) || other is Escuela && other.escuela == escuela;

  @override
  int get hashCode => escuela.hashCode;
}
