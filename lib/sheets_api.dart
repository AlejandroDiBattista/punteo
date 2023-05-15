import 'package:gsheets/gsheets.dart';
import 'modelos/mesa.dart';
import 'modelos/votante.dart';
import 'modelos/escuela.dart';
import 'package:intl/intl.dart';

typedef Json = Map<String, dynamic>;

String horaActual() {
  final fecha = DateTime.now();
  final formato = DateFormat('dd/MM/yyyy HH:mm:ss');
  final fechaFormateada = formato.format(fecha);
  return fechaFormateada;
}

class SheetsApi {
  static const _credencial = {
    'type': 'service_account',
    'project_id': 'contador-903c2',
    'private_key_id': '8b60777bc1c1beadd84979a5f8b4a8fe7bd12b21',
    'private_key':
        '-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQDiPZWqn0yI7xKe\nldL9hA0Gi6D1QSg0cc6DpaopKcPey8LQ8eBNCcd1G8ltFxARTTyySU8+s0F/qswJ\nfyXGVzyIifME231PzOZlR12MWcK4DgXjW2bRuP2vjUa0i9UYO1T8jt3D7BOg1lUd\ntbndMMg5kxSsngNs3G30f/+aUZDNtWy3bUNULNi9Kpcj6p6BCXpzDItTkEPG6Iij\nAagwzB43fd0J6FrTp8EB6IRn89FMxita7DfOciZIVatV0pdH2cMf6o5xALWGe+tv\nkAZ02NA4EtRUoZ3GVgsjT/bwuJHdz/P88u38rDiGYZH096kSsVnIkmmZGwEhDO5D\npOMte1tHAgMBAAECggEAEcrKFGsGt9YlXrdlqm5SH+unMuJ26PjyRsQmh6ozLzhT\nD9+Vxjk4qGsRAjVIHDQ4y8ScKNAsHIAwH6cSL3D437wJkp44UqhIjjp4jusYNyVT\nLTgo8+Fagg3YO6arkYZI/ru1kQzl1kZE11tNTKnjdTOt8o1Ss6L6Oro+PcKgYqz2\nDLat9Gp5qNZ18vRuWnsKMfWcqgxgFjmcw6Ji0xNGakjH1MDKFaD7bkXjyQc7dDC9\ne0kzZah/FYBittT01TUCinRx35gekJ2OaH2NGmjVdxTJMoQEvO5yZiEoNJDa/ZRO\nduNSrRADnHcUcXSbCSfks1AT8zGRoqoNShxqExcH8QKBgQD2c7xOxV/DbEqJiRhB\nmw6uTYJiu2gnO8oRvyOGtHHE7T3k5AVZqkQKUPq19JxXk+P5FVabM02I4Pb4fbik\nGxLIoSxkEOoUFShDhrfD2j9zUoRhnZcVkvba1e5S6c4LgmtMVSM7Xnn72Mon0efJ\nUjjmnLxFLLDAJzNa7J/3BQF5nQKBgQDrAWUgHSJpsKIgAwLGpogGm8OlSIiQcZp9\nyDGnOX3wHEuWH0ypOYdsa+vRFk8B8krq2EaznD22ClB7c3xprgbd6WKoI2ROjm1u\n/DfYgqlDeEUFkx5v6hlivQ/d9MiSjeSaYkid1jCdNowk3sNbiq5mGQXDTgpy1U7m\nFRJsbltVMwKBgBGzYEv8CxO7HGNicFaN73D/aiTzNtjSh4Hcy41qOl2deHuPEP9O\nplJjXI5jAjOcEJycNrsw5Rm2pqZUSUWoGCJGySxqtpU4q8qly18KttHulEl6ixZm\nlspC4TodRso21MQHvV8POw2mlWZkwhQIjsOpcDA7tHoolpyqMBcKyf9VAoGBAKvL\nUEbCpZaHtm0aZlwb/1J9ae+Y76RQN/T9dTbe826k8Kik5uDKmnIrDq/B1C4DFrtJ\nMZ45eG9saNtmWCvVOVXeN+3cOYan3d4FaTnQgrY85JAntVdw1e/1b/T87ecc7WHi\nuV0Q6Gb1KkwFwOBZqBYg8rKMiVzbDJtsChTUM9Y7AoGBALZ0Td7Lh/rfksFMC5OU\n+OoIuswl28uFjTU0W0oiyT1Uvyk4U7+v5niB6pBPnh8vOvbXndXHLDO9T6ikRfDc\nUaLBaPVEuCvEmJSVzMnSSQKn//IdUsDkopEteEEuy6JM8rEgTFfuhOlmJBY3jJS9\nRIVmB1CkS71r9vseDrMCGGMu\n-----END PRIVATE KEY-----\n',
    'client_email': 'timbreo2023@contador-903c2.iam.gserviceaccount.com',
    'client_id': '101793703449411234713',
    'auth_uri': 'https://accounts.google.com/o/oauth2/auth',
    'token_uri': 'https://oauth2.googleapis.com/token',
    'auth_provider_x509_cert_url': 'https://www.googleapis.com/oauth2/v1/certs',
    'client_x509_cert_url':
        'https://www.googleapis.com/robot/v1/metadata/x509/timbreo2023%40contador-903c2.iam.gserviceaccount.com',
    'universe_domain': 'googleapis.com'
  };

