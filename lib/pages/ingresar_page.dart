import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:punteo_yb/pages/encuesta_page.dart';
import 'package:punteo_yb/pages/votantes_page.dart';
// import 'estadisticas_page.dart';
import '../widgets/usuario_card.dart';
import 'usuarios_page.dart';

import '../colores.dart';
import '../modelos/datos.dart';
import '../widgets/indicador_widget.dart';
import '../widgets/progreso_widget.dart';
import 'buscar_page.dart';
import 'escuelas_page.dart';
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
            title: Center(child: crearTitulo(context)),
            leading: estado == Estados.ingresado && Datos.usuario == 18627585
                ? IconButton(onPressed: refrescarDatos, icon: Icon(Icons.sync))
                : SizedBox(width: 24),
            actions: [
              estado == Estados.ingresado
                  ? IconButton(
                      onPressed: cerrarSesion,
                      icon: Icon(Icons.logout),
                    )
                  : SizedBox(width: 24),
            ],
          ),
          body: Container(
            decoration: crearFondo(),
            alignment: Alignment.center,
            child: Container(
              width: 350,
              child: Form(
                key: _formKey,
                child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  FondoConcejal(),
                  Progreso(estado == Estados.cargando),
                  Spacer(),
                  if (estado == Estados.ingresando) crearIngreso(),
                  Spacer(flex: 2),
                  if (estado == Estados.ingresado) ...[
                    UsuarioCard(compacto: true),
                    Spacer(),
                    EstadisticaUsuario(),
                    Spacer(),
                    crearNavegar(),
                  ],
                  crearVersion(context),
                ]),
              ),
            ),
          ),
        ),
      );

  void cerrarSesion() => setState(() {
        Datos.usuario = 0;
        this.estado = Estados.ingresando;
        controlador.text = "";
      });

  void refrescarDatos() {
    Get.to(EncuestaPage());
    // setState(() => Datos.sincronizarFavoritos().then((value) => setState(
    //     () {},
    //   )));
  }

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

  void irMarcarPorMesa() async {
    await Get.to(VotantesPage(mesa: Datos.elegirMesa()));
    actualizar();
  }

  void irMarcarPorEscuelas() async {
    await Get.to(EscuelasPage());
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

  Widget crearNavegar() => Column(
        children: [
          Boton(icon: Icons.school, label: 'Marcar por escuelas', onPressed: irMarcarPorEscuelas),
          Boton(icon: Icons.mail, label: 'Marcar Mesa sugerida', onPressed: irMarcarPorMesa),
          Boton(icon: Icons.search, label: 'Marcar por votantes', onPressed: irMarcarVotante),
          if (Datos.esAdministrador)
            Boton(icon: Icons.sort, label: 'Ver Ranking de usuarios', onPressed: irMostrarRanking),
        ],
      );

  BoxDecoration crearFondo() => BoxDecoration(
          gradient: LinearGradient(
        colors: [Colores.comenzar, Colores.terminar],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ));

  Widget crearTitulo(BuildContext context) => Text("Punteo YB",
      style: TextStyle(
          fontSize: 46, color: Theme.of(context).primaryColor, fontFamily: "Oxanium", fontWeight: FontWeight.bold));

  Widget crearVersion(BuildContext context) =>
      Text("Versión ${Datos.version}", style: TextStyle(fontSize: 14, color: Theme.of(context).primaryColor));

  Widget crearIngresoDNI() => Container(
        width: 150,
        child: TextFormField(
          keyboardType: TextInputType.number,
          controller: controlador,
          // textAlign: TextAlign.center,
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
          onSaved: (value) {
            // Datos.usuario = int.parse(value!);
          },
        ),
      );

  void irPaginaInicio() async {
    Datos.marcarFavoritos();
    Datos.marcarCierres();
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

  const Boton({
    this.icon = Icons.login,
    this.label = 'Ingresar',
    required this.onPressed,
    this.onLongPress,
  });

  factory Boton.navegar(IconData icon, String label, dynamic go) =>
      Boton(icon: icon, label: label, onPressed: () => Get.to(go()));

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 12.0),
        child: ElevatedButton(
            onPressed: onPressed,
            onLongPress: onLongPress,
            child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(icon, size: 24),
                    SizedBox(width: 12),
                    Text(label, style: TextStyle(fontSize: 16)),
                  ],
                ))),
      );
}

class FondoConcejal extends StatelessWidget {
  @override
  Widget build(BuildContext context) => FittedBox(
        child: FittedBox(
          child: Container(
            padding: EdgeInsets.only(top: 50),
            child: Image.asset(
              'datos/fondo.png', // Ruta relativa de la imagen
              fit: BoxFit.contain, // Ajuste de la imagen dentro del contenedor
              height: 250,
              // Alto del contenedor
            ),
          ),
        ),
      );
}
