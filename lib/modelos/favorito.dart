import 'dart:convert';
import 'package:intl/intl.dart';

import 'datos.dart';

class Favorito {
  int dni;
  int referente;
  bool favorito;
  DateTime hora;

  Favorito({
    required this.dni,
    required this.referente,
    required this.favorito,
    required this.hora,
  });

  Favorito copyWith({int? dni, int? referente, bool? favorito, DateTime? hora}) {
    return Favorito(
      dni: dni ?? this.dni,
      referente: referente ?? this.referente,
      favorito: favorito ?? this.favorito,
      hora: hora ?? this.hora,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'dni': dni,
      'referente': referente,
      'favorito': favorito,
      'hora': hora.millisecondsSinceEpoch,
    };
  }

  factory Favorito.fromMap(Map<String, dynamic> map) {
    return Favorito(
        dni: int.parse(map['dni']),
        referente: int.parse(map['referente']),
        favorito: map['favorito'] == "S",
        hora: DateFormat('dd/MM/yyyy HH:mm:ss').parse(map['hora']));
  }

  String toJson() => json.encode(toMap());

  factory Favorito.fromJson(String source) => Favorito.fromMap(json.decode(source));

  @override
  String toString() => 'Favorito(dni: $dni, referente: $referente, favorito: $favorito, hora: $hora)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Favorito && other.dni == dni && other.referente == referente && other.favorito == favorito;

  @override
  int get hashCode => dni.hashCode ^ referente.hashCode ^ favorito.hashCode ^ hora.hashCode;

  static List<Favorito> compactar(List<Favorito> favoritos) {
    final Map<(int, int), Favorito> salida = {};
    favoritos.sort((a, b) => a.hora.compareTo(b.hora));

    favoritos.forEach((f) => salida[(f.dni, f.referente)] = f);

    final nuevos = salida.values.where((f) => f.favorito).toList();
    nuevos.sort((a, b) => a.hora.compareTo(b.hora));

    return nuevos;
  }

  static Map<int, int> contar(List<Favorito> favoritos) {
    final Map<int, int> salida = {};
    for (final votante in favoritos) {
      salida[votante.dni] = (salida[votante.dni] ?? 0) + 1;
    }
    return salida;
  }

  static List<(DateTime hora, Duration duracion, int favoritos)> calcularSesiones(int dni) {
    final lista = Datos.favoritos.where((f) => f.referente == dni).toList();
    lista.sort((a, b) => a.hora.compareTo(b.hora));

    DateTime? anterior, ultimo;
    int n = 0;
    List<(DateTime, Duration, int)> salida = [];

    for (final f in lista) {
      if (anterior == null) {
        anterior = f.hora;
      } else {
        final separacion = f.hora.difference(ultimo!);
        n++;
        if (separacion.inMinutes > 10) {
          salida.add((anterior, ultimo.difference(anterior), n));
          anterior = null;
          n = 0;
        }
      }
      ultimo = f.hora;
    }
    if (n > 0) {
      salida.add((anterior!, ultimo!.difference(anterior), n));
    }
    salida.sort((a, b) => a.$1.compareTo(b.$1));

    return salida;
  }

  static int calcularMinutosTrabajado(int dni) {
    final lista = Datos.favoritos.where((f) => f.referente == dni).toList();
    lista.sort((a, b) => a.hora.compareTo(b.hora));

    DateTime? anterior, ultimo;
    int n = 0;
    int salida = 0;
    for (final f in lista) {
      if (anterior == null) {
        anterior = f.hora;
      } else {
        final separacion = f.hora.difference(ultimo!);
        n++;
        if (separacion.inMinutes > 10) {
          salida += ultimo.difference(anterior).inMinutes;
          anterior = null;
          n = 0;
        }
      }
      ultimo = f.hora;
    }
    if (n > 0) {
      salida += ultimo!.difference(anterior!).inMinutes;
    }

    return salida;
  }

  static bool esUsuarioActivo(int dni) {
    final lista = Datos.favoritos.where((f) => f.referente == dni).toList();
    final ahora = DateTime.now();
    return lista.any((v) => ahora.difference(v.hora).inMinutes.abs() < 5);
  }
}
