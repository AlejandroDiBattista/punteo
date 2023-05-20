// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// import '../modelos/datos.dart';
import '../modelos/datos.dart';
import '../modelos/votante.dart';

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
    return ListTile(
      dense: false,
      title: crearNombre(votante, widget.color, widget.index),
      subtitle: Row(
        children: [
          SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 8),
              Text(votante.domicilio, style: TextStyle(fontSize: 16, color: Colors.black, overflow: TextOverflow.clip)),
              SizedBox(height: 4),
              Text('Edad: $edad  |  DNI: ${votante.dni}'),
              SizedBox(height: 4),
              Text('${Datos.traerEscuela(votante.mesa).escuela}  |  Mesa: ${votante.mesa} #${votante.orden}',
                  style: TextStyle(fontSize: 12)),
            ],
          ),
        ],
      ),
      trailing: Icon(Icons.star, color: votante.favorito ? Colors.amber : Colors.grey),
      onTap: () => widget.alMarcar(votante),
    );
  }

  Widget crearNombre(Votante votante, Color color, int indice) {
    var apellido = votante.nombre;
    var nombre = '';

    if (apellido.contains(',')) {
      var partes = apellido.split(', ');
      apellido = partes[0];
      nombre = partes[1];
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          width: 20,
          child: Text('${indice + 1}', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w100, color: color)),
        ),
        Text(apellido,
            style: TextStyle(
                fontSize: 18, fontWeight: votante.agrupar ? FontWeight.normal : FontWeight.bold, color: color)),
        if (nombre.isNotEmpty)
          Text(', $nombre',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontStyle: votante.agrupar ? FontStyle.italic : FontStyle.normal,
                  color: color)),
      ],
    );
  }
}