  static final _sheetsId = "13S-NY61Rj8iVfRwjqq4x0qx_xXiDfVgu1PBQ6Re7fQo";

  static final gsheets = GSheets(_credencial);
  static Spreadsheet? libro;

  static Worksheet? escuelas;
  static Worksheet? votantes;
  static Worksheet? mesas;
  static int proximaMesa = 0;
  static Worksheet? favoritos;
  static int proximoFavorito = 0;
  static bool cargado = false;

  static Future init() async {
    if (cargado) return;
    libro ??= await gsheets.spreadsheet(_sheetsId);
    escuelas ??= libro!.worksheetByTitle("escuelas");
    votantes ??= libro!.worksheetByTitle("votantes");
    favoritos ??= libro!.worksheetByTitle("favoritos");
    mesas ??= libro!.worksheetByTitle("mesas");
    cargado = true;
  }

  static Future<List<Escuela>> traerEscuelas() async {
    await init();
    final lineas = await escuelas!.values.allRows();
    final campos = lineas.first;
    return lineas.skip(1).map((valores) => Escuela.fromMap(Map.fromIterables(campos, valores))).toList();
  }

  // static Future<List<Votante>> traerVotantes() async {
  //   await init();
  //   final lineas = await votantes!.values.allRows();
  //   final campos = lineas.first;
  //   return lineas.skip(1).map((valores) => Votante.fromMap(Map.fromIterables(campos, valores))).toList();
  // }

  static Future<Map<int, bool>> traerMesas([int documento = 0]) async {
    await init();
    var lineas = await mesas!.values.allRows();
    proximaMesa = lineas.length + 1;

    lineas = lineas.skip(1).toList();
    if (documento > 0) {
      final dni = documento.toString();
      lineas = lineas.where((element) => element[1] == dni).toList();
    }

    final salida = <int, bool>{};
    lineas.forEach((m) => salida[int.parse(m[0])] = m[2].toLowerCase() == "cerrar");
    return salida;
  }

  static Future<Map<int, bool>> traerFavoritos([int documento = 0]) async {
    await init();
    var lineas = await favoritos!.values.allRows();
    proximoFavorito = lineas.length + 1;
    // print('traerFavoritos($documento): Hay ${lineas.length} lineas:');
    // // print(lineas.map((e) => e.length).toList());
    // print("-----");
    // print(" ejemplo de linea: ${lineas[0]} ${lineas[0].map((x) => x.runtimeType)}");
    // print(" ejemplo de linea: ${lineas[3]} ${lineas[3].map((x) => x.runtimeType)}");
    // print(" ejemplo de linea: ${lineas[5]} ${lineas[5].map((x) => x.runtimeType)}");
    lineas = lineas.skip(1).toList();
    final salida = <int, bool>{};
    // var n = 1;
    for (final l in lineas) {
      if (l.isEmpty) continue;
      // print(' ${n++}) l: $l > ${l.length}');
      // print(' - ${l[0]} - ${l[2]} - ${l[2].toLowerCase() == "s"}');
      final dni = int.parse(l[0]);
      final ref = int.parse(l[1]);
      // print(' - $dni - ${l[2]} - ${l[2].toLowerCase() == "s"}');
      if (documento == 0 || ref == documento) {
        salida[dni] = l[2].toLowerCase() == "s";
      }
    }

    return salida;
  }

  static Future<void> marcarFavorito(Votante votante, int referente) async {
    final fila = [votante.dni, referente, votante.favorito ? "S" : "N", votante.nombre, votante.mesa, horaActual()];

    await init();
    // await favoritos!.values.insertRow(proximoFavorito++, fila);
    await favoritos!.values.appendRow(fila);
  }

  static Future<void> marcarMesa(Mesa mesa, int referente) async {
    final fila = [mesa.numero, referente, mesa.cerrada ? "cerrar" : "abrir", horaActual()];

    await init();
    // mesas!.values.insertRow(proximaMesa++, fila);
    mesas!.values.appendRow(fila);
  }
}
