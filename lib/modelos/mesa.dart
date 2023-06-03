import 'datos.dart';
import 'escuela.dart';
import 'votante.dart';

typedef Mesas = List<Mesa>;

enum EstadoMesa implements Comparable<EstadoMesa> {
  vacia(2),
  completa(0),
  pendiente(1),
  ;

  final int valor;
  const EstadoMesa(this.valor);

  @override
  int compareTo(EstadoMesa o) => this.valor.compareTo(o.valor);
}

class Mesa implements Comparable<Mesa> {
  int numero;
  int inicial = 0;
  int cantidad = 0;
  int nroEscuela = 0;

  bool esCerrada = false;
  Votantes votantes = [];

  Mesa(this.numero);
  void agregar(Votante votante) => votantes.add(votante);

  Escuela get escuela => Datos.escuelas[nroEscuela];
  Votantes get favoritos => votantes.where((v) => v.favorito).toList();
  bool get esAnalizada => !esCerrada && favoritos.length > 0;

  EstadoMesa get estado {
    if (esCerrada) return EstadoMesa.completa;
    if (esAnalizada) return EstadoMesa.pendiente;
    return EstadoMesa.vacia;
  }

  bool get esPrioridad => escuela.esPrioridad;
  void ordenar() => votantes.sort((a, b) => a.nombre.compareTo(b.nombre));

  static Mesa traer(int nro) => Datos.mesas.firstWhere((m) => m.numero == nro, orElse: () => Mesa(nro));

  @override
  int compareTo(Mesa other) => this.estado.compareTo(other.estado);
}
