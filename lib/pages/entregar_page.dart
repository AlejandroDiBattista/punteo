import 'dart:async';
import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:punteo_yb/widgets/usuario_card.dart';

import '../modelos/entrega.dart';
import '/colores.dart';
import '/utils.dart';

import '/widgets/votantes_item.dart';

import '/modelos/datos.dart';
import '../modelos/votante.dart';

class EntregarPage extends StatefulWidget {
  final bool global;
  final String titulo;
  final String filtro;
  final bool barrios;
  final bool calles;

  @override
  EntregarPage({required this.global, this.titulo = "", this.filtro = "", this.barrios = false, this.calles = false});

  State<EntregarPage> createState() => _EntregarPageState();
}

class _EntregarPageState extends State<EntregarPage> {
  final controlador = TextEditingController();

  bool ubicable = true;

  String get tag => widget.filtro;

  get global => widget.global;
  get porBarrios => widget.barrios;
  get porCalles => tag.isNotEmpty;

  var votantes = Datos.votantes;

  Timer? _debounceTimer;

  String get filtro => ''.sinEspacios;

  @override
  void initState() {
    if (porCalles) ubicable = true;
    if (porBarrios) ubicable = false;

    aplicarBusqueda('');
    Datos.sincronizarEntregas().then((_) => actualizarBusqueda());
    super.initState();
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }

  void actualizarBusqueda() => alBuscar(controlador.text);

