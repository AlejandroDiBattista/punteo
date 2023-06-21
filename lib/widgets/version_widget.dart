import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../modelos/datos.dart';

class Version extends StatelessWidget {
  const Version({super.key});

  @override
  Widget build(BuildContext context) => Center(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text("Versión ${Datos.version} @ ${Datos.cuando}",
            style: TextStyle(fontSize: 14, color: Get.theme.primaryColor)),
      ));
}
