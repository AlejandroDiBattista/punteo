// import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:punteo_yb/pages/votantes_item.dart';

import '/modelos/votante.dart';
import '../modelos/datos.dart';
import '../modelos/mesa.dart';

class VotantesPage extends StatefulWidget {
  final Mesa mesa;

  VotantesPage({required this.mesa});

  @override
  State<VotantesPage> createState() => _VotantesPageState();
}

class _VotantesPageState extends State<VotantesPage> {
  Future<void> marcarFavorito(Votante votante) async {
    votante.cambiarFavorito();
    setState(() {});
    Datos.marcarFavorito(votante);
  }

  void borrarMarcasFavoritos() {
    Datos.borrarFavoritos(mesa);
    setState(() {});
  }

  void cerrarMesa() {
    mesa.cerrada = true;
    Datos.marcarMesa(mesa);
    print('Cerrando mesa ${mesa.numero} > cerrada: ${mesa.cerrada ? 'SI' : 'NO'}');
    setState(() {});
  }

  get escuela => Datos.traerEscuela(mesa.numero);
  get mesa => widget.mesa;
  get votantes => mesa.votantes;
  get favoritos => mesa.favoritos;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Mesa ${widget.mesa.numero} ', style: TextStyle(fontSize: 22)),
          Text('${votantes.length} votantes, ${favoritos.length} favoritos',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w100)),
        ],
      )),
      body: Center(
        child: Scrollbar(
          child: ListView.separated(
            itemCount: votantes.length + 1,
            itemBuilder: (BuildContext context, int index) {
              if (index < votantes.length) {
                final Votante votante = votantes[index];
                final color = votante.favorito ? Theme.of(context).primaryColor : Colors.black;
                return VotanteItem(votante: votante, color: color, index: index, alMarcar: marcarFavorito);
              } else {
                return Container(
                  height: 60,
                  child: Center(child: crearCerrar(context)),
                );
              }
            },
            separatorBuilder: (BuildContext context, int index) => divisor(index),
          ),
        ),
      ),
      // floatingActionButton: mesa.cerrada ? null : crearCerrar(context),
    );
  }

  Widget divisor(int index) {
    if (index < votantes.length - 1) {
      final siguiente = votantes[index + 1];
      if (!siguiente.agrupar) return Divider(thickness: 2);
    }
    return Divider();
  }

  FloatingActionButton crearCerrar(BuildContext context) => FloatingActionButton.extended(
        icon: Icon(CupertinoIcons.check_mark),
        label: Text('Marcar mesa como completa'),
        onPressed: () {
          cerrarMesa();
          Navigator.pop(context);
        },
      );
}
