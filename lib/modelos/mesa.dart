import './votante.dart';

class Mesa {
  int numero;
  int inicial;
  int cantidad;
  List<Votante> votantes = [];
  bool cerrada = false;

  Mesa(this.numero, this.inicial, this.cantidad);

  get favoritos => votantes.where((v) => v.favorito).toList();

  void agregar(Votante votante) {
    votantes.add(votante);
  }

  String limpiar(String nombre) => nombre.replaceAll(RegExp(r'[^a-zA-Z0-9áéíóúÁÉÍÓÚñÑ ]'), '');

  void ordenar() {
    votantes.sort((a, b) => limpiar(a.nombre).compareTo(limpiar(b.nombre)));
  }
}
