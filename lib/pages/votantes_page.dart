// import 'dart:async';
import 'package:flutter/material.dart';
import 'package:myapp/modelos/votante.dart';
// import '../votantes_widtget.dart';
import '../modelos/escuela.dart';

import '../sheets_api.dart';

class VotantesPage extends StatefulWidget {
  final Escuela escuela;

  VotantesPage({required this.escuela});

  @override
  State<VotantesPage> createState() => _VotantesPageState();
}

class _VotantesPageState extends State<VotantesPage> {
  void marcarFavorito(Votante votante) {
    votante.cambiarFavorito();
    SheetsApi.marcarFavorito(votante, 1111, votante.favorito ? "S" : "N");
    setState(() {});
    // Navigator.push(context, MaterialPageRoute(builder: (context) => VotantesPage(votante: votante)));
  }

  @override
  Widget build(BuildContext context) {
    print("VotantesPage.build()");
    final mesa = this.widget.escuela.mesas.first;
    final votantes = mesa.votantes;
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            // Icon(Icons.person),
            // SizedBox(width: 8.0),
            Column(
              children: [
                Text(
                  widget.escuela.escuela,
                  style: TextStyle(fontSize: 20),
                ),
                Text(
                  'Mesa ${mesa.numero} - ${votantes.length} votantes',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            )
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            tooltip: 'Borrar la marca de todos',
            onPressed: () {
              // for (var votante in votantes) {
              //   votante.clasificacion = 1;
              // }
            },
          ),
        ],
      ),
      body: Center(
        child: ListView.builder(
          itemCount: votantes.length,
          itemBuilder: (BuildContext context, int index) {
            final Votante votante = votantes[index];
            return ListTile(
              title: Text(
                votante.nombre,
                style: TextStyle(fontSize: 20),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(votante.domicilio),
                  Text('DNI: ${votante.dni} | Mesa: ${mesa.numero}, Orden ${votante.orden}'),
                ],
              ),
              trailing: votante.favorito ? Icon(Icons.check_box) : Icon(Icons.check_box_outline_blank),
              onTap: () => marcarFavorito(votante),
            );
          },
        ),
      ),
    );
  }
}
