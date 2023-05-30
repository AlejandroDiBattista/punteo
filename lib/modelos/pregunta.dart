import 'dart:convert';

typedef Preguntas = List<Pregunta>;

class Pregunta {
  String id;
  String? imagen;
  String descripcion;
  List<String> respuestas;

  Pregunta({required this.id, this.imagen, required this.descripcion, required this.respuestas});

  Pregunta copyWith({String? id, String? imagen, String? descripcion, List<String>? respuestas}) => Pregunta(
        id: id ?? this.id,
        imagen: imagen ?? this.imagen,
        descripcion: descripcion ?? this.descripcion,
        respuestas: respuestas ?? this.respuestas,
      );

  Map<String, dynamic> toMap() => {'id': id, 'imagen': imagen, 'descripcion': descripcion, 'respuestas': respuestas};

  factory Pregunta.fromMap(Map<String, dynamic> map) => Pregunta(
      id: map['id'] ?? '',
      imagen: map['imagen'],
      descripcion: map['descripcion'] ?? '',
      respuestas: List<String>.from(map['respuestas']));

  String toJson() => json.encode(toMap());

  factory Pregunta.fromJson(String source) => Pregunta.fromMap(json.decode(source));

  @override
  String toString() => 'Pregunta(id: $id, imagen: $imagen, descripcion: $descripcion, respuestas: $respuestas)';

  @override
  bool operator ==(Object other) => identical(this, other) || other is Pregunta && other.id == id;

  @override
  int get hashCode => id.hashCode ^ imagen.hashCode ^ descripcion.hashCode ^ respuestas.hashCode;

  static Preguntas ejemplos = [
    Pregunta(
      id: "P1",
      imagen: imagen1,
      descripcion: "¿Qué partido votará?",
      respuestas: ["✌🏼 Peronimos | P2 ", "🦾 Junto por el cambio | P2 ", "🦁 Milei | P3"],
    ),
    Pregunta(
      id: "P2",
      imagen: imagen1,
      descripcion: "¿Son demasiadas opciones?",
      respuestas: ["Uno", "Dos", "Tres", "Cuatro", "Cinco", "Seis"],
    ),
    Pregunta(
      id: "P3",
      imagen: imagen2,
      descripcion:
          "¿Es acaso la pregunta demasiado larga, es decir que tiene un texto muy largo y dificil de leer pór la cantidad de texto que tiene?",
      respuestas: ["👍🏼 Si", "👎🏼 No"],
    ),
    Pregunta(
      id: "P4",
      imagen: imagen2,
      descripcion: "¿Cual es tu color favorito?",
      respuestas: ["Rojo", "Azul", "Amarillo", "Verde", "Rosa", "Celeste"],
    )
  ];
}

const imagen1 =
    "https://www.concordia.gob.ar/sites/default/files/partidos%20politicos.png";
const imagen2 = "https://img.freepik.com/vector-premium/simbolo-me-gusta-no-me-gusta-estilo-corte-papel_156780-48.jpg";
