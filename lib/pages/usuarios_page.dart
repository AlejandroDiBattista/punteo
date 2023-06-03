import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/utils.dart';
import '/widgets/usuario_item.dart';

import '../colores.dart';
import '../modelos/datos.dart';
import 'ingresar_page.dart';

class UsuariosPage extends StatefulWidget {
  @override
  State<UsuariosPage> createState() => _UsuariosPageState();
}

class _UsuariosPageState extends State<UsuariosPage> {
  var cargando = false;

  @override
  void initState() {
    this.cargando = true;
    Datos.sincronizarFavoritos().then((value) => setState(() => this.cargando = false));
    super.initState();
  }

  @override
  Widget build(BuildContext context) => SafeArea(
          child: Scaffold(
        appBar: crearTitulo(Text('Ranking de Usuarios'), actions: [
          //   IconButton(
          //     onPressed: () => setState(() => this.ordenadoIngreso = !this.ordenadoIngreso),
          //     icon: Icon(Icons.sort),
          //   ),
        ]),
        body: mostrarUsuarios(),
      ));

  Widget mostrarUsuarios() {
    final usuarios = Datos.usuarios;

    usuarios.sort((a, b) => Datos.cantidadFavoritos(b.dni).compareTo(Datos.cantidadFavoritos(a.dni)));
    print('En Usuarios_page hay ${usuarios.length} usuarios');
    return ListView.separated(
      itemCount: usuarios.length,
      itemBuilder: (_, i) => InkWell(
        child: UsuarioItem(usuario: usuarios[i], index: i),
        onLongPress: () => irUsuario(usuarios[i].dni),
      ),
      separatorBuilder: (_, i) => Divider(color: Colores.divisor, height: 1),
    );
  }

  Future<void> irUsuario(int dni) async {
    Datos.usuario = dni;
    await Datos.cargar();
    Get.offAll(IngresarPage());
  }
}
