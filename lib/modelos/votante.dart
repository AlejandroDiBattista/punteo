import 'dart:convert';

class Votante {
  int mesa;
  int orden;
  int dni;
  String nombre;
  String domicilio;
  String sexo;
  int clase;
  double latitude;
  double longitude;
  double pj;
  double cyb;
  double ucr;

  bool favorito = false;

  Votante(
    this.mesa,
    this.orden,
    this.dni,
    this.nombre,
    this.domicilio,
    this.sexo,
    this.clase,
    this.latitude,
    this.longitude,
    this.pj,
    this.cyb,
    this.ucr,
  );

  Map<String, dynamic> toMap() {
    return {
      'mesa': mesa,
      'orden': orden,
      'dni': dni,
      'nombre': nombre,
      'domicilio': domicilio,
      'sexo': sexo,
      'clase': clase,
      'latitude': latitude,
      'longitude': longitude,
      'pj': pj,
      'cyb': cyb,
      'ucr': ucr,
    };
  }

  Votante copyWith({
    int? mesa,
    int? orden,
    int? dni,
    String? nombre,
    String? domicilio,
    String? sexo,
    int? clase,
    double? latitude,
    double? longitude,
    double? pj,
    double? cyb,
    double? ucr,
    String favorito = " ",
  }) {
    return Votante(
      mesa ?? this.mesa,
      orden ?? this.orden,
      dni ?? this.dni,
      nombre ?? this.nombre,
      domicilio ?? this.domicilio,
      sexo ?? this.sexo,
      clase ?? this.clase,
      latitude ?? this.latitude,
      longitude ?? this.longitude,
      pj ?? this.pj,
      cyb ?? this.cyb,
      ucr ?? this.ucr,
    );
  }

  factory Votante.fromMap(Map<String, dynamic> map) {
    return Votante(
      map['mesa'],
      map['orden'],
      map['dni'],
      map['nombre'] ?? '',
      map['domicilio'] ?? '',
      map['sexo'] ?? '',
      map['clase'],
      map['latitude'],
      map['longitude'],
      map['pj'],
      map['cyb'],
      map['ucr'],
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
}
