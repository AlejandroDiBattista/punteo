import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
// import 'package:myapp/pages/buscar_page.dart';
import 'package:myapp/pages/escuelas_page.dart';
import 'package:myapp/pages/estadisticas_page.dart';

// import '../modelos/datos.dart';

// ignore: must_be_immutable
class PaginaInicialPage extends StatefulWidget {
  PaginaInicialPage({Key? key}) : super(key: key);
  int index = 0;
  List<Widget> paginas = [
    EscuelasPage(),
    // BuscarPage(),
    EstadisticasPage(),
  ];

  @override
  State<PaginaInicialPage> createState() => _PaginaInicialPageState();
}

class _PaginaInicialPageState extends State<PaginaInicialPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.paginas[widget.index],
      bottomNavigationBar: Container(
        color: Theme.of(context).primaryColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: GNav(
              gap: 8,
              color: Colors.white,
              activeColor: Colors.white,
              backgroundColor: Theme.of(context).primaryColor,
              tabBackgroundColor: Theme.of(context).primaryColorDark,
              iconSize: 24,
              padding: EdgeInsets.all(16),
              onTabChange: (index) {
                setState(() {
                  widget.index = index;
                });
              },
              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              // style: ,
              tabs: [
                GButton(
                  icon: Icons.check,
                  text: 'Marcar',
                ),
                // GButton(
                //   icon: Icons.search,
                //   text: 'Buscar',
                // ),
                GButton(
                  icon: Icons.bar_chart,
                  text: 'Estadisticas',
                ),
              ]),
        ),
      ),
    );
  }
}
