import 'dart:convert';
import 'package:intl/intl.dart';

import 'datos.dart';

typedef Sesion = (DateTime hora, Duration duracion, int favoritos);
typedef Favoritos = List<Favorito>;

class Favorito {
  int dni;
  int referente;
  bool favorito;
  bool busqueda;
  DateTime hora;

  Favorito({
    required this.dni,
    required this.referente,
    required this.favorito,
    required this.hora,
    this.busqueda = false,
  });

  Favorito copyWith({int? dni, int? referente, bool? favorito, DateTime? hora, bool? busqueda}) => Favorito(
      dni: dni ?? this.dni,
      referente: referente ?? this.referente,
      favorito: favorito ?? this.favorito,
      hora: hora ?? this.hora,
      busqueda: busqueda ?? this.busqueda);

  Map<String, dynamic> toMap() => {
        'dni': dni,
        'referente': referente,
        'favorito': favorito,
        'busqueda': busqueda,
        'hora': hora.millisecondsSinceEpoch,
      };
  factory Favorito.fromMap(Map<String, dynamic> map) => Favorito(
      dni: int.parse(map['dni']),
      referente: int.parse(map['referente']),
      favorito: map['favorito'] == "S",
      busqueda: (map['busqueda'] ?? "N") == "S",
      hora: DateFormat('dd/MM/yyyy HH:mm:ss').parse(map['hora']));

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

  static Favoritos compactar(Favoritos favoritos) {
    final Map<(int, int), Favorito> salida = {};
    favoritos.sort((a, b) => a.hora.compareTo(b.hora));

    favoritos.forEach((favorito) => salida[(favorito.dni, favorito.referente)] = favorito);

    final nuevos = salida.values.where((f) => f.favorito).toList();
    nuevos.sort((a, b) => a.hora.compareTo(b.hora));

    return nuevos;
  }

  static Map<int, int> contar(Favoritos favoritos) {
    final Map<int, int> salida = {};
    for (final votante in favoritos) {
      salida[votante.dni] = (salida[votante.dni] ?? 0) + 1;
    }
    return salida;
  }

  static List<Sesion> calcularSesiones(int dni) {
    final lista = Datos.favoritos.where((f) => f.referente == dni).toList();
    lista.sort((a, b) => a.hora.compareTo(b.hora));

    DateTime? anterior, ultimo;
    int n = 0;
    List<Sesion> salida = [];

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

  static DateTime ultimoAcceso(int dni) => calcularSesiones(dni).last.$1;

  static bool esUsuarioActivo(int dni) {
    final lista = Datos.favoritos.where((f) => f.referente == dni).toList();
    final ahora = DateTime.now();
    return lista.any((v) => ahora.difference(v.hora).inMinutes.abs() < 5);
  }
}
