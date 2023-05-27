// import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';

// import '../modelos/cierre.dart';
import '../modelos/mesa.dart';
import '../widgets/usuario_card.dart';
import '/pages/ingresar_page.dart';
import '../modelos/datos.dart';
import '../modelos/favorito.dart';
import '../widgets/indicador_widget.dart';
// import '../modelos/escuela.dart';
// import '../modelos/votante.dart';

class EstadisticasPage extends StatefulWidget {
  const EstadisticasPage({key});

  @override
  State<EstadisticasPage> createState() => _EstadisticasPageState();
}

class _EstadisticasPageState extends State<EstadisticasPage> {
  @override
  void initState() {
    Datos.sincronizarFavoritos().then((value) => setState(() {}));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text('Estadísticas')),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: ListView(children: [
              Container(constraints: BoxConstraints(maxWidth: 350)),
              UsuarioCard(),
              mostrarEstadistica(context),
              mostrarCerrar(context),
              // mostrarActualizar(context),
              if (Datos.usuario == 18627585) mostrarProbar(context)
            ]),
          ),
        ),
      ),
    );
  }

  Widget mostrarCerrar(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 80, right: 80, top: 20, bottom: 10),
      child: FilledButton.tonal(
        onPressed: () => cerrarSesion(context),
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Text('Cerrar Sesión', style: TextStyle(fontSize: 20)),
        ),
      ),
    );
  }

  Widget mostrarProbar(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 80, right: 80, top: 10, bottom: 10),
      child: FilledButton(
        onPressed: () => probar(),
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Text('Probar', style: TextStyle(fontSize: 20)),
        ),
      ),
    );
  }

  Widget mostrarActualizar(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 80, right: 80, top: 10, bottom: 10),
      child: FilledButton(
        onPressed: () async {
          await Datos.sincronizarFavoritos();
          setState(() {});
        },
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Text('Actualizar', style: TextStyle(fontSize: 20)),
        ),
      ),
    );
  }

  Widget mostrarEstadistica(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 8,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        width: 380,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Estadisticas',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor)),
            Divider(),
            subtitulo("Escuelas"),
            Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
              Indicador(etiqueta: "Total", valor: Datos.escuelas.length.toDouble()),
              Indicador(etiqueta: "Analizadas", valor: Datos.cantidadEscuelasAnalizadas),
              Indicador(etiqueta: "Completas", valor: Datos.cantidadEscuelasCompletas),
            ]),
            Divider(),
            subtitulo("Mesas"),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Indicador(etiqueta: "Total", valor: Datos.cantidadMesas.toDouble()),
                Indicador(etiqueta: "Analizadas", valor: Datos.cantidadMesasAnalizadas),
                Indicador(etiqueta: "Cerradas", valor: Datos.cantidadMesasCerradas),
              ],
            ),
            Divider(),
            subtitulo("Votantes"),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Indicador(etiqueta: "Analizados", valor: Datos.cantidadVotantesAnalizados),
                Indicador(etiqueta: "Marcados", valor: Datos.cantidadVotantesMarcados),
                if (Datos.cantidadVotantesMarcados > 0)
                  Indicador(
                      etiqueta: "Efectividad",
                      valor: 1.0 * (Datos.cantidadVotantesMarcados / Datos.cantidadVotantesAnalizados)),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget subtitulo(String texto) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(texto, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
    );
  }

  void cerrarSesion(BuildContext context) {
    Datos.usuario = 0;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => IngresarPage()),
    );
  }

  void probar() async {
    // await Datos.buscarActualizacionFavoritos();
    await Datos.sincronizarFavoritos();
    final sesiones = Favorito.calcularSesiones(Datos.usuario);
    print("SESIONES de ${Datos.usuarioActual.nombre}");
    sesiones.forEach((s) => print(' - $s'));

    final mesa = Mesa.traer(3333);
    mesa.esCerrada = true;
    Datos.marcarMesa(mesa);
  }
}
