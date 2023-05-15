import './votante.dart';

class Mesa {
  int numero;
  int inicial = 0;
  int cantidad = 0;
  List<Votante> votantes = [];
  bool cerrada = false;

  Mesa(this.numero);

  List<Votante> get favoritos => votantes.where((v) => v.favorito).toList();

  void agregar(Votante votante) {
    votantes.add(votante);
  }

  String limpiar(String nombre) => nombre.replaceAll(RegExp(r'[^a-zA-Z0-9áéíóúÁÉÍÓÚñÑ ]'), '');

  void ordenar() {
    votantes.sort((a, b) => limpiar(a.nombre).compareTo(limpiar(b.nombre)));
    var apellido = "";
    for (final v in votantes) {
      if (v.nombre.contains(",")) {
        final nuevo = v.nombre.split(",").first;
        v.agrupar = nuevo == apellido;
        if (nuevo != apellido) {
          apellido = nuevo;
        }
      } else {
        apellido = "";
        v.agrupar = false;
      }
      v.mesa = numero;
    }
  }
}
