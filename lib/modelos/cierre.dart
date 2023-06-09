import 'dart:convert';
import 'package:intl/intl.dart';

typedef Cierres = List<Cierre>;

class Cierre {
  int mesa;
  int referente;
  DateTime hora;
  bool cerrada = true;

  Cierre({required this.mesa, required this.referente, required this.hora, this.cerrada = true});

  Cierre copyWith({int? mesa, int? referente, DateTime? hora}) =>
      Cierre(mesa: mesa ?? this.mesa, referente: referente ?? this.referente, hora: hora ?? this.hora);

  Map<String, dynamic> toMap() => {'mesa': mesa, 'referente': referente, 'hora': hora, 'cerrada': cerrada};

  factory Cierre.fromMap(Map<String, dynamic> map) => Cierre(
      mesa: int.parse(map['mesa']),
      referente: int.parse(map['referente']),
      hora: DateFormat('dd/MM/yyyy HH:mm:ss').parse(map['hora']),
      cerrada: true);

  factory Cierre.minimo(int mesa, int referente, bool cerrada) =>
      Cierre(mesa: mesa, referente: referente, hora: DateTime.now(), cerrada: cerrada);

  String toJson() => json.encode(toMap());
  factory Cierre.fromJson(String source) => Cierre.fromMap(json.decode(source));

  @override
  String toString() => 'Cierre(mesa: $mesa, referente: $referente, hora: $hora)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Cierre && other.mesa == mesa && other.referente == referente && other.hora == hora;

  @override
  int get hashCode => mesa.hashCode ^ referente.hashCode ^ hora.hashCode;

  static Cierres compactar(Cierres cierres) {
    final Map<(int, int), Cierre> salida = {};
    cierres.forEach((cierre) => salida[(cierre.mesa, cierre.referente)] = cierre);

    final nuevos = salida.values.where((c) => c.cerrada).toList();
    nuevos.sort((a, b) => a.hora.compareTo(b.hora));

    return nuevos;
  }
}
