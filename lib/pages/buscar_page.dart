import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/colores.dart';
import '/utils.dart';

import '/widgets/votantes_item.dart';

import '/modelos/datos.dart';
import '/modelos/votante.dart';

enum Sexo {
  todos(''),
  hombre('hombre'),
  mujer('mujer');

  final String clave;
  const Sexo(this.clave);

  get activo => this != todos;
  Sexo siguiente() => switch (this) { todos => hombre, hombre => mujer, mujer => todos };

  Icon getIcon() => Icon(switch (this) { todos => Icons.people, hombre => Icons.man, mujer => Icons.woman },
      color: this.activo ? (this == hombre ? Colors.blue : Colors.pink) : Colors.grey);

  @override
  String toString() => this.clave;
}

enum Ubicacion {
  todos(''),
  localizados('localizados'),
  cerca('cerca');

  final String clave;
  const Ubicacion(this.clave);

  get activo => this != todos;

  Ubicacion siguiente() => switch (this) { todos => cerca, cerca => localizados, localizados => todos };
  Icon getIcon() => Icon(
      switch (this) {
        todos => Icons.location_on,
        cerca => Icons.location_on,
        localizados => Icons.location_on_outlined
      },
      color: this.activo ? Colors.red : Colors.grey);

  @override
  String toString() => this.clave;
}

class BuscarPage extends StatefulWidget {
  @override
  State<BuscarPage> createState() => _BuscarPageState();
}

class _BuscarPageState extends State<BuscarPage> {
  final controlador = TextEditingController();

  Ubicacion ubicacion = Ubicacion.todos;
  Sexo sexo = Sexo.todos;

  var votantes = Datos.votantes;

  Timer? _debounceTimer;

  void debouncing(Function() fn, {int waitForMs = 100}) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(Duration(milliseconds: waitForMs), () => setState(fn));
  }

  Future<void> marcarFavorito(Votante votante) async {
    votante.cambiarFavorito();
    votante.marcarBuscar();
    Datos.marcarFavorito(votante);
    setState(() {});
  }

  void alBuscar(String texto) {
    debouncing(() {
      votantes = Datos.buscar('$texto $ubicacion $sexo');
    });
  }

  void filtrarUbicacion() {
    this.ubicacion = this.ubicacion.siguiente();
    if (this.ubicacion.activo)
      Get.snackbar(
        'Filtro por ubicación',
        this.ubicacion == Ubicacion.localizados
            ? 'Muestra los votantes geolocalizados'
            : 'Muestra los votantes cercanos al usuario',
        icon: this.ubicacion.getIcon(),
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 2),
        dismissDirection: DismissDirection.horizontal,
      );
    alBuscar(controlador.text);
  }

  void filtrarSexo() {
    this.sexo = this.sexo.siguiente();
    if (this.sexo.activo)
      Get.snackbar(
        'Filtrar por sexo',
        this.sexo == Sexo.hombre ? 'Muestra solo los hombres' : 'Muestra solo las mujeres',
        icon: this.sexo.getIcon(),
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 2),
        dismissDirection: DismissDirection.horizontal,
      );
    alBuscar(controlador.text);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: crearTitulo(
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Buscar'),
                Text(votantes.length.info('votante'), style: TextStyle(fontSize: 16)),
              ],
            ),
            actions: [
              IconButton(onPressed: filtrarSexo, icon: this.sexo.getIcon()),
              IconButton(onPressed: filtrarUbicacion, icon: this.ubicacion.getIcon()),
            ]),
        body: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: TextField(
                  textInputAction: TextInputAction.search,
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
                  onChanged: alBuscar),
            ),
            Expanded(
              child: ListView.separated(
                itemCount: votantes.length,
                itemBuilder: (BuildContext context, int index) {
                  final Votante votante = votantes[index];
                  final color = votante.favorito ? Theme.of(context).primaryColor : Colors.black;
                  return VotanteItem(votante: votante, color: color, index: index, alMarcar: marcarFavorito);
                },
                separatorBuilder: (BuildContext context, int index) => Divider(color: Colores.divisor, height: 1),
              ),
            ),
          ],
        ),
      );
}
