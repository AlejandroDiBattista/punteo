import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/modelos/escuela.dart';
import '../modelos/entrega.dart';
import '../modelos/votante.dart';
import 'usuario_card.dart';

class VotanteItem extends StatefulWidget {
  final Votante votante;
  final Color color;
  final int index;
  final void Function(Votante)? alMarcar;
  final void Function(Votante v, EstadoEntrega entrega)? alResponder;

  const VotanteItem({
    Key? key,
    required this.votante,
    required this.color,
    required this.index,
    this.alMarcar,
    this.alResponder,
  }) : super(key: key);

  @override
  State<VotanteItem> createState() => _VotanteItemState();
}

class _VotanteItemState extends State<VotanteItem> {
  @override
  Widget build(BuildContext context) {
    final votante = widget.votante;
    final escuela = Escuela.traer(votante.mesa);
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
              Text('Edad: $edad | DNI: ${votante.dni}'),
              SizedBox(height: 4),
              Text('${escuela.escuela}',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue)),
              // Text('${escuela.direccion}', style: TextStyle(fontSize: 12)),
              Text('Mesa: ${votante.mesa} | Orden: ${votante.orden}',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal, color: Colors.blue)),
            ],
          ),
        ],
      ),
      trailing: Icon(Icons.star, color: switch (r) { 0 => Colors.grey, 1 => Colors.amber, _ => Colors.red }),

      onTap: () => widget.alMarcar == null ? mostrarVotante(votante) : widget.alMarcar!(votante),
      onLongPress: () => mostrarVotante(votante),
      // onTap: () => mostrarVotante(votante),
    );
  }

  Widget crearNombre(Votante votante, Color color, int indice) {
    final estilo = TextStyle(fontSize: 10, fontWeight: FontWeight.w200, color: color);
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(width: 20, child: Text('${indice + 1}', style: estilo)),
        Text(votante.nombre, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
      ],
    );
  }

  void retornar(Votante v, EstadoEntrega entrega) {
    widget.alResponder!(v, entrega);
    Get.back();
  }

  void mostrarVotante(Votante votante) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.all(16),
          actionsPadding: EdgeInsets.only(bottom: 16, right: 16),
          content: SizedBox(
              width: 380,
              child: UsuarioCard(
                votante,
                compacto: false,
                referidos: true,
                escuela: true,
              )),
          actions: widget.alResponder == null
              ? [ElevatedButton(child: Text('Cerrar'), onPressed: () => Get.back())]
              : [
                  ElevatedButton(child: Text('Entregado'), onPressed: () => retornar(votante, EstadoEntrega.entregado)),
                  ElevatedButton(
                      child: Text('No encontrado'), onPressed: () => retornar(votante, EstadoEntrega.desistir)),
                  // ElevatedButton(child: Text('Cancelar'), onPressed: () => retornar(votante, EstadoEntrega.pendiente)),
                  ElevatedButton(child: Text('Cancelar'), onPressed: () => Get.back()),
                ],
        );
      },
    );
  }
}
