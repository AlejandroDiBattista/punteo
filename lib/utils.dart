import 'package:intl/intl.dart';

extension DateTimeUtils on DateTime {
  String get fecha => DateFormat('dd/MM/yyyy').format(this);
  String get hora => DateFormat('HH:mm:ss').format(this);
  String get fechaHora => DateFormat('dd/MM/yyyy HH:mm:ss').format(this);
}

extension Utiles on String {
  String get sinEspacios => this.trim().replaceAll(RegExp('\\s+'), ' ');
  String get sinAcentos => this
      .replaceAll('á', 'a')
      .replaceAll('é', 'e')
      .replaceAll('í', 'i')
      .replaceAll('ó', 'o')
      .replaceAll('ú', 'u')
      .replaceAll('Á', 'A')
      .replaceAll('É', 'E')
      .replaceAll('Í', 'I')
      .replaceAll('Ó', 'O')
      .replaceAll('Ú', 'U');

  List<String> get palabras => this.sinEspacios.split(' ').map((p) => p.sinAcentos).toList();
  bool contienePalabras(List<String> palabras) => palabras.every((palabra) => this.contains(palabra));
}

void medir(String mensaje, Function ejecutar) {
  final reloj = Stopwatch()..start();
  print('> $mensaje');
  ejecutar();
  reloj.stop();
  print("- (${reloj.elapsedMilliseconds}ms)");
}
