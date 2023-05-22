// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Progreso extends StatelessWidget {
  final bool cargando;
  Progreso(this.cargando);

  @override
  Widget build(BuildContext context) =>
      this.cargando ? LinearProgressIndicator(backgroundColor: Colors.transparent, minHeight: 1) : SizedBox(height: 1);
}
