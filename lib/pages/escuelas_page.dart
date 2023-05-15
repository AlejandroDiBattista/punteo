import 'package:flutter/material.dart';
import '../modelos/escuela.dart';
import '../modelos/datos.dart';
import 'mesas_page.dart';

class EscuelasPage extends StatefulWidget {
  @override
  State<EscuelasPage> createState() => _EscuelasPageState();
}

class _EscuelasPageState extends State<EscuelasPage> {
  @override
  Widget build(BuildContext context) {
    final datos = Datos.escuelas;
    return Scaffold(
        appBar: AppBar(title: Text('Escuelas de YB')),
        body: Center(
            child: ListView.separated(
          itemCount: datos.length,
          itemBuilder: (BuildContext context, int index) => crearEscuela(context, datos[index]),
          separatorBuilder: (BuildContext context, int index) => Divider(),
        )));
  }

  Widget crearEscuela(BuildContext context, Escuela escuela) {
    return ListTile(
      title: Text(
        '${escuela.escuela} ${escuela.completa ? "(completa)" : ""}',
        style: TextStyle(fontSize: 24, color: escuela.completa ? Colors.green : Colors.black),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(escuela.direccion, style: TextStyle(fontSize: 20)),
          Text(
              '${escuela.mesas.length} mesas | Desde ${escuela.desde} hasta ${escuela.hasta} | ${escuela.totalCerradas} cerradas'),
          Text('${escuela.totalVotantes} votantes | ${escuela.totalFavoritos} favoritos')
        ],
      ),
      onTap: () => irMesa(context, escuela),
    );
  }

  Future<void> irMesa(BuildContext context, Escuela escuela) async {
    print('irMesa: ${escuela.escuela}');
    await Navigator.push(context, MaterialPageRoute(builder: (context) => MesasPage(escuela: escuela)));
    setState(() {});
  }
}
