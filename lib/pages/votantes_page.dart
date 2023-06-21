import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/colores.dart';
import '/modelos/datos.dart';
import '/modelos/escuela.dart';
import '/modelos/mesa.dart';
import '/utils.dart';
import '/widgets/votantes_item.dart';
import '../modelos/votante.dart';

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

  void cambiarEstadoMesa() {
    mesa.esCerrada = !mesa.esCerrada;
    Datos.marcarMesa(mesa);
    if (mesa.esCerrada) Get.back();
    setState(() {});
  }

  Escuela get escuela => Escuela.traer(mesa.numero);
  Mesa get mesa => widget.mesa;
  Votantes get votantes => mesa.esCerrada ? mesa.favoritos : mesa.votantes;
  Votantes get favoritos => mesa.favoritos;

  @override
  Widget build(BuildContext context) {
    final estilo = TextStyle(fontSize: 16, fontWeight: FontWeight.w100, color: Theme.of(context).primaryColor);
    final n = favoritos.length;
    return SafeArea(
      child: Scaffold(
        appBar: crearTitulo(
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Text('${mesa.escuela.escuela} ', style: TextStyle(fontSize: 14)),
                  Text('Mesa ${mesa.numero} '),
                ],
              ),
              Column(
                children: [
                  Text('${mesa.votantes.length} votantes', style: estilo),
                  Text(n.info('favorito'), style: estilo.copyWith(fontSize: 20)),
                ],
              )
            ],
          ),
          actions: [
            IconButton(onPressed: () => cambiarEstadoMesa(), icon: Icon(mesa.esCerrada ? Icons.edit : Icons.check))
          ],
        ),
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
              // separatorBuilder: (BuildContext context, int index) => divisor(index),
              separatorBuilder: (BuildContext context, int index) => Divider(color: Colores.divisor, height: 1),
            ),
          ),
        ),
        // floatingActionButton: mesa.cerrada ? null : crearCerrar(context),
      ),
    );
  }

  Widget crearCerrar(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: FloatingActionButton.extended(
          icon: Icon((mesa.esCerrada ? Icons.edit : Icons.check)),
          label: Text(mesa.esCerrada ? 'Abrir mesa' : 'Cerrar mesa'),
          onPressed: () {
            cambiarEstadoMesa();
            // if (mesa.esCerrada) Get.back();
          },
        ),
      );
}
