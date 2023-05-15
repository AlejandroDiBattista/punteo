import 'package:flutter/material.dart';

class BuscarPage extends StatelessWidget {
  const BuscarPage({key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Buscar')),
      body: Center(
        child: Column(
          children: [
            Text(
              'Buscar',
              style: TextStyle(fontSize: 50),
            ),
            Text(
              'Función no implementada aún :)',
              style: TextStyle(fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }
}
