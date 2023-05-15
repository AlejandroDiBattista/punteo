// import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '/modelos/votante.dart';
// import 'package:myapp/pages/action_button.dart';
// import 'package:scroll_to_index/util.dart';

import '../modelos/datos.dart';
import '../modelos/mesa.dart';
// import '../sheets_api.dart';

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
    Datos.borrarFavoritos(widget.mesa);
    setState(() {});
  }

  void cerrarMesa() {
    widget.mesa.cerrada = true;
    Datos.marcarMesa(widget.mesa);
    print('Cerrando mesa ${widget.mesa.numero} > cerrada: ${widget.mesa.cerrada ? 'SI' : 'NO'}');
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
        child: Scrollbar(
          child: ListView.separated(
            itemCount: votantes.length,
            itemBuilder: (BuildContext context, int index) {
              final Votante votante = votantes[index];
              final color = votante.favorito ? Theme.of(context).primaryColor : Colors.black;
              return ListTile(
                dense: false,
                title: crearNombre(index, votante, color),
                subtitle: Row(
                  children: [
                    SizedBox(width: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 8),
                        Text(votante.domicilio, style: TextStyle(fontSize: 16, color: Colors.black)),
                        SizedBox(height: 4),
                        Text(
                            'DNI: ${votante.dni} ${votante.clase > 0 ? '| Edad: ${2023 - votante.clase} ' : ''}| Mesa: ${mesa.numero}, #${votante.orden}'),
                      ],
                    ),
                  ],
                ),
                trailing: votante.favorito ? Icon(Icons.star, color: Colors.amber) : Icon(Icons.star_border),
                onTap: () => marcarFavorito(votante),
              );
            },
            separatorBuilder: (BuildContext context, int index) => Divider(),
          ),
        ),
      ),
      floatingActionButton: mesa.cerrada ? null : crearCerrar(context),
    );
  }

  Widget crearNombre(int indice, Votante votante, Color color) {
    var apellido = votante.nombre;
    var nombre = '';

    if (apellido.contains(',')) {
      var partes = apellido.split(', ');
      apellido = partes[0];
      nombre = partes[1];
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          width: 20,
          child: Text('${indice + 1}', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w100, color: color)),
        ),
        Text(apellido,
            style: TextStyle(
                fontSize: 18,
                fontWeight: votante.agrupar ? FontWeight.normal : FontWeight.bold,
                fontStyle: votante.agrupar ? FontStyle.italic : FontStyle.normal,
                color: color)),
        if (nombre.isNotEmpty)
          Text(', $nombre',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: !votante.agrupar ? FontWeight.normal : FontWeight.bold,
                  fontStyle: votante.agrupar ? FontStyle.italic : FontStyle.normal,
                  color: color)),
      ],
    );
  }

  FloatingActionButton crearCerrar(BuildContext context) => FloatingActionButton.extended(
        icon: Icon(CupertinoIcons.add, color: Colors.amber),
        label: Text('Mesa completa'),
        onPressed: () {
          cerrarMesa();
          Navigator.pop(context);
        },
      );
}
