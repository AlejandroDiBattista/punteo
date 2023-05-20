import 'dart:convert';
import 'package:intl/intl.dart';

class Cierre {
  int mesa;
  int referente;
  DateTime hora;
  bool cerrada = true;
  Cierre({
    required this.mesa,
    required this.referente,
    required this.hora,
  });

  Cierre copyWith({
    int? mesa,
    int? referente,
    DateTime? hora,
  }) {
    return Cierre(
      mesa: mesa ?? this.mesa,
      referente: referente ?? this.referente,
      hora: hora ?? this.hora,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'mesa': mesa,
      'referente': referente,
      'hora': hora,
    };
  }

  factory Cierre.fromMap(Map<String, dynamic> map) {
    return Cierre(
      mesa: int.parse(map['mesa']),
      referente: int.parse(map['referente']),
      hora: DateFormat('dd/MM/yyyy HH:mm:ss').parse(map['hora']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Cierre.fromJson(String source) => Cierre.fromMap(json.decode(source));

  @override
  String toString() => 'Cierre(mesa: $mesa, referente: $referente, hora: $hora)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Cierre && other.mesa == mesa && other.referente == referente && other.hora == hora;
  }

  @override
  int get hashCode => mesa.hashCode ^ referente.hashCode ^ hora.hashCode;

  static List<Cierre> compactar(List<Cierre> cierres) {
    final Map<int, Cierre> salida = {};
    cierres.forEach((c) => salida[c.mesa] = c);
    return salida.values.where((c) => c.cerrada).toList();
  }
}
