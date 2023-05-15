// import 'dart:async';
import 'package:flutter/material.dart';
import 'package:myapp/pages/votantes_page.dart';
import '../modelos/datos.dart';
import '../modelos/escuela.dart';
import '../modelos/mesa.dart';

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
      title: Text('Mesa ${mesa.numero}  ${mesa.cerrada ? "   (cerrada)" : ""}',
          style: TextStyle(fontSize: 20, color: mesa.cerrada ? Colors.green : Colors.black)),
      subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('De ${votantes.first.nombre} a ${votantes.last.nombre}', style: TextStyle(fontWeight: FontWeight.bold)),
        Text(' ${votantes.length} votantes | ${mesa.favoritos.length} favoritos', style: TextStyle(fontSize: 12)),
      ]),
      onTap: () => irVotantes(mesa),
    );
  }

  void irVotantes(Mesa mesa) async {
    print('irVotantes: ${mesa.numero}');
    // Datos.marcarMesa(mesa, "entrar");
    await Navigator.push(context, MaterialPageRoute(builder: (context) => VotantesPage(mesa: mesa)));
    // Datos.marcarMesa(mesa, "salir");
    setState(() {});
  }
}
