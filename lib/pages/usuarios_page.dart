import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:punteo_yb/utils.dart';
import 'package:punteo_yb/widgets/usuario_item.dart';

import '../colores.dart';
import '../modelos/datos.dart';
import 'ingresar_page.dart';

class UsuariosPage extends StatefulWidget {
  @override
  State<UsuariosPage> createState() => _UsuariosPageState();
}

class _UsuariosPageState extends State<UsuariosPage> {
  // var votantes = Datos.votantes;
  var cargando = false;
  var ordenadoIngreso = false;

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
          IconButton(
            onPressed: () => setState(() => this.ordenadoIngreso = !this.ordenadoIngreso),
            icon: Icon(Icons.sort),
          ),
        ]),
        body: mostrarUsuarios(),
      ));

  Widget mostrarUsuarios() {
    final usuarios = Datos.usuarios;

    usuarios.sort((a, b) => Datos.cantidadFavoritos(b.dni).compareTo(Datos.cantidadFavoritos(a.dni)));

    return ListView.separated(
      itemBuilder: (_, i) => InkWell(
        child: UsuarioItem(usuario: usuarios[i], index: i),
        onLongPress: () => irUsuario(usuarios[i].dni),
      ),
      itemCount: usuarios.length,
      separatorBuilder: (BuildContext context, int index) => Divider(color: Colores.divisor, height: 1),
    );
  }

  void irUsuario(int dni) {
    Datos.usuario = dni;
    Get.offAll(IngresarPage());
  }
}
