import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../modelos/votante.dart';
import '../widgets/boton_widget.dart';
import '../widgets/usuario_card.dart';

class VotantePage extends StatelessWidget {
  final Votante votante;
  const VotantePage({super.key, required this.votante});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text('Donde votas')),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              UsuarioCard(
                votante,
                compacto: false,
                referidos: true,
                escuela: true,
              ),
              SizedBox(height: 20),
              Boton(icon: Icons.arrow_back, label: "Cerrar", onPressed: () => Get.back())
            ],
          ),
        ),
      );
}
