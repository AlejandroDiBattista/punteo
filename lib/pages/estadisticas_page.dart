import 'package:flutter/material.dart';

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Estadisticas')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: ListView(children: [
            mostrarUsuario(context),
            mostrarEstadistica(context),
            mostrarCerrar(context),
            mostrarActualizar(context),
            if (Datos.usuario == 18627585) mostrarProbar(context)
          ]),
        ),
      ),
    );
  }

  Widget mostrarCerrar(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 80, right: 80, top: 20, bottom: 10),
      child: FilledButton(
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

  Card mostrarUsuario(BuildContext context) {
    final usuario = Datos.usuarioActual;
    final escuela = Datos.escuelaActual;

    final nombre = TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor);
    return Card(
      elevation: 8,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        width: 300,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(usuario.nombre, style: nombre),
            Text('DNI: ${usuario.dni}', style: TextStyle(fontSize: 20)),
            Divider(),
            Text(usuario.domicilio, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('Clase : ${usuario.clase < 0 ? "~" : ""}${usuario.clase.abs()}'),
              Text('Sexo : ${usuario.sexo == "M" ? "Masculino" : "Femenino"}'),
            ]),
            Divider(),
            Text(escuela.escuela, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text(escuela.direccion, style: TextStyle(fontSize: 16)),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('Mesa : ${usuario.mesa}', style: TextStyle(fontSize: 18)),
              Text('Orden: ${usuario.orden}', style: TextStyle(fontSize: 18))
            ]),
          ],
        ),
      ),
    );
  }

  Widget mostrarEstadistica(BuildContext context) {
    return Container(
      width: 300,
      child: Card(
        elevation: 8,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          width: 300,
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
    await Datos.buscarActualizacionFavoritos();
    await Datos.buscarFavoritosPendientes();
    final sesiones = Favorito.calcularSesiones(Datos.usuario);
    print("SESIONES de ${Datos.usuarioActual.nombre}");
    sesiones.forEach((s) => print(' - $s '));
  }
}
