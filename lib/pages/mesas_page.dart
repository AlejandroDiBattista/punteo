import 'package:flutter/material.dart';
import '../colores.dart';
import '/pages/votantes_page.dart';
import '../modelos/datos.dart';
import '../modelos/escuela.dart';
import '../modelos/mesa.dart';
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
    final mesas = this.widget.escuela.mesas;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text(widget.escuela.escuela)),
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

    return ListTile(
        tileColor: mesa.numero == Datos.usuarioActual.mesa ? Theme.of(context).primaryColorLight : Colors.white,
        title: crearDesdeHasta(index, mesa),
        subtitle: crearRangoVotantes(mesa),
        onTap: () => irVotantes(mesa),
        trailing: Icon(Icons.check, color: mesa.cerrada ? Colors.amber : Colors.grey));
  }

  Widget crearDesdeHasta(int indice, Mesa mesa) {
    final color = mesa.cerrada ? Theme.of(context).primaryColorLight : Colors.black;
    return Row(
      children: [
        Container(
          width: 20,
          child: Text('${indice + 1}', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w100, color: color)),
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
          SizedBox(height: 10),
          crearNombre("desde: ", mesa.votantes.first.nombre),
          crearNombre("hasta: ", mesa.votantes.last.nombre),
        ],
      );

  Widget crearCantidadVotantes(Mesa mesa) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(' ${mesa.votantes.length} votantes', style: TextStyle(fontSize: 12)),
        if (mesa.favoritos.length > 0)
          Text(' ${mesa.favoritos.length} favoritos',
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
    print('irVotantes: ${mesa.numero}');
    // Datos.marcarMesa(mesa, "entrar");
    await Navigator.push(context, MaterialPageRoute(builder: (context) => VotantesPage(mesa: mesa)));
    // Datos.marcarMesa(mesa, "salir");
    setState(() {});
  }
}
