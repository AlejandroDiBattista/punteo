import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Indicador extends StatefulWidget {
  String etiqueta;
  double valor;

  Indicador({
    Key? key,
    required this.etiqueta,
    required this.valor,
  }) : super(key: key);

  @override
  State<Indicador> createState() => _IndicadorState();
}

class _IndicadorState extends State<Indicador> {
  @override
  Widget build(BuildContext context) {
    final texto =
        (0 < widget.valor && widget.valor < 1) ? '${(widget.valor * 1000).toInt() / 10}%' : '${widget.valor.toInt()}';
    return Container(
      width: 100,
      child: AspectRatio(
        aspectRatio: 1,
        child: Card(
          color: Colors.white,
          elevation: 10,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(texto, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                Text(widget.etiqueta, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300)),
              ]),
        ),
      ),
    );
  }
}
