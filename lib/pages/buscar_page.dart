import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

// import 'package:punteo_yb/widgets/usuario_card.dart';

import '/colores.dart';
import '/modelos/datos.dart';
import '/utils.dart';
import '/widgets/votantes_item.dart';
import '../modelos/votante.dart';
import 'votante_page.dart';

enum Sexo {
  todos(''),
  hombre('hombre'),
  mujer('mujer');

  final String clave;
  const Sexo(this.clave);

  get activo => this != todos;
  Sexo siguiente() => switch (this) { todos => hombre, hombre => mujer, mujer => todos };

  Icon getIcon() => Icon(switch (this) { todos => Icons.people, hombre => Icons.man, mujer => Icons.woman },
      color: this.activo ? (this == hombre ? Colors.blue : Colors.pink) : Colors.grey, size: 20);

  @override
  String toString() => this.clave;
}

enum Favorito {
  todos(''),
  mios('mis favoritos'),
  favoritos('favoritos'),
  repetidos('repetidos');

  final String clave;
  const Favorito(this.clave);

  get activo => this != todos;
  Favorito siguiente() =>
      switch (this) { todos => mios, mios => favoritos, favoritos => repetidos, repetidos => todos };

  Icon getIcon() =>
      Icon(switch (this) { todos => Icons.star, mios => Icons.star, favoritos => Icons.star, repetidos => Icons.star },
          color: switch (this) {
            todos => Colors.grey,
            mios => Colors.green,
            favoritos => Colors.yellow,
            repetidos => Colors.red
          },
          size: 20);

  @override
  String toString() => this.clave;
}

enum Ubicacion {
  todos(''),
  localizados('localizados'),
  deslocalizados('deslocalizados'),
  cerca('cerca');

  final String clave;
  const Ubicacion(this.clave);

  get activo => this != todos;

  Ubicacion siguiente() =>
      switch (this) { cerca => cerca, todos => localizados, localizados => deslocalizados, deslocalizados => todos };
  Icon getIcon() => Icon(
      switch (this) {
        todos => Icons.location_on,
        cerca => Icons.location_on_outlined,
        localizados => Icons.location_on,
        deslocalizados => Icons.location_off,
      },
      color: this.activo ? Colors.red : Colors.grey,
      size: 20);

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
  Favorito favorito = Favorito.todos;

  var votantes = Datos.ordenados;

  Timer? _debounceTimer;

  void debouncing(Function() fn, {int waitForMs = 100}) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(Duration(milliseconds: waitForMs), () => setState(fn));
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }

  Future<void> irVotante(Votante votante) async {
    Get.to(VotantePage(votante: votante));
  }

  Future<void> marcarFavorito(Votante votante) async {
    votante.cambiarFavorito();
    votante.marcarBuscar();
    Datos.marcarFavorito(votante);
    setState(() {});
  }

  void alBuscar(String texto) {
    debouncing(() {
      votantes = Datos.buscar('$texto $ubicacion $sexo $favorito');
    });
  }

  void filtrarFavoritos() {
    this.favorito = this.favorito.siguiente();
    if (this.favorito.activo)
      Get.snackbar(
        'Filtro por favoritos',
        this.favorito == Favorito.mios
            ? 'Mis favoritos'
            : this.favorito == Favorito.favoritos
                ? 'Todos los favoritos'
                : 'Favoritos repetidos',
        icon: this.favorito.getIcon(),
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 2),
        dismissDirection: DismissDirection.horizontal,
      );
    alBuscar(controlador.text);
  }

  void filtrarUbicacion() {
    this.ubicacion = this.ubicacion.siguiente();
    if (this.ubicacion.activo)
      Get.snackbar(
        'Filtro por ubicación',
        this.ubicacion == Ubicacion.localizados ? 'Votantes geolocalizados' : 'Votantes sin geolocalización',
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

  String get filtro => '$favorito $sexo $ubicacion'.sinEspacios;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: crearTitulo(titulo(), actions: [
          IconButton(onPressed: filtrarFavoritos, icon: this.favorito.getIcon()),
          IconButton(onPressed: filtrarSexo, icon: this.sexo.getIcon()),
          IconButton(onPressed: filtrarUbicacion, icon: this.ubicacion.getIcon()),
        ]),
        body: Column(
          children: [
            crearBusqueda(),
            crearVotantes(),
          ],
        ),
      );

  Widget crearVotantes() => Expanded(
        child: ListView.separated(
          itemCount: votantes.length,
          itemBuilder: (BuildContext context, int index) {
            final Votante votante = votantes[index];
            final color = votante.favorito ? Theme.of(context).primaryColor : Colors.black;
            return VotanteItem(votante: votante, color: color, index: index, alMarcar: irVotante);
          },
          separatorBuilder: (BuildContext context, int index) => Divider(color: Colores.divisor, height: 1),
        ),
      );

  Widget titulo() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Buscar', style: TextStyle(fontSize: 20)),
          Column(
            children: [
              Text(votantes.length.info('votante', 'votantes', 'Nada'), style: TextStyle(fontSize: 16)),
              if (filtro.isNotEmpty) Text(filtro, style: TextStyle(fontSize: 10)),
            ],
          ),
        ],
      );

  Widget crearBusqueda() => Container(
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
      );
}
