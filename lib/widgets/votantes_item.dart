// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '/modelos/escuela.dart';
import '/modelos/votante.dart';

class VotanteItem extends StatefulWidget {
  final Votante votante;
  final Color color;
  final int index;
  final void Function(Votante) alMarcar;

  const VotanteItem({
    Key? key,
    required this.votante,
    required this.color,
    required this.index,
    required this.alMarcar,
  }) : super(key: key);

  @override
  State<VotanteItem> createState() => _VotanteItemState();
}

class _VotanteItemState extends State<VotanteItem> {
  @override
  Widget build(BuildContext context) {
    final votante = widget.votante;
    final edad = (votante.clase < 0 ? "~" : "") + '${2023 - votante.clase.abs()}';
    final r = votante.referentes.length;
    return ListTile(
      tileColor: Colors.white,
      dense: false,
      title: crearNombre(votante, widget.color, widget.index),
      // title: Text(votante.nombre, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: widget.color)),
      subtitle: Row(
        children: [
          SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 4),
              Row(
                children: [
                  Text(votante.domicilio, style: TextStyle(fontSize: 16)),
                  if (votante.longitude != 0) Icon(Icons.location_on, color: Colors.red, size: 14),
                ],
              ),
              SizedBox(height: 4),
              Text('Edad: $edad  |  DNI: ${votante.dni}'),
              SizedBox(height: 4),
              Text(
                  '${Escuela.traer(votante.mesa).escuela} | Mesa: ${votante.mesa} #${votante.orden} ${r > 1 ? 'x $r' : ''}',
                  style: TextStyle(fontSize: 12)),
            ],
          ),
        ],
      ),
      trailing: Icon(Icons.star, color: votante.favorito ? (r > 1 ? Colors.red : Colors.amber) : Colors.grey),
      onTap: () => widget.alMarcar(votante),
    );
  }

  Widget crearNombre(Votante votante, Color color, int indice) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          width: 20,
          child: Text('${indice + 1}', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w200, color: color)),
        ),
        FittedBox(
            child: Text(votante.nombre, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color))),
      ],
    );
  }
}
