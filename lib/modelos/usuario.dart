import 'datos.dart';
import 'favorito.dart';
import 'votante.dart';

typedef Usuarios = List<Usuario>;

class Usuario extends Votante {
  int mesasPendientes = 0;
  int mesasCerradas = 0;
  int cantidadAnalizados = 0;
  int cantidadFavoritos = 0;
  int cantidadSesiones = 0;
  int tiempoTrabajado = 0;
  DateTime ultimaSesion = DateTime.now();

  Usuario(super.dni, super.nombre, super.domicilio, super.sexo, super.clase, super.mesa, super.orden, super.pj,
      super.cyb, super.ucr, super.latitude, super.longitude, super.calle, super.altura, super.barrio, super.country);

  factory Usuario.fromMap(Map<String, dynamic> map) => Usuario(
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
        map['calle'],
        map['altura'],
        map['barrio'] == 'si',
        map['country'] == 'si',
      );

  factory Usuario.from(Votante votante) => Usuario.fromMap(votante.toMap());
  get activo => Favorito.esUsuarioActivo(this.dni);
  get ultimoAcceso => Favorito.ultimoAcceso(this.dni);

  factory Usuario.anonimo() => Usuario.from(Votante.anonimo());

  static Usuario traer(int dni) => Datos.traerUsuario(dni);
}
