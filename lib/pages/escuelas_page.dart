import 'package:flutter/material.dart';

import '../colores.dart';
import '../modelos/datos.dart';
import '../modelos/escuela.dart';
import '../utils.dart';
import 'mesas_page.dart';

class EscuelasPage extends StatefulWidget {
  @override
  State<EscuelasPage> createState() => _EscuelasPageState();
}

class _EscuelasPageState extends State<EscuelasPage> {
  @override
  Widget build(BuildContext context) {
    Datos.escuelas.sort();
    final datos = Datos.escuelas;
    return SafeArea(
      child: Scaffold(
          appBar: crearTitulo(Text('Escuelas de Yerba Buena')),
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

  static String calcularEstado(Escuela escuela) {
    final completa = escuela.estado == EstadoEscuela.completa;
    final analizadas = escuela.cantidadMesasAnalizadas;
    final cerradas = escuela.cantidadMesasCerradas;
    final estado = (completa ? 'Todas cerradas' : '${cerradas.info('cerrada')} ${analizadas.info('pendiente')}').trim();
    return estado.length > 0 ? '| ($estado) ' : '';
  }

  Widget crearEscuela(int indice, Escuela e) {
    final color = e.estado.color;
    final estado = calcularEstado(e);
    final favoritos = e.totalVotantesFavoritos;

    return ListTile(
      tileColor: e == Datos.escuelaActual ? Theme.of(context).primaryColor.withAlpha(20) : Colors.white,
      title: Row(
        children: [
          Container(
            width: 20,
            child: Text('${indice + 1}', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w200, color: color)),
          ),
          Text(e.escuela, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
          Spacer(),
          if (e == Datos.escuelaActual && e.estado != EstadoEscuela.completa)
            Text(
              'Votas acá',
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
              Text(e.direccion, style: TextStyle(fontSize: 16, color: Colors.black)),
              Text('${e.mesas.length} mesas $estado | ${e.desde} a ${e.hasta} | ${e.prioridad}'),
              Text('${e.totalVotantes} votantes ${favoritos > 0 ? ' | ${favoritos.info('favorito')}' : ''}')
            ],
          ),
        ],
      ),
      trailing:
          Icon(Icons.check, color: e.estado == EstadoEscuela.completa ? Colors.green : Colors.transparent, size: 20),
      onTap: () => irMesa(context, e),
    );
  }

  Future<void> irMesa(BuildContext context, Escuela escuela) async {
    print('irMesa: ${escuela.escuela}');
    escuela.ordenar();
    await Navigator.push(context, MaterialPageRoute(builder: (context) => MesasPage(escuela: escuela)));
    setState(() {});
  }
}
