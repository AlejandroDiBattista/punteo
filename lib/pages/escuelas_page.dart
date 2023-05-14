import 'package:flutter/material.dart';
import 'package:myapp/pages/votantes_page.dart';
// import 'package:googleapis/androiddeviceprovisioning/v1.dart';
// import '../modelos/escuela.dart';
// import '../sheets_api.dart';
import './escuela_widget.dart';
import '../modelos/datos.dart';

class EscuelasPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final datos = Datos.escuelas;
    return Scaffold(
        appBar: AppBar(title: Text('Escuelas de YB')),
        body: Center(
            child: ListView.builder(
                itemCount: datos.length,
                itemBuilder: (BuildContext context, int index) => EscuelaWidget(escuela: datos[index]))));
  }
}

@override
Widget build(BuildContext context) {
  return ListView.builder(
    itemCount: Datos.escuelas.length,
    itemBuilder: (BuildContext context, int index) {
      final escuela = Datos.escuelas[index];
      return ListTile(
        title: Text(escuela.escuela),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(escuela.direccion),
            Text('Desde ${escuela.desde} hasta ${escuela.hasta}, ${escuela.mesas} mesas, ${escuela.totalVotantes} votantes'),
          ],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VotantesPage(escuela: escuela),
            ),
          );
        },
      );
    },
  );
}
