// import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../modelos/datos.dart';
import '../utils.dart';
import '../widgets/usuario_card.dart';
import '../widgets/indicador_widget.dart';
import '../widgets/progreso_widget.dart';
import 'escuelas_page.dart';
import 'votantes_page.dart';
import 'buscar_page.dart';
import 'usuarios_page.dart';
import 'encuesta_page.dart';
// import 'pagina_inicial_page.dart';

class IngresarPage extends StatefulWidget {
  const IngresarPage({Key? key}) : super(key: key);

  @override
  _IngresarPageState createState() => _IngresarPageState();
}

enum Estados {
  cargando,
  ingresando,
  ingresado,
  error,
}

class _IngresarPageState extends State<IngresarPage> {
  final _formKey = GlobalKey<FormState>();
  Estados estado = Estados.cargando;
  final controlador = TextEditingController();

  @override
  void initState() {
    this.estado = Estados.cargando;
    Datos.cargar().then((_) {
      setState(() {
        this.estado = Estados.ingresando;
        if (Datos.usuario != 0) {
          irPaginaInicio();
        }
      });
    });
    super.initState();
  }

  void actualizar() => setState(() {});

  @override
  Widget build(BuildContext context) => SafeArea(
        child: Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: estado == Estados.ingresado
                ? IconButton(onPressed: cerrarSesion, icon: Icon(Icons.logout))
                : SizedBox(width: 24),
          ),
          body: Container(
            decoration: crearFondo(),
            alignment: Alignment.center,
            child: Column(
              children: [
                FondoConcejal(),
                Expanded(
                  child: Container(
                    width: 350,
                    child: Form(
                      key: _formKey,
                      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                        Progreso(estado == Estados.cargando),
                        Spacer(),
                        if (estado == Estados.ingresando) ...[crearIngreso(), Spacer(flex: 3)],
                        if (estado == Estados.ingresado) ...[
                          UsuarioCard(compacto: true),
                          // Spacer(),
                          EstadisticaUsuario(),
                          Spacer(),
                          crearNavegar(),
                        ],
                        crearVersion(context),
                      ]),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  void cerrarSesion() => setState(() {
        Datos.usuario = 0;
        this.estado = Estados.ingresando;
        controlador.text = "";
      });

  Widget crearIngreso() =>
      Row(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [
        crearIngresoDNI(),
        SizedBox(width: 10),
        Boton(
          icon: Icons.login,
          label: 'Ingresar',
          onPressed: ingresar,
          onLongPress: ingresarAlejandro,
        ),
      ]);

  void irMarcarPorEscuelas() async {
    await Get.to(EscuelasPage());
    actualizar();
  }

  void irMarcarPorMesa() async {
    await Datos.sincronizarPrioridad();
    final mesa = Datos.prioridad.getRandomElement();
    await Get.to(VotantesPage(mesa: mesa));
    Datos.marcarPrioridad();
    actualizar();
  }

  void irMarcarVotante() async {
    await Get.to(BuscarPage());
    actualizar();
  }

  void irMostrarRanking() async {
    await Get.to(UsuariosPage());
    actualizar();
  }

  void irEncuesta() async {
    await Get.to(EncuestaPage());
  }

  Widget crearNavegar() => Column(
        children: [
          Boton(
              icon: Icons.table_restaurant,
              label: 'Marcar Mesa prioritarias (Faltan ${Datos.prioridad.length})',
              onPressed: irMarcarPorMesa,
              destacar: true),
          Boton(icon: Icons.search, label: 'Marcar Conocidos', onPressed: irMarcarVotante),
          Boton(icon: Icons.holiday_village, label: 'Marcar Escuelas', onPressed: irMarcarPorEscuelas),
          if (Datos.esAdministrador)
            Row(children: [
              Expanded(child: Boton(icon: Icons.sort, label: 'Ver Ranking ', onPressed: irMostrarRanking)),
              if (Datos.esSuperUsuario) ...[
                SizedBox(width: 10),
                Expanded(child: Boton(icon: Icons.sort, label: 'Ver Encuesta', onPressed: irEncuesta))
              ],
            ])
        ],
      );

  Widget crearVersion(BuildContext context) =>
      Text("Versión ${Datos.version}", style: TextStyle(fontSize: 14, color: Theme.of(context).primaryColor));

  Widget crearIngresoDNI() => Container(
        width: 150,
        child: TextFormField(
          keyboardType: TextInputType.number,
          controller: controlador,
          style: TextStyle(fontSize: 20),
          decoration: InputDecoration(
            hintText: "Ingrese DNI",
            filled: true,
            fillColor: Colors.white,
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(width: 1, color: Colors.grey),
            ),
          ),
          validator: validarDNI,
          // onSaved: (value) {
          //   // Datos.usuario = int.parse(value!);
          // },
        ),
      );

  void irPaginaInicio() async {
    Datos.marcarFavoritos();
    Datos.marcarCierres();
    Datos.marcarPrioridad();

    setState(() => estado = Estados.ingresado);
  }

  void ingresar() async {
    if (_formKey.currentState!.validate()) {
      irPaginaInicio();
    }
  }

  void ingresarAlejandro() {
    Datos.usuario = 18627585;
    irPaginaInicio();
    actualizar();
  }

  String? validarDNI(String? value) {
    if (value == null || value.isEmpty) {
      return 'Debe ingresar DNI';
    }
    final intDni = int.tryParse(value);
    if (intDni == null || intDni < 1000000 || intDni > 50000000) {
      return 'Debe ingresar DNI';
    }
    Datos.usuario = intDni;
    return null;
  }
}

class EstadisticaUsuario extends StatelessWidget {
  const EstadisticaUsuario({super.key});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Indicador(etiqueta: "Analizados", valor: Datos.cantidadVotantesCerrados),
            Indicador(etiqueta: "Marcados", valor: Datos.cantidadVotantesMarcados),
            Indicador(
                etiqueta: "Efectividad",
                valor: Datos.cantidadVotantesCerrados > 0
                    ? 1.0 * (Datos.cantidadVotantesMarcados / Datos.cantidadVotantesCerrados)
                    : 0),
          ],
        ),
      );
}

class Boton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final VoidCallback? onLongPress;
  final destacar;

  const Boton({
    this.icon = Icons.login,
    this.label = 'Ingresar',
    required this.onPressed,
    this.onLongPress,
    this.destacar = false,
  });

  factory Boton.navegar(IconData icon, String label, dynamic go) =>
      Boton(icon: icon, label: label, onPressed: () => Get.to(go()));

  @override
  Widget build(BuildContext context) {
    final color = destacar ? Colors.red : Colors.green;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: ElevatedButton(
          onPressed: onPressed,
          onLongPress: onLongPress,
          child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, size: 24, color: color),
                  SizedBox(width: 12),
                  Text(label, style: TextStyle(fontSize: 16, color: color)),
                ],
              ))),
    );
  }
}

class FondoConcejal extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      FittedBox(child: Container(child: Image.asset('datos/fondo.jpg', fit: BoxFit.contain)));
}
