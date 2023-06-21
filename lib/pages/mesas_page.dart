import 'package:flutter/material.dart';

import '/pages/votantes_page.dart';
import '../colores.dart';
import '../modelos/datos.dart';
import '../modelos/escuela.dart';
import '../modelos/mesa.dart';
import '../utils.dart';
// import '../modelos/votante.dart';

class MesasPage extends StatefulWidget {
  final Escuela escuela;

  MesasPage({required this.escuela});

  @override
  State<MesasPage> createState() => _MesasPageState();
}

class _MesasPageState extends State<MesasPage> {
  @override
  Widget build(BuildContext context) {
    var mesas = this.widget.escuela.mesas;
    mesas.sort();
    return SafeArea(
      child: Scaffold(
        appBar: crearTitulo(Text(widget.escuela.escuela)),
        body: Scrollbar(
          child: ListView.separated(
            itemCount: mesas.length,
            itemBuilder: crearMesa,
            separatorBuilder: (BuildContext context, int index) => Divider(color: Colores.divisor, height: 1),
          ),
        ),
      ),
    );
  }

  Widget crearMesa(BuildContext context, int index) {
    final mesa = this.widget.escuela.mesas[index];
    final colorActual =
        mesa.numero == Datos.usuarioActual.mesa ? Theme.of(context).primaryColor.withAlpha(20) : Colors.white;
    final colorEstado = mesa.esCerrada ? Colors.green : (mesa.esAnalizada ? Colors.blue : Colors.transparent);
    return ListTile(
        tileColor: colorActual,
        title: crearDesdeHasta(mesa, index),
        subtitle: crearRangoVotantes(mesa),
        onTap: () => irVotantes(mesa),
        onLongPress: () => cambiarEstadoMesa(mesa),
        trailing: Icon(Icons.check, color: colorEstado));
  }

  Widget crearDesdeHasta(Mesa mesa, int indice) {
    final color = mesa.esCerrada ? Colors.green : (mesa.esAnalizada ? Colors.red : Colors.black);
    return Row(
      children: [
        Container(
          width: 20,
          child: Text('${indice + 1}', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w200, color: color)),
        ),
        Text('Mesa ${mesa.numero}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
        Expanded(child: Container()),
        crearCantidadVotantes(mesa)
      ],
    );
  }

  Widget crearRangoVotantes(Mesa mesa) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(height: 5),
          crearNombre("desde: ", mesa.votantes.first.nombre),
          crearNombre("hasta: ", mesa.votantes.last.nombre),
          SizedBox(
            height: 4,
          ),
          crearResultados(mesa)
        ],
      );

  Widget crearCantidadVotantes(Mesa mesa) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(' ${mesa.votantes.length} votantes', style: TextStyle(fontSize: 12)),
        Text(mesa.favoritos.length.info('favorito'),
            style: TextStyle(fontSize: 12, color: Theme.of(context).primaryColor)),
        if (mesa.numero == Datos.usuarioActual.mesa)
          Text('Votas acá', style: TextStyle(fontSize: 12, color: Theme.of(context).primaryColor)),
      ]);

  Widget crearNombre(String etiqueta, String nombre) => Row(children: [
        SizedBox(width: 20),
        Container(child: Text(etiqueta, style: TextStyle(fontSize: 12)), width: 40),
        Text(nombre, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold))
      ]);

  void irVotantes(Mesa mesa) async {
    return;
    // print('irVotantes: ${mesa.numero}');
    // // Datos.marcarMesa(mesa, "entrar");
    // await Navigator.push(context, MaterialPageRoute(builder: (context) => VotantesPage(mesa: mesa)));
    // // Datos.marcarMesa(mesa, "salir");
    // setState(() {});
  }

  void cambiarEstadoMesa(Mesa mesa) async {
    mesa.esCerrada = !mesa.esCerrada;
    Datos.marcarMesa(mesa);
    setState(() {});
  }

  Widget crearResultados(Mesa mesa) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            resultado("votos", mesa.votos),
            resultado("entregado", mesa.entregas),
            resultado("votaron", mesa.votaron),
            resultado("%", mesa.participacion.truncate(), true)
          ],
        ),
      );


}
