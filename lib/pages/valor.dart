import 'package:flutter/material.dart';

class Valor extends StatelessWidget {
  const Valor({
    Key? key,
    required this.valor,
    this.edicion = false,
  }) : super(key: key);

  final int valor;
  final bool edicion;

  @override
  Widget build(BuildContext context) {
    return Container(
      // decoration: BoxDecoration(color: edicion ? Colors.grey : Colors.white),
      padding: EdgeInsets.symmetric(horizontal: 10),
      width: 80,
      height: 35,
      child: Text(valor.toString(),
          textAlign: TextAlign.right,
          style: TextStyle(
              fontSize: 28,
              fontWeight: edicion ? FontWeight.w600 : FontWeight.w200,
              color: edicion ? Colors.blue : Colors.black)),
    );
  }
}
