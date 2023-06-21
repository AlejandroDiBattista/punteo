import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import 'datos.dart';
import 'mesa.dart';

typedef Escuelas = List<Escuela>;

enum EstadoEscuela implements Comparable<EstadoEscuela> {
  vacia(2),
  completa(0),
  pendiente(1),
  ;

  final valor;
  const EstadoEscuela(this.valor);

  @override
  int compareTo(EstadoEscuela o) => this.valor.compareTo(o.valor);

  get color => switch (this) {
        EstadoEscuela.completa => Colors.green,
        EstadoEscuela.pendiente => Colors.red,
        EstadoEscuela.vacia => Colors.black
      };
}

class Escuela implements Comparable<Escuela> {
  String escuela;
  String direccion;
  String circuito;
  String departamento;
  String seccion;
  int prioridad;
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
      required this.prioridad,
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
    int? prioridad,
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
          prioridad: prioridad ?? this.prioridad,
          latitude: latitude ?? this.latitude,
          longitude: longitude ?? this.longitude);

  factory Escuela.noIdentificada() => Escuela(
      escuela: "Sin definir",
      direccion: "Sin dirección",
      desde: 0,
      hasta: 0,
      circuito: "",
      departamento: "",
      seccion: "",
      prioridad: 99,
      latitude: 0,
      longitude: 0);

  factory Escuela.fromMap(Map<String, dynamic> data) => Escuela(
      escuela: data['escuela'],
      direccion: data['direccion'],
      desde: data['desde'] as int,
      hasta: data['hasta'] as int,
      circuito: data['circuito'],
      departamento: data['departamento'],
      seccion: data['seccion'],
      prioridad: data['prioridad'] as int,
      latitude: data['latitude'] as double,
      longitude: data['longitude'] as double);

  factory Escuela.fromJson(String source) => Escuela.fromMap(json.decode(source));

  Map<String, dynamic> toMap() => {
        'escuela': escuela,
        'direccion': direccion,
        'desde': desde,
        'hasta': hasta,
        'circuito': circuito,
        'departamento': departamento,
        'seccion': seccion,
        'prioridad': prioridad,
        'latitude': latitude,
        'longitude': longitude
      };

  String toJson() => json.encode(toMap());

  @override
  String toString() =>
      'Escuela(escuela: $escuela, direccion: $direccion, desde: $desde, hasta: $hasta, mesas: $mesas, votantes: $totalVotantes, circuito: $circuito, departamento: $departamento, seccion: $seccion, latitude: $latitude, longitude: $longitude)';

  // Acciones
  void agregar(Mesa mesa) => mesas.add(mesa);

  EstadoEscuela get estado {
    if (cantidadMesasCerradas == cantidadMesas) return EstadoEscuela.completa;
    if (cantidadMesasCerradas > 0) return EstadoEscuela.pendiente;
    return EstadoEscuela.vacia;
  }

  // bool get esCompleta => cantidadMesasCerradas == cantidadMesas;
  // bool get esAnalizada => cantidadMesasAnalizadas > 0;
  // bool get esPendiente => (esAnalizada || cantidadMesasCerradas > 0) && !esCompleta;
  // bool get esIgnorada => !esPendiente && !esCompleta;

  bool get esPrioridad => prioridad <= 5;
  int get cantidadMesas => mesas.length;
  int get cantidadMesasAnalizadas => mesas.where((mesa) => mesa.esAnalizada).length;
  int get cantidadMesasCerradas => mesas.where((mesa) => mesa.esCerrada).length;

  int get totalVotantes => mesas.map((mesa) => mesa.votantes.length).sum;
  int get totalVotantesFavoritos => mesas.map((mesa) => mesa.favoritos.length).sum;
  int get totalVotantesAnalizados => mesas.map((m) => m.esAnalizada ? m.votantes.length : 0).sum;
  int get totalVotantesCerrados => mesas.map((m) => m.esCerrada ? m.votantes.length : 0).sum;

  int get votaron => mesas.map((mesa) => mesa.votaron).sum;
  int get votos => mesas.map((mesa) => mesa.votos).sum;
  int get entregas => mesas.map((mesa) => mesa.entregas).sum;

  get favoritos => mesas.map((mesa) => mesa.favoritos).expand((element) => element).toList();

  @override
  bool operator ==(Object other) => identical(this, other) || other is Escuela && other.escuela == escuela;

  @override
  int get hashCode => escuela.hashCode;

  void ordenar() => mesas.forEach((mesa) => mesa.ordenar());

  static Escuela traer(int mesa) =>
      Datos.escuelas.firstWhere((e) => e.desde <= mesa && mesa <= e.hasta, orElse: () => Escuela.noIdentificada());

  @override
  int compareTo(Escuela other) {
    if (this.esPrioridad && !other.esPrioridad) return -1;
    if (!this.esPrioridad && other.esPrioridad) return 1;
    return this.estado.compareTo(other.estado);
  }
}
