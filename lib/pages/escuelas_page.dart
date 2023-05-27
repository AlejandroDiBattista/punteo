import 'package:flutter/material.dart';

import '../colores.dart';
import '../modelos/datos.dart';
import '../modelos/escuela.dart';
import 'mesas_page.dart';

class EscuelasPage extends StatefulWidget {
  @override
  State<EscuelasPage> createState() => _EscuelasPageState();
}

class _EscuelasPageState extends State<EscuelasPage> {
  @override
  Widget build(BuildContext context) {
    final datos = Datos.escuelas;
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(title: Text('Escuelas de Yerba Buena')),
          body: Center(
              child: Scrollbar(
            child: ListView.separated(
              itemCount: datos.length,
              itemBuilder: (BuildContext context, int index) => crearEscuela(index, datos[index]),
              separatorBuilder: (BuildContext context, int index) => Divider(color: Colores.divisor, height: 1),
            ),
          ))),
    );
  }

  Widget crearEscuela(int indice, Escuela escuela) {
    final color = escuela.esCompleta ? Colors.green : (escuela.esAnalizada ? Colors.blue : Colors.black);
    return ListTile(
      tileColor: escuela == Datos.escuelaActual ? Theme.of(context).primaryColor.withAlpha(20) : Colors.white,
      title: Row(
        children: [
          Container(
            width: 20,
            child: Text('${indice + 1}', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w200, color: color)),
          ),
          Text(escuela.escuela, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
          Spacer(),
          // Text(escuela.esCompleta ? "(completa)" : "", style: TextStyle(fontSize: 12)),
          if (escuela == Datos.escuelaActual && !escuela.esCompleta)
            Text(
              "Votas acá",
              style: TextStyle(fontSize: 12, color: Colors.green),
            )
        ],
      ),
      subtitle: Row(
        children: [
          SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(escuela.direccion, style: TextStyle(fontSize: 16, color: Colors.black)),
              Text(
                  '${escuela.mesas.length} mesas (${escuela.cantidadMesasAnalizadas} + ${escuela.cantidadMesasCerradas}) | ${escuela.desde} a ${escuela.hasta} '),
              Text('${escuela.totalVotantes} votantes | ${escuela.totalVotantesFavoritos} favoritos')
            ],
          ),
        ],
      ),
      trailing: Icon(Icons.check, color: escuela.esCompleta ? Colors.green : Colors.transparent, size: 20),
      onTap: () => irMesa(context, escuela),
    );
  }

  Future<void> irMesa(BuildContext context, Escuela escuela) async {
    print('irMesa: ${escuela.escuela}');
    escuela.ordenar();
    await Navigator.push(context, MaterialPageRoute(builder: (context) => MesasPage(escuela: escuela)));
    setState(() {});
  }
}
