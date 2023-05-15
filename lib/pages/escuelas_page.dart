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
  void initState() {
    super.initState();
    if (Datos.escuelas.isEmpty) {
      Datos.cargar().then((value) => setState(() {}));
    }
    print('EscuelasPage.initState');
  }

  @override
  Widget build(BuildContext context) {
    final datos = Datos.escuelas;
    return Scaffold(
        appBar: AppBar(title: Text('Escuelas de Yerba Buena')),
        body: datos.isEmpty
            ? Center(child: CircularProgressIndicator())
            : Center(
                child: Scrollbar(
                child: ListView.separated(
                  itemCount: datos.length,
                  itemBuilder: (BuildContext context, int index) => crearEscuela(index, datos[index]),
                  separatorBuilder: (BuildContext context, int index) => Divider(),
                ),
              )));
  }

  Widget crearEscuela(int indice, Escuela escuela) {
    final color = escuela.completa ? Theme.of(context).primaryColor : Colors.black;
    return ListTile(
      title: Row(
        children: [
          Container(
            width: 20,
            child: Text('${indice + 1}', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w100, color: color)),
          ),
          Text(escuela.escuela, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
          Expanded(child: Container()),
          Text(escuela.completa ? "(completa)" : "", style: TextStyle(fontSize: 12)),
          if (escuela == Datos.escuelaActual)
            Text(
              "(Votas es esta escuela)",
              style: TextStyle(color: Theme.of(context).primaryColor),
            )
        ],
      ),
      subtitle: Row(
        children: [
          SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(escuela.direccion, style: TextStyle(fontSize: 16, color: Colors.black)),
              Text(
                  '${escuela.mesas.length} mesas (${escuela.totalCerradas} cerradas)  | desde: ${escuela.desde} hasta: ${escuela.hasta} '),
              Text('${escuela.totalVotantes} votantes | ${escuela.totalFavoritos} favoritos')
            ],
          ),
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
