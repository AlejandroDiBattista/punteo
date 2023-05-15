// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myapp/pages/escuelas_page.dart';

class PaginaInicialPage extends StatelessWidget {
  final int cantidadVotantesAnalizados;
  final int cantidadVotantesMarcados;

  const PaginaInicialPage({
    Key? key,
    required this.cantidadVotantesAnalizados,
    required this.cantidadVotantesMarcados,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Página Inicial'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('Cantidad de votantes analizados: $cantidadVotantesAnalizados'),
          Text('Cantidad de votantes marcados: $cantidadVotantesMarcados'),
        ],
      ),
      bottomNavigationBar: Container(
        height: 60.0,
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: ElevatedButton(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Marcar Votantes'),
                  ),
                  onPressed: () async {
                    await Navigator.push(context, MaterialPageRoute(builder: (context) => EscuelasPage()));
                  },
                ),
              ),
              Expanded(
                child: ElevatedButton(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Buscar donde voto'),
                  ),
                  onPressed: () {
                    // Lógica para marcar votantes
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
