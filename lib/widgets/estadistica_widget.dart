import 'package:flutter/material.dart';

import '../modelos/datos.dart';
import 'indicador_widget.dart';

class EstadisticaUsuario extends StatelessWidget {
  const EstadisticaUsuario({super.key});

  @override
  Widget build(BuildContext context) {
    // final marcados = Datos.buscar('favoritos').length.toDouble();
    final favoritos = Datos.buscar('favoritos ubicable').length.toDouble();
    final entregados = Datos.buscar('entregado').length.toDouble();
    return Container(
      width: 380,
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Indicador(etiqueta: 'Pendientes', valor: favoritos - entregados),
          Indicador(etiqueta: 'Entregados', valor: entregados),
          Indicador(etiqueta: 'Avance', valor: entregados / favoritos),
        ],
      ),
    );
  }
}
