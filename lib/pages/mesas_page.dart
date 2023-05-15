import 'package:flutter/material.dart';
import 'package:myapp/pages/votantes_page.dart';
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
    return Scaffold(
      appBar: AppBar(title: Text(widget.escuela.escuela, style: TextStyle(fontSize: 20))),
      body: ListView.separated(
        itemCount: mesas.length,
        itemBuilder: crearMesa,
        separatorBuilder: (BuildContext context, int index) => Divider(),
      ),
    );
  }

  Widget crearMesa(BuildContext context, int index) {
    final mesa = this.widget.escuela.mesas[index];
    final votantes = mesa.votantes;

    return ListTile(
        title: crearDesdeHasta(mesa),
        subtitle: crearRangoVotantes(mesa),
        onTap: () => irVotantes(mesa),
        trailing: Icon(Icons.check_sharp, color: mesa.cerrada ? Colors.amber : Colors.grey));
  }

  Widget crearDesdeHasta(Mesa mesa) {
    final color = mesa.cerrada ? Colors.green : Colors.black;
    return Row(
      children: [
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
          crearNombre("de: ", mesa.votantes.first.nombre),
          crearNombre("a : ", mesa.votantes.last.nombre),
        ],
      );

  Widget crearCantidadVotantes(Mesa mesa) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(' ${mesa.votantes.length} votantes', style: TextStyle(fontSize: 12)),
        Text(' ${mesa.favoritos.length} favoritos', style: TextStyle(fontSize: 12)),
      ]);

  Widget crearNombre(String etiqueta, String nombre) => Row(children: [
        SizedBox(height: 10),
        Text(etiqueta, style: TextStyle(fontSize: 10)),
        Text(nombre, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold))
      ]);

  void irVotantes(Mesa mesa) async {
    print('irVotantes: ${mesa.numero}');
    // Datos.marcarMesa(mesa, "entrar");
    await Navigator.push(context, MaterialPageRoute(builder: (context) => VotantesPage(mesa: mesa)));
    // Datos.marcarMesa(mesa, "salir");
    setState(() {});
  }
}
