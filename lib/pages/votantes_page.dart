// import 'dart:async';
import 'package:flutter/material.dart';
import 'package:myapp/modelos/votante.dart';
import 'package:myapp/pages/action_button.dart';
import 'package:scroll_to_index/util.dart';

import '../modelos/datos.dart';
import '../modelos/mesa.dart';
import '../sheets_api.dart';

class VotantesPage extends StatefulWidget {
  final Mesa mesa;

  VotantesPage({required this.mesa});

  @override
  State<VotantesPage> createState() => _VotantesPageState();
}

class _VotantesPageState extends State<VotantesPage> {
  Future<void> marcarFavorito(Votante votante) async {
    votante.cambiarFavorito();
    await Datos.marcarFavorito(votante);
    setState(() {});
  }

  void borrarMarcasFavoritos() {
    Datos.borrarFavoritos(widget.mesa);
    setState(() {});
  }

  void cambiarEstadoMesa() {
    widget.mesa.cerrada = !widget.mesa.cerrada;
    Datos.marcarMesa(widget.mesa);
    print("Cerrando mesa ${widget.mesa.numero} > cerrada: ${widget.mesa.cerrada ? "SI" : "NO"}");
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final mesa = this.widget.mesa;
    final votantes = mesa.votantes;
    // votantes.sort((a, b) => a.nombre.compareTo(b.nombre));
    return Scaffold(
      appBar: AppBar(
          title: Text('Mesa ${widget.mesa.numero} | ${votantes.length} votantes', style: TextStyle(fontSize: 22))),
      body: Center(
        child: ListView.separated(
          itemCount: votantes.length,
          itemBuilder: (BuildContext context, int index) {
            final Votante votante = votantes[index];
            return ListTile(
              title: Text(votante.nombre, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(votante.domicilio),
                  Text('DNI: ${votante.dni} | Mesa: ${mesa.numero}, #${votante.orden}'),
                ],
              ),
              trailing: votante.favorito ? Icon(Icons.star, color: Colors.amber) : Icon(Icons.star_border),
              onTap: () => marcarFavorito(votante),
            );
          },
          separatorBuilder: (BuildContext context, int index) => Divider(),
        ),
      ),
      floatingActionButton: crearCerrar(context),
    );
  }

  FloatingActionButton crearCerrar(BuildContext context) => FloatingActionButton.extended(
        onPressed: () {
          cambiarEstadoMesa();
          Navigator.pop(context);
        },
        label: Text(widget.mesa.cerrada ? "Abrir Mesa" : "Cerrar Mesa"),
        icon: Icon(Icons.close),
      );
}
