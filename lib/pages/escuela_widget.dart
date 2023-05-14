import 'package:flutter/material.dart';
import '../modelos/escuela.dart';
import '../pages/votantes_page.dart';

class EscuelaWidget extends StatelessWidget {
  final Escuela escuela;

  EscuelaWidget({required this.escuela});

  @override
  Widget build(BuildContext context) {
    final escuela = this.escuela;
    return InkWell(
      onTap: () {
        // Navigator.pushNamed(context, '/votantes', arguments: escuela);
        Navigator.push(context, MaterialPageRoute(builder: (context) => VotantesPage(escuela: escuela)));
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(escuela.escuela, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22.0)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(escuela.direccion, style: TextStyle(fontSize: 16.0)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: Text(
                '${escuela.totalMesas} mesas (de ${escuela.desde} a ${escuela.hasta}) | ${escuela.totalVotantes} votantes',
                style: TextStyle(fontSize: 14.0, color: Colors.grey)),
          ),
          Divider(thickness: 1.0, height: 1.0),
        ],
      ),
    );
  }
}
