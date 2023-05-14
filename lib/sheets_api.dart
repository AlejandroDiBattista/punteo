import 'package:gsheets/gsheets.dart';
import 'modelos/votante.dart';
import 'modelos/escuela.dart';

typedef Json = Map<String, dynamic>;

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
  static Worksheet? votantes;
  static Worksheet? escuelas;
  static Worksheet? favoritos;

  static Future init() async {
    libro ??= await gsheets.spreadsheet(_sheetsId);
    escuelas ??= libro!.worksheetByTitle("escuelas");
    votantes ??= libro!.worksheetByTitle("votantes");
    favoritos ??= libro!.worksheetByTitle("favoritos");
  }

  static Future<List<Escuela>> traerEscuelas() async {
    await init();

    final lineas = await escuelas!.values.allRows();

    final campos = lineas.first.where((x) => !x.contains("*")).toList();
    final List<Escuela> salida =
        lineas.skip(1).map((valores) => Escuela.fromMap(Map.fromIterables(campos, valores))).toList();
    return salida;
  }

  // static Future<List<Votante>> traerVotantesEscuela(Escuela escuela) async {
  //   await init();

  //   final lineas = await votantes!.values.allRows(fromRow: escuela.inicio, length: escuela.votantes );
  //   final favoritos = await traerFavoritos();

  //   final campos = lineas.first.where((x) => !x.contains("*")).toList();
  //   return lineas.skip(1).map((valores) {
  //     final data = Map.fromIterables(campos, valores);
  //     data['favorito'] = favoritos[data['dni']] ?? " ";
  //     return Votante.fromMap(data);
  //   }).toList();
  // }

  static Future<List<Votante>> traerVotantes() async {
    await init();

    final lineas = await votantes!.values.allRows();
    final favoritos = await traerFavoritos();

    final campos = lineas.first.where((x) => !x.contains("*")).toList();
    return lineas.skip(1).map((valores) {
      final data = Map.fromIterables(campos, valores);
      data['favorito'] = favoritos[data['dni']] ?? " ";
      return Votante.fromMap(data);
    }).toList();
  }

  static Future<Map<String, String>> traerFavoritos() async {
    await init();
    final lineas = await favoritos!.values.allRows();
    final salida = <String, String>{};
    lineas.skip(1).forEach((element) => salida[element[0]] = element[2]);
    return salida;
  }

  static Future<void> marcarFavorito(Votante votante, int referente, String favorito) async {
    await init();
    favoritos!.values.appendRow([votante.dni, referente, favorito]);
  }
}

// class Posiciones {
//   static late Position position;
//   static late LatLng location;
//   static List<LatLng> callLocations = [];

//   get locations => callLocations;

//   static Future registrarPosicion() async {
//     final position = await Geolocator.getCurrentPosition();
//     final location = LatLng(position.latitude, position.longitude);
//     callLocations.add(location);
//   }

//   static Future<void> registrar(double latitude, double longitude, int duracion) async {
//     print("Registrando >> Lat: $latitude, Log: $longitude Duracion: $duracion");

//     Map<String, dynamic> dato = {};

//     dato['hora'] = DateTime.now().toString();
//     dato['latitude'] = latitude;
//     dato['longitude'] = longitude;
//     dato['duracion'] = duracion;

//     // datos.values.map .insertRow(entradas.length + 1, dato);
//   }
// }
