import 'dart:convert';

import 'package:intl/intl.dart';

enum EstadoEntrega {
  vacio(""),
  pendiente("P"),
  entregado("E"),
  desistir("D"),
  ;

  final String clave;
  const EstadoEntrega(this.clave);

  @override
  String toString() => switch (this) {
        vacio => 'Sin definir',
        pendiente => 'Pendiente',
        desistir => 'No encontrado',
        entregado => 'Entregado'
      };
}

typedef Entregas = List<Entrega>;

class Entrega {
  int dni;
  int referente;
  EstadoEntrega entrega;
  DateTime hora;

  Entrega({
    required this.dni,
    required this.referente,
    required this.entrega,
    required this.hora,
  });

  Entrega copyWith({int? dni, int? referente, EstadoEntrega? entrega, DateTime? hora, bool? busqueda}) => Entrega(
        dni: dni ?? this.dni,
        referente: referente ?? this.referente,
        entrega: entrega ?? this.entrega,
        hora: hora ?? this.hora,
      );

  Map<String, dynamic> toMap() => {
        'dni': dni,
        'referente': referente,
        'entrega': entrega.toString(),
        'hora': hora.millisecondsSinceEpoch,
      };

  factory Entrega.minimo(int dni, int referente, bool entrega) => Entrega(
      dni: dni,
      referente: referente,
      entrega: entrega ? EstadoEntrega.entregado : EstadoEntrega.desistir,
      hora: DateTime.now());

  factory Entrega.fromMap(Map<String, dynamic> map) => Entrega(
      dni: int.parse(map['dni']),
      referente: int.parse(map['referente']),
      entrega: switch (map['entregado']) {
        "E" => EstadoEntrega.entregado,
        "D" => EstadoEntrega.desistir,
        "P" => EstadoEntrega.pendiente,
        _ => EstadoEntrega.vacio
      },
      hora: DateFormat('dd/MM/yyyy HH:mm:ss').parse(map['hora']));

  String toJson() => json.encode(toMap());
  factory Entrega.fromJson(String source) => Entrega.fromMap(json.decode(source));

  @override
  String toString() => 'Entrega(dni: $dni, referente: $referente, entrega: $entrega, hora: $hora)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Entrega && other.dni == dni && other.referente == referente && other.entrega == this.entrega;
  @override
  int get hashCode => dni.hashCode ^ referente.hashCode ^ entrega.hashCode ^ hora.hashCode;

  static Entregas compactar(Entregas entregas) {
    final Map<int, Entrega> salida = {};
    entregas.sort((a, b) => a.hora.compareTo(b.hora));

    entregas.forEach((entrega) => salida[entrega.dni] = entrega);
    return salida.values.toList();
  }

  static Map<int, int> contar(Entregas entregas) {
    final Map<int, int> salida = {};
    for (final votante in entregas) {
      salida[votante.dni] = (salida[votante.dni] ?? 0) + 1;
    }
    return salida;
  }
}