  void debouncing(Function() fn, {int waitForMs = 100}) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(Duration(milliseconds: waitForMs), () => setState(fn));
  }

  int compararCalle(Votante a, Votante b) {
    if (a.calle == b.calle) {
      return a.altura.compareTo(b.altura);
    }
    return a.calle.compareTo(b.calle);
  }

  int compararUbicable(Votante a, Votante b) {
    if (a.esUbicable == b.esUbicable) return compararCalle(a, b);
    return a.esUbicable ? -1 : 1;
  }

  int compararNoUbicable(Votante a, Votante b) {
    if (a.precision == b.precision) return a.domicilio.compareTo(b.domicilio);
    return a.precision.compareTo(b.precision);
  }

  void aplicarBusqueda(String texto) {
    votantes = Datos.buscar('$texto ${global ? 'favoritos' : 'mis favoritos'} $tag');

    if (ubicable) {
      votantes = votantes.where((v) => v.esUbicable || v.conUbicacion).toList();
      votantes.sort((a, b) => compararUbicable(a, b));
    } else {
      if (porBarrios) {
        votantes = votantes.where((v) => v.enBarrios).toList();
      } else {
        votantes = votantes.where((v) => v.esNoUbicable).toList();
      }

      votantes.sort((a, b) => compararNoUbicable(a, b));
    }

    votantes = votantes.where((v) => v.entrega == EstadoEntrega.pendiente).toList();
  }

  void alBuscar(String texto) {
    debouncing(() => aplicarBusqueda(texto));
  }

  void siguienteUbicable() {
    ubicable = !ubicable;
    actualizarBusqueda();
  }

  @override
  Widget build(BuildContext context) {
    final titulo = crearTituloPagina();
    final infoEstilo = TextStyle(fontSize: 16, color: Colors.blue);
    final infoTitulo = TextStyle(fontSize: 16, fontWeight: FontWeight.bold);
    return Scaffold(
      appBar: crearTitulo(
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [Text(titulo, style: infoTitulo), Text('${votantes.length}', style: infoEstilo)],
          ),
          actions: (porCalles || porBarrios) ? [] : [filtroUbicable()]),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: crearBuscar(),
          ),
          Expanded(
              child: ListView.separated(
            itemCount: votantes.length + 1,
            itemBuilder: (BuildContext context, int index) => item(index),
            separatorBuilder: (_, index) =>
                (porCalles || porBarrios || ubicable) ? separadorCalles(index) : separadorGrupo(index),
          )),
        ],
      ),
    );
  }

  String crearTituloPagina() {
    return widget.titulo.isNotEmpty
        ? widget.titulo
        : this.porCalles
            ? 'Calle $tag'
            : porBarrios
                ? 'Barrios y Countries'
                : global
                    ? 'Todos'
                    : 'Los mios';
  }

  Widget crearBuscar() => TextField(
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
            borderRadius: BorderRadius.circular(30), borderSide: BorderSide(width: 1, color: Colors.grey)),
      ),
      onChanged: alBuscar);

  Widget filtroUbicable() => Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: OutlinedButton(
            onPressed: siguienteUbicable,
            child: Text(ubicable ? 'Con dirección' : 'Sin dirección', style: TextStyle(fontSize: 14))),
      );

  void registrarResultado(Votante v, EstadoEntrega e) {
    if (v.entrega != e) {
      final aux = v.entrega;
      v.entrega = e;
      print('Se cambio es estado de ${v.nombre} desde [$aux] a [$e]');
      Datos.marcarEntrega(v).then((_) => actualizarBusqueda());
    }
  }

  Widget item(int i) {
    if (i == 0) return Divider(height: 1);
    return VotanteItem(votante: votantes[i - 1], color: Colors.black, index: i - 1, alResponder: registrarResultado);
  }

  String clave(Votante v) => porBarrios
      ? v.nombreBarrio
      : porCalles
          ? v.domicilio
          : v.calle;

  bool igual(Votante a, Votante b) => clave(a) == clave(b);

  Widget separadorCalles(int i) {
    final frente = Colors.green[700];
    final fondo = Colors.yellow[100];

    if (i == 0 || !igual(votantes[i], votantes[i - 1])) {

      var n = i;
      while (n < votantes.length - 1 && igual(votantes[n], votantes[n + 1])) n++;
      final cantidad = n - i + 1;

      return Container(
          padding: EdgeInsets.symmetric(vertical: 4, horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(tituloGrupo(i), style: TextStyle(fontSize: 16, color: frente)),
              if (cantidad > 1) Text('$cantidad', style: TextStyle(fontSize: 22, color: frente))
            ],
          ),
          color: fondo);
    }
    return Divider(color: Colores.divisor, height: 1);
  }

  Widget separadorGrupo(int i) {
    final frente = Colors.green[700];
    final fondo = Colors.yellow[100];
    if (i == 0 || votantes[i].precision != votantes[i - 1].precision) {
      
      var n = i;
      while (n < votantes.length - 1 && votantes[n].precision == votantes[n + 1].precision) n++;
      final cantidad = n - i + 1;

      return Container(
        padding: EdgeInsets.symmetric(vertical: 4, horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(describirGrupo(votantes[i]), style: TextStyle(fontSize: 16, color: frente)),
            if (cantidad > 1) Text('$cantidad', style: TextStyle(fontSize: 22, color: frente))
          ],
        ),
        color: fondo,
      );
    }

    return Divider(color: Colores.divisor, height: 1);
  }

  String tituloGrupo(int i) {
    return porCalles
        ? votantes[i].domicilio
        : porBarrios
            ? clave(votantes[i])
            : votantes[i].calle;
  }

  String describirGrupo(Votante v) =>
      switch (v.precision) { 3 => 'No Ubicable', 4 => 'Barrios', 5 => 'Countries', _ => '' };
}

// enum Distancia {
//   todos(0),
//   cerca(300),
//   mediano(600),
//   grande(1500),
//   ;

//   final double distancia;
//   const Distancia(this.distancia);

//   get activo => this != todos;
//   Distancia siguiente() => switch (this) {
//         todos => grande,
//         grande => mediano,
//         mediano => cerca,
//         cerca => todos,
//       };

//   Icon getIcon() => Icon(
//       switch (this) {
//         todos => Icons.location_off,
//         cerca => Icons.location_on_outlined,
//         mediano => Icons.location_on_rounded,
//         grande => Icons.location_on,
//       },
//       color: this.activo ? Colors.red : Colors.grey,
//       size: 20);

//   bool dentro(double distancia) => distancia < this.distancia;

//   @override
//   String toString() => activo ? '< ${this.distancia}m' : 'Todos";
// }
