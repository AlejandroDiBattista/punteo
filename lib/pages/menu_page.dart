// import 'dart:math';

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
// import 'package:punteo_yb/pages/encuesta_page.dart';
import 'package:punteo_yb/pages/login_page.dart';
import 'package:punteo_yb/widgets/caratula_widtget.dart';

import '../widgets/estadistica_widget.dart';
import '/modelos/datos.dart';
import '/utils.dart';
import '/widgets/boton_widget.dart';
import '/widgets/usuario_card.dart';
import '/widgets/version_widget.dart';
import '../modelos/usuario.dart';
import 'buscar_page.dart';
import 'entregar_page.dart';
import 'escuelas_page.dart';
import 'usuarios_page.dart';
import 'votantes_page.dart';
// import 'encuesta_page.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({Key? key}) : super(key: key);

  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  bool compacto = true;
  Map<String, int> contarCalles = {};
  Map<String, int> contarDomicilios = {};

  Timer? _timer;

  // void debouncing(Function() fn, {int waitForMs = 100}) {
  //   _timer?.cancel();
  //   _timer = Timer(Duration(milliseconds: waitForMs), () => setState(fn));
  // }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    // _timer = Timer.periodic(Duration(seconds: 15), (_) => setState(actualizarCalles));
    actualizarCalles();
    super.initState();
  }

  void actualizarCalles() {
    Datos.sincronizarEntregas().then((_) {
      contarCalles = Datos.contarCalles();
      contarDomicilios = Datos.contarDomicilios();
      actualizar();
      print(">> Actualizamos calles ${DateTime.now()} <<");
    });
  }

  void actualizar() => setState(() {});
  @override
  Widget build(BuildContext context) => SafeArea(
        child: Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(onPressed: cerrarSesion, icon: Icon(Icons.logout))),
          body: Stack(children: [
            Container(
              decoration: crearFondo(),
            ),
            SingleChildScrollView(
              child: Column(
                children: [
                  Caratula(),
                  SizedBox(height: 48),
                  InkWell(
                    child: UsuarioCard(Datos.usuarioActual, compacto: compacto, escuela: false),
                    onTap: () => setState(() => compacto = !compacto),
                  ),
                  if (!compacto) ...[SizedBox(height: 16), EstadisticaUsuario()],
                  SizedBox(height: 48),

                  // SizedBox(height: 16),
                  crearNavegar(),
                  SizedBox(height: 48),
                  Version(),
                ],
              ),
            ),
          ]),
        ),
      );

  Widget crearNavegar() => Container(
        width: 380,
        padding: EdgeInsets.symmetric(horizontal: 4),
        child: Column(
          children: [
            Boton(icon: Icons.school, label: "Resultado por mesas", onPressed: irEscuelas),
            SizedBox(height: 40),
            Boton(icon: Icons.search, label: 'Buscar donde votar', onPressed: irDondeVotan, color: Colors.blue),
            SizedBox(height: 16),
            Boton(
                icon: Icons.star, label: 'Entregar a mis referidos', onPressed: irEntregarMisVotos, color: Colors.red),
            SizedBox(height: 8),
            Boton(icon: Icons.star, label: 'Entregar a todos los referidos', onPressed: irEntregarVotos),
            SizedBox(height: 8),
            Boton(icon: Icons.star, label: 'Todos los referidos', onPressed: irEntregarVotos),
            // Boton(
            //   icon: Icons.star,
            //   label: 'Entregar en Barrios & Countries',
            //   onPressed: irEntregarBarrios,
            // ),
            Text("Entregar votos por calle", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ...Datos.calles.map((c) => crearCalle(c.$1, c.$2)),
            SizedBox(height: 40),
            if (Datos.esAdministrador)
              Row(children: [
                Expanded(child: Boton(icon: Icons.sort, label: 'Ranking ', onPressed: irMostrarRanking)),
                if (Datos.esSuperUsuario) ...[
                  SizedBox(width: 8),
                  Expanded(child: Boton(icon: Icons.error, label: 'Test', onPressed: ejecutarPrueba, color: Colors.red))
                ],
              ])
          ],
        ),
      );

  Widget crearCalle(String titulo, String tag) {
    int votantes = contarCalles[titulo] ?? 0;
    int domicilios = contarDomicilios[titulo] ?? 0;

    if (votantes == 0) return SizedBox(height: 1);
    return Padding(
      padding: const EdgeInsets.only(top: 4.0),
      child: Boton(
        icon: Icons.mail,
        label: titulo,
        info: '${votantes.info('votante')} en ${domicilios.info('domicilio')}',
        onPressed: () => irCalle(titulo, tag),
        destacar: esCalleActiva(titulo),
      ),
    );
  }

  void cerrarSesion() => setState(() {
        Datos.usuario = 0;
        Get.offAll(LoginPage());
      });

  void irMarcarPorEscuelas() async {
    Get.to(EscuelasPage());
    actualizar();
  }

  void irMarcarPorMesa() async {
    await Datos.sincronizarPrioridad();
    final mesa = Datos.prioridad.getRandomElement();
    Get.to(VotantesPage(mesa: mesa));
    Datos.marcarPrioridad();
    actualizar();
  }

  void irDondeVotan() async {
    Datos.sincronizarEntregas();
    Get.to(BuscarPage());
  }

  void irMostrarRanking() async {
    Get.to(UsuariosPage());
    actualizar();
  }

  void irEntregarMisVotos() async {
    await Datos.sincronizarEntregas();
    Get.to(EntregarPage(global: false));
  }

  void irEntregarVotos() async {
    // await Datos.sincronizarEntregas();
    Get.to(EntregarPage(global: true));
  }

  void irEntregarBarrios() async {
    await Datos.sincronizarEntregas();
    Get.to(EntregarPage(
      global: true,
      barrios: true,
    ));
  }

  void irBarrio(String titulo) async {
    await Datos.sincronizarEntregas();
    Get.to(EntregarPage(global: true, titulo: titulo, barrios: true));
  }

  bool esCalleActiva(String calle) {
    final votantes = contarCalles[calle] ?? 0;
    if (votantes == 0) return false;
    final ultimos = Datos.calcularActivos();
    final segundos = ultimos.containsKey(calle) ? ultimos[calle]!.segundosTranscurridos : -1;
    return segundos > 0 && segundos < 5 * 60;
  }

  void mostrarCallesPendientes() {
    contarCalles = Datos.contarCalles();
    contarDomicilios = Datos.contarDomicilios();

    List<String> salida = [];
    salida.add('*PENDIENTE DE ENTREGA*');
    salida.add('```    ${"Calle".pad(18)}   V   D');
    int i = 0;
    int totalVotantes = 0;
    int totalDomicilios = 0;

    Datos.calles.forEach((c) {
      final calle = c.$1;

      int votantes = contarCalles[calle] ?? 0;
      int domicilios = contarDomicilios[calle] ?? 0;
      if (votantes > 0) {
        // print("- ${calle.padRight(30)} $votantes $domicilios $ultimo");
        i++;
        totalVotantes += votantes;
        totalDomicilios += domicilios;
        salida.add("${i.pad(2)}. ${calle.pad(18)} ${votantes.pad(3)} ${domicilios.pad(3)}");
      }
    });
    salida.add('    ${"TOTAL".pad(18)} ${totalVotantes.pad(3)} ${totalDomicilios.pad(3)}');
    salida.add('```');
    final texto = salida.join("\n");
    print(texto);
    Clipboard.setData(ClipboardData(text: texto));
  }

  void exportar(List<String> salida) {
    final texto = salida.join("\n");
    print(texto);
    Clipboard.setData(ClipboardData(text: texto));
  }

  void irCalle(String titulo, String filtro) async {
    Get.to(EntregarPage(global: true, titulo: titulo, filtro: filtro, calles: true));
  }

  void irEscuelas() {
    Get.to(EscuelasPage());
  }

  void exportarBarrios() {
    final contarBarrios = Datos.contarBarrios();
    List<String> salida = [];
    salida.add('*Ranking de Barrios y Contries*');
    salida.add('```');
    // int i = 0;
    int totalVotantes = 0;
    var lista = contarBarrios.entries.toList();
    lista.sort((a, b) => b.value.compareTo(a.value));
    lista.forEach((c) {
      final barrio = c.key; //.replaceAll("Barrio", "B.").replaceAll("Country", "C.");
      final votantes = c.value;

      if (votantes > 3) {
        // print("- ${calle.padRight(30)} $votantes $domicilios $ultimo");
        // i++;
        salida.add('("$barrio", $votantes),');
        // salida.add("${barrio.pad(29)} ${votantes.pad(3)}");
        totalVotantes += votantes;
      }
    });
    salida.add('      ${"TOTAL".pad(22)} ${totalVotantes.pad(3)}');
    salida.add('```');
    exportar(salida);
  }

  void exportarListaPorBarrios() {
    List<String> salida = [];
    salida.add("nro;nombre;barrio;referentes;edad;apellido");
    var n = 1;
    Datos.listarBarrios().forEach((v) {
      final referentes = v.referentes.map((r) => Usuario.traer(r).nombre.invertirNombre).join("|");
      final apellido = v.nombre.split(",").first.trim();
      salida.add('${n++};${v.nombre.invertirNombre};${v.nombreBarrio};$referentes;${v.edad};$apellido');
    });
    exportar(salida);
  }

  void exportarMesas() {
    final List<String> salida = [];
    salida.add("mesa;escuela;votos;entregas;votaron;participacion");
    Datos.mesas.forEach((m) {
      salida.add("${m.numero};${m.nroEscuela};${m.votos};${m.entregas};${m.votaron};${m.participacion.round()}");
    });
    exportar(salida);
  }

  void ejecutarPrueba() async {
    print(">> TEST <<");
    // exportarBarrios();
    // exportarListaPorBarrios();
    exportarMesas();

    // await ;
    // Get.to(EncuestaPage());
  }
}
