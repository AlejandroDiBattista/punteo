import 'package:flutter/material.dart';
// import 'package:myapp/sheets_api.dart';
import 'modelos/votante.dart';

class VotantesList extends StatefulWidget {
  final List<Votante> votantes;

  VotantesList({required this.votantes});

  @override
  State<VotantesList> createState() => _VotantesListState();
}

class _VotantesListState extends State<VotantesList> {
  void _alterar(Votante votante) {
    setState(() => votante.cambiarFavorito());
    // SheetsApi.marcarFavorito(votante, 1, votante.favorito);
    // print("Alterar ${votante.nombre} a ${votante.favorito}");
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.votantes.length,
      itemBuilder: (context, index) {
        final votante = widget.votantes[index];
        return GestureDetector(
          onTap: () => _alterar(votante),
          child: ListTile(
            trailing: IconButton(
              icon: iconoFavorito(votante),
              onPressed: () => _alterar(votante),
              tooltip: 'Clasificación',
            ),
            title: Text(
              votante.nombre,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(votante.domicilio),
                SizedBox(height: 6.0),
                Text(
                  'DNI ${votante.dni} - Mesa ${22} - Orden ${votante.orden}',
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Icon iconoFavorito(Votante votante) {
    // return Icon(
    //     votante.favorito == 'S'
    //         ? Icons.thumb_up_alt_rounded
    //         : votante.favorito == 'N'
    //             ? Icons.thumb_down_alt_rounded
    //             : Icons.thumb_up_alt_outlined,
    //     color: votante.favorito == 'S'
    //         ? Colors.green
    //         : votante.favorito == 'N'
    //             ? Colors.red
    //             : Colors.grey);
    // }
    return Icon(Icons.thumb_down_alt_rounded, color: Colors.yellow);
  }
}
