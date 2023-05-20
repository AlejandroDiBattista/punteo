import 'votante.dart';

class Mesa {
  int numero;
  int inicial = 0;
  int cantidad = 0;
  List<Votante> votantes = [];
  bool cerrada = false;
  int escuela = 0;

  Mesa(this.numero);

  List<Votante> get favoritos => votantes.where((v) => v.favorito).toList();

  void agregar(Votante votante) => votantes.add(votante);

  void ordenar() {
    votantes.sort((a, b) => a.nombre.compareTo(b.nombre));
    Votante.organizar(votantes);
  }
}
