import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../modelos/datos.dart';
import '../modelos/pregunta.dart';
import '../utils.dart';

class EncuestaPage extends StatefulWidget {
  const EncuestaPage({super.key});

  @override
  _EncuestaPageState createState() => _EncuestaPageState();
}

class _EncuestaPageState extends State<EncuestaPage> {
  int actual = 0;
  List<int> respuestas = [];

  List<Pregunta> preguntas = Datos.preguntas;
  @override
  @override
  void initState() {
    preguntas.forEach((element) => respuestas.add(0));
    super.initState();
  }

  void actualizar() => setState(() {});

  void seleccionarRespuesta(int respuesta) {
    respuestas[actual] = (respuestas[actual] == respuesta) ? 0 : respuesta;
    if (respuestas[actual] > 0) {
      avanzarPregunta();
    }
    actualizar();
  }

  void retrocederPregunta() {
    if (actual > 0) {
      actual--;
    }
    actualizar();
  }

  void avanzarPregunta() {
    if (respuestas[actual] > 0) {
      if (actual < preguntas.length - 1) actual++;
    }
    actualizar();
  }

  void finalizarEncuesta() {
    Datos.guardarRespuestas(respuestas);
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    final pregunta = preguntas[actual];
    final respuestas = pregunta.respuestas;

    return Scaffold(
      appBar: crearTitulo(Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Encuesta'),
          Text('${actual + 1} de ${preguntas.length}', style: const TextStyle(fontSize: 15)),
        ],
      )),
      body: Container(
        decoration: crearFondo(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            buildDescripcion(pregunta),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: respuestas.asMap().entries.map((item) => buildRespuesta(item.value, item.key)).toList(),
            ),
            buildNavegacion(),
          ],
        ),
      ),
    );
  }

  Widget buildNavegacion() {
    final esUltimaPregunta = actual == preguntas.length - 1;
    final conRespuesta = respuestas[actual] > 0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
      child: Row(
        mainAxisAlignment: actual > 0 ? MainAxisAlignment.spaceBetween : MainAxisAlignment.end,
        children: [
          if (actual > 0)
            SizedBox(
              width: 120,
              child: OutlinedButton(onPressed: retrocederPregunta, child: const Text('Anterior')),
            ),
          SizedBox(height: 32),
          if (conRespuesta && !esUltimaPregunta)
            SizedBox(
              width: 120,
              child: OutlinedButton(onPressed: avanzarPregunta, child: Text('Siguiente')),
            ),
          if (conRespuesta && esUltimaPregunta)
            SizedBox(
              width: 120,
              child: FilledButton(
                  onPressed: finalizarEncuesta,
                  child: Text('Finalizar', style: TextStyle(fontWeight: FontWeight.bold))),
            ),
        ],
      ),
    );
  }

  Widget buildDescripcion(Pregunta pregunta) {
    return Expanded(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            pregunta.descripcion,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Widget buildRespuesta(String respuesta, int i) {
    final bool seleccionado = (actual < respuestas.length) && (respuestas[actual] == i + 1);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ElevatedButton(
        onPressed: () => seleccionarRespuesta(i + 1),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              respuesta.split("|").first,
              style: TextStyle(fontSize: 18, color: (seleccionado ? Colors.red : null)),
            ),
          ),
        ),
      ),
    );
  }
}
