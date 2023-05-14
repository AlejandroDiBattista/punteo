import './votante.dart';

class Mesa {
  int numero;
  int inicial;
  int cantidad; 
  List<Votante> votantes = [];

  Mesa(this.numero, this.inicial, this.cantidad);

  void agregar(Votante votante) {
    votantes.add(votante);
  }
}
