import 'package:flutter/material.dart';

import '/modelos/votante.dart';
import '../modelos/datos.dart';
import 'votantes_item.dart';

class BuscarPage extends StatefulWidget {
  @override
  State<BuscarPage> createState() => _BuscarPageState();
}

class _BuscarPageState extends State<BuscarPage> {
  final controlador = TextEditingController();
  var votantes = Datos.votantes;

  Future<void> marcarFavorito(Votante votante) async {
    votante.cambiarFavorito();
    setState(() {});
    Datos.marcarFavorito(votante);
  }

  void alBuscar(String texto) {
    setState(() {
      votantes = Datos.buscar(texto);
    });
  }

  @override
  Widget build(BuildContext context) {
    // final votantes = Datos.votantes; //.take(20).toList();
    return Scaffold(
      appBar: AppBar(
          title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Buscar', style: TextStyle(fontSize: 22)),
          Text('${votantes.length} votantes', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w100)),
        ],
      )),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: TextField(
              style: TextStyle(fontSize: 22),
              controller: controlador,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                prefixIcon: Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    controlador.clear();
                    alBuscar('');
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(width: 1, color: Colors.grey),
                ),
              ),
              onChanged: alBuscar,
            ),
          ),
          Expanded(
            child: ListView.separated(
              itemCount: votantes.length,
              itemBuilder: (BuildContext context, int index) {
                final Votante votante = votantes[index];
                final color = votante.favorito ? Theme.of(context).primaryColor : Colors.black;
                return VotanteItem(votante: votante, color: color, index: index, alMarcar: marcarFavorito);
              },
              separatorBuilder: (BuildContext context, int index) => divisor(index),
            ),
          ),
        ],
      ),
    );
  }

  Widget divisor(int index) {
    if (index < votantes.length - 1) {
      final siguiente = votantes[index + 1];
      if (!siguiente.agrupar) return Divider(thickness: 2);
    }
    return Divider();
  }
}
