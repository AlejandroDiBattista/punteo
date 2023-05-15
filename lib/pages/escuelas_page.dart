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
          itemBuilder: (BuildContext context, int index) => crearEscuela(datos[index]),
          separatorBuilder: (BuildContext context, int index) => Divider(),
        )));
  }

  Widget crearEscuela(Escuela escuela) {
    final color = escuela.completa ? Colors.green : Colors.black;
    return ListTile(
      title: Row(
        children: [
          Text(escuela.escuela, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
          Expanded(child: Container()),
          Text(escuela.completa ? "(completa)" : "", style: TextStyle(fontSize: 12)),
        ],
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(escuela.direccion, style: TextStyle(fontSize: 16, color: Colors.black)),
          Text(
              '${escuela.mesas.length} mesas (${escuela.totalCerradas} cerradas)  | desde: ${escuela.desde} hasta: ${escuela.hasta} '),
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
