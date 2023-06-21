import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/colores.dart';
import '/modelos/datos.dart';
import '/modelos/usuario.dart';
import '/utils.dart';
import '/widgets/usuario_item.dart';
import 'menu_page.dart';

class UsuariosPage extends StatefulWidget {
  @override
  State<UsuariosPage> createState() => _UsuariosPageState();
}

class _UsuariosPageState extends State<UsuariosPage> {
  int completos = 0;
  bool porVotantes = false;
  Usuarios usuarios = [];

  @override
  void initState() {
    Datos.sincronizarPrioridad().then((_) {
      Datos.calcularRanking();
      usuarios = Datos.rankeados.where((u) => u.cantidadFavoritos >= 10).toList();
      actualizar();
    });
    super.initState();
  }

  void actualizar() => setState(() {});

  void cambiarOrden() {
    porVotantes = !porVotantes;
    actualizar();
  }

  @override
  Widget build(BuildContext context) => SafeArea(
      child: Scaffold(
          appBar: crearTitulo(Text('Ranking de Usuarios'), actions: [
            IconButton(onPressed: cambiarOrden, icon: Icon(porVotantes ? Icons.people : Icons.table_restaurant)),
          ]),
          body: usuarios.length == 0 ? Center(child: CircularProgressIndicator()) : mostrarUsuarios()));

  Widget mostrarUsuarios() {
    if (porVotantes) {
      usuarios.sort((a, b) => b.cantidadFavoritos.compareTo(a.cantidadFavoritos));
      completos = 0;
    } else {
      usuarios.sort((a, b) {
        if (a.mesasPendientes == b.mesasPendientes) return b.cantidadFavoritos.compareTo(a.cantidadFavoritos);
        return a.mesasPendientes.compareTo(b.mesasPendientes);
      });
      completos = usuarios.where((u) => u.mesasPendientes == 0).length;
    }

    return ListView.separated(
      itemCount: usuarios.length,
      itemBuilder: (_, i) => InkWell(
        child: UsuarioItem(usuario: usuarios[i], index: i - completos),
        onLongPress: () => irUsuario(usuarios[i].dni),
      ),
      separatorBuilder: (_, i) => Divider(color: Colores.divisor, height: 1),
    );
  }

  void listarUsuarios(Usuarios usuarios) {
    print('En Usuarios_page hay ${usuarios.length} usuarios');
    usuarios.asMap().entries.forEach((e) => print(
        ' - ${e.key + 1} ${e.value} > v: ${e.value.cantidadFavoritos} / ${e.value.cantidadAnalizados} | m: ${e.value.mesasPendientes} + ${e.value.mesasCerradas} '));
  }

  Future<void> irUsuario(int dni) async {
    Datos.usuario = dni;
    await Datos.sincronizarTodo();
    Get.offAll(MenuPage());
  }
}
