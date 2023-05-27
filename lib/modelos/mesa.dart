import 'datos.dart';
import 'escuela.dart';
import 'votante.dart';

typedef Mesas = List<Mesa>;

class Mesa {
  int numero;
  int inicial = 0;
  int cantidad = 0;
  bool esCerrada = false;
  int nroEscuela = 0;

  Votantes votantes = [];
  Votantes get favoritos => votantes.where((v) => v.favorito).toList();

  Mesa(this.numero);
  Escuela get escuela => Datos.escuelas[nroEscuela];

  bool get esAnalizada => !esCerrada && favoritos.length > 0;

  void agregar(Votante votante) => votantes.add(votante);

  void ordenar() {
    votantes.sort((a, b) => a.nombre.compareTo(b.nombre));
    Votante.organizar(votantes);
  }

  static Mesa traer(int nro) {
    for (final e in Datos.escuelas) {
      for (final m in e.mesas) {
        if (m.numero == nro) {
          return m;
        }
      }
    }
    return Mesa(nro);
  }
}
