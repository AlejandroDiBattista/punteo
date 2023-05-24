import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../colores.dart';
import 'escuelas_page.dart';
import 'buscar_page.dart';
import 'estadisticas_page.dart';
import 'usuarios_page.dart';

import '../modelos/datos.dart';

// ignore: must_be_immutable
class PaginaInicialPage extends StatefulWidget {
  PaginaInicialPage({Key? key}) : super(key: key);
  int index = 0;

  final paginas = [
    EscuelasPage(),
    BuscarPage(),
    EstadisticasPage(),
    if (Datos.esAdministrador) UsuariosPage(),
  ];

  @override
  State<PaginaInicialPage> createState() => _PaginaInicialPageState();
}

class _PaginaInicialPageState extends State<PaginaInicialPage> {
  @override
  Widget build(BuildContext context) {
    // final color = Theme.of(context).primaryColor;
    return Scaffold(
      body: widget.paginas[widget.index],
      // bottomNavigationBar: crearNavegacion(color),
      bottomNavigationBar: crearBottomNavigations(context),
    );
  }

  Widget crearBottomNavigations(BuildContext context) {
    final activo = Colors.green.shade900; //Theme.of(context).primaryColor;
    final inactivo = Colors.green.shade500;

    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed, //Agregar esta línea
      currentIndex: widget.index,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      selectedItemColor: activo,
      unselectedItemColor: inactivo,
      backgroundColor: Colores.comenzar,
      items: [
        BottomNavigationBarItem(
          label: 'Marcar',
          icon: Icon(Icons.check, color: inactivo, size: 30),
          activeIcon: Icon(Icons.check, color: activo, size: 30),
        ),
        BottomNavigationBarItem(
          label: 'Buscar',
          icon: Icon(Icons.search, color: inactivo, size: 30),
          activeIcon: Icon(Icons.search, color: activo, size: 30),
        ),
        BottomNavigationBarItem(
          label: 'Perfil',
          icon: Icon(Icons.star, color: inactivo, size: 30),
          activeIcon: Icon(Icons.star, color: activo, size: 30),
        ),
        if (Datos.esAdministrador)
          BottomNavigationBarItem(
            label: 'Ranking',
            icon: Icon(Icons.sort, color: inactivo, size: 30),
            activeIcon: Icon(Icons.sort, color: activo, size: 30),
          ),
      ],
      onTap: (index) {
        setState(() {
          widget.index = index;
        });
      },
    );
  }

  Widget crearNavegacion(Color color) {
    return NavigationBar(
      onDestinationSelected: (index) {
        setState(() => widget.index = index);
      },
      selectedIndex: widget.index,
      destinations: [
        NavigationDestination(icon: Icon(Icons.check_rounded), label: 'Marcar'),
        NavigationDestination(icon: Icon(Icons.search_rounded), label: 'Buscar'),
        NavigationDestination(icon: Icon(Icons.person_rounded), label: 'Perfil'),
        if (Datos.esAdministrador) NavigationDestination(icon: Icon(Icons.graphic_eq_rounded), label: 'Ranking'),
      ],
    );
  }

  Widget crearNavegacionCupertino(Color color) {
    return CupertinoTabBar(
      // activeColor: Colors.white,
      // inactiveColor: Colors.black,
      // backgroundColor: color,
      iconSize: 24,
      items: [
        BottomNavigationBarItem(
            icon: Badge.count(count: 10, backgroundColor: Colors.red, child: Icon(Icons.check)),
            // icon: Badge.count(count: Datos.cantidadFavoritos(Datos.usuario), child: Icon(CupertinoIcons.checkmark_alt)),
            label: "Marcar",
            backgroundColor: color),
        BottomNavigationBarItem(icon: Icon(Icons.search), label: "Buscar", backgroundColor: color),
        BottomNavigationBarItem(icon: Icon(CupertinoIcons.person), label: "Perfil", backgroundColor: color),
        if (Datos.esAdministrador)
          BottomNavigationBarItem(icon: Icon(CupertinoIcons.graph_square), label: "Ranking", backgroundColor: color),
      ],
      currentIndex: widget.index,
      onTap: (index) {
        setState(() => widget.index = index);
      },
    );
  }

  // Widget build(BuildContext context) {
  //   final color = Theme.of(context).primaryColor;
  //   return Scaffold(
  //     body: widget.paginas[widget.index],
  //     bottomNavigationBar: BottomNavigationBar(
  //       backgroundColor: color,
  //       iconSize: 24,
  //       showSelectedLabels: true,
  //       showUnselectedLabels: true,
  //       items: [
  //         BottomNavigationBarItem(icon: Icon(Icons.person), label: "Marcar", backgroundColor: color),
  //         BottomNavigationBarItem(icon: Icon(Icons.search), label: "Buscar", backgroundColor: color),
  //         BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Perfil", backgroundColor: color),
  //         BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: "Podio", backgroundColor: color),
  //       ],
  //       currentIndex: widget.index,
  //       selectedItemColor: Colors.white,
  //       unselectedItemColor: Colors.black,
  //       onTap: (index) {
  //         setState(() => widget.index = index);
  //       },
  //     ),
  //   );
  // }

  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     body: widget.paginas[widget.index],
  //     bottomNavigationBar: Container(
  //       color: Theme.of(context).primaryColor,
  //       child: Padding(
  //         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
  //         child: GNav(
  //             gap: 8,
  //             color: Colors.white,
  //             activeColor: Colors.white,
  //             backgroundColor: Theme.of(context).primaryColor,
  //             tabBackgroundColor: Theme.of(context).primaryColorDark,
  //             iconSize: 24,
  //             padding: EdgeInsets.all(16),
  //             onTabChange: (index) {
  //               setState(() => widget.index = index);
  //             },
  //             tabs: [
  //               GButton(icon: Icons.abc, text: 'Marcar Personas'),
  //               GButton(icon: Icons.abc_outlined, text: 'Buscar Personas'),
  //               GButton(icon: Icons.ac_unit, text: 'Estadisticas'),
  //               if (Datos.esAdministrador) GButton(icon: Icons.accessible_forward, text: 'Monitor'),
  //             ]),
  //       ),
  //     ),
  //   );
  // }
}
