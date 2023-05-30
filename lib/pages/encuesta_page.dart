import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../colores.dart';
import '../modelos/pregunta.dart';
import '../utils.dart';
// import 'package:get/get.dart';
// import 'package:cached_network_image/cached_network_image.dart';

// import 'pregunta_view.dart';

class EncuestaPage extends StatefulWidget {
  const EncuestaPage({super.key});

  @override
  _EncuestaPageState createState() => _EncuestaPageState();
}

class _EncuestaPageState extends State<EncuestaPage> {
  int currentIndex = 0;
  List<String> resultados = [];

  List<Pregunta> preguntas = Pregunta.ejemplos;

  void seleccionarRespuesta(String respuesta) {
    setState(() {
      resultados.add(respuesta);
      if (currentIndex < preguntas.length - 1) {
        currentIndex++;
      }
    });
  }

  void retrocederPregunta() {
    if (currentIndex > 0) {
      setState(() {
        currentIndex--;
      });
    }
  }

  void finalizarEncuesta() {
    // Aquí puedes realizar acciones con los resultados de la encuesta
    Get.back();
    debugPrint('Resultados de la encuesta: $resultados');
  }

  @override
  Widget build(BuildContext context) {
    final preguntaActual = preguntas[currentIndex];
    final esUltimaPregunta = currentIndex == preguntas.length - 1;

    return Scaffold(
      appBar: crearTitulo(Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Encuesta'),
          Text(
            '${currentIndex + 1} de ${preguntas.length}',
            style: const TextStyle(fontSize: 15),
          ),
        ],
      )),
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
          colors: [Colores.comenzar, Colores.terminar],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        )),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // if (preguntaActual.imagen != null) buildImagen(preguntaActual),
            buildDescripcion(preguntaActual),
            // const Spacer(),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: preguntaActual.respuestas.map((respuesta) => buildRespuesta(respuesta)).toList(),
            ),
            buildNavegacion(esUltimaPregunta),
          ],
        ),
      ),
    );
  }

  Padding buildNavegacion(bool esUltimaPregunta) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
      child: Row(
        mainAxisAlignment: currentIndex > 0 ? MainAxisAlignment.spaceBetween : MainAxisAlignment.end,
        children: [
          if (currentIndex > 0)
            SizedBox(
              width: 120,
              child: FilledButton(
                onPressed: retrocederPregunta,
                child: const Text('Anterior'),
              ),
            ),
          SizedBox(
            width: 120,
            child: FilledButton(
              onPressed: esUltimaPregunta ? finalizarEncuesta : () {},
              child: Text(esUltimaPregunta ? 'Finalizar' : 'Siguiente'),
            ),
          ),
        ],
      ),
    );
  }

  Image buildImagen(Pregunta preguntaActual) {
    return Image.network(
      preguntaActual.imagen!,
      width: double.infinity,
      height: 200,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
    );
  }

  Expanded buildDescripcion(Pregunta preguntaActual) {
    return Expanded(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Text(
            preguntaActual.descripcion,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Widget buildRespuesta(String respuesta) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
      child: OutlinedButton(
        onPressed: () => seleccionarRespuesta(respuesta),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Text(
              respuesta,
              style: const TextStyle(fontSize: 18),
            ),
          ),
        ),
      ),
    );
  }
}
