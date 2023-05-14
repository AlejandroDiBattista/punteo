// import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:scroll_to_index/scroll_to_index.dart';


import 'action_button.dart';

class RegistroPage extends StatefulWidget {
  const RegistroPage({Key? key}) : super(key: key);
  @override
  PlanillaState createState() => PlanillaState();
}

class PlanillaState extends State<RegistroPage> {
  late AutoScrollController controller;

  String texto = "";
  bool error = false;

  void initState() {
    controller = AutoScrollController(viewportBoundaryGetter: () => Rect.fromLTRB(0, 0, 0, 350));
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _actualizar(String valor) {
    while (valor.length > 1 && valor.startsWith("0")) {
      valor = valor.substring(1);
    }

    int valorInt = int.parse("0$valor");
    if (valorInt < 399) {
      this.texto = valor;
      setState(() {});
    }
    error = false;
  }

  void _limpiar() {
    texto = "";
    error = false;
    setState(() {});
  }

  // void _update(String digito) {
  //   _actualizar(texto + digito);
  // }

  void _scroll() {
    // controller.scrollToIndex(planilla.fila,
    //     duration: Duration(milliseconds: 500), preferPosition: AutoScrollPosition.end);
    error = false;
    ScaffoldMessenger.of(context)..removeCurrentSnackBar();
  }

  void _scrollConfirmar() {
    controller.scrollToIndex(99, duration: Duration(milliseconds: 500), preferPosition: AutoScrollPosition.begin);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.green.shade600,
            elevation: 10,
            centerTitle: true,
            // toolbarHeight: 80,
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
            title: Column(
              children: [
                Text("Mesa 1", style: TextStyle(fontSize: 32)),
                // Text("${planilla.escuela}", style: TextStyle(fontSize: 20))
              ],
            )),
        body: Container(
            width: double.infinity,
            height: double.infinity,
            color: Color(0xFFEEEEEE),
            child: Stack(children: [
              buildPlanilla(),
              buildTeclado(),
            ])),
      ),
    );
  }

  Widget buildTeclado() {
    return Container(
      child: Column(children: [
        Spacer(),
      ]),
    );
  }

  Widget buildPlanilla() {
    return Container(
      child: ListView(
        controller: controller,
        children: [
          SizedBox(height: 240),
        ],
      ),
    );
  }

  void alFinalizar() async {
    if (error) {
      print(error ? 'Asi está la planilla.\nRegistrar igual' : 'Registrar planilla');
      ScaffoldMessenger.of(context)..removeCurrentSnackBar();

      // await SheetsApi.registrar(0, 0, 0);

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(backgroundColor: Colors.green, content: Text("Se registraron los datos")));

      return Navigator.pop(context);
    } else {
      error = true;
      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(SnackBar(
            duration: Duration(seconds: 10),
            backgroundColor: Colors.red,
            content: Text("""Hay errores en los datos de $texto
                   
                   Revisar la que los datos coincidan con la planilla. 
                   Si la planilla contiene errores registrar igual""")));

      setState(() {});
      _scrollConfirmar();
    }
  }

  Widget irAgrupacion(Widget child, int index) {
    return GestureDetector(
        onTap: () {
          _limpiar();
          _scroll();
        },
        child: child);
  }

  Widget tocar(int index, Widget child) {
    return GestureDetector(
        onTap: () {
          _limpiar();
          _scroll();
        },
        child: child);
  }

  // Widget lista(int index) {
  //   return AutoScrollTag(
  //       key: ValueKey(index),
  //       controller: controller,
  //       index: index,
  //       child: tocar(index, ListaWidget(entrada: planilla[index])));
  // }

  Widget registrar() {
    return AutoScrollTag(
        key: ValueKey(99),
        controller: controller,
        index: 99,
        child: ActionButton(
          title: error ? 'Registrar Planilla Igualmente' : 'Registrar Planilla',
          onTap: alFinalizar,
          error: error,
        ));
  }
}
