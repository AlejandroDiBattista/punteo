import 'package:flutter/material.dart';
import 'package:punteo_yb/widgets/usuario_item.dart';

import '../colores.dart';
import '../modelos/datos.dart';

class UsuariosPage extends StatefulWidget {
  @override
  State<UsuariosPage> createState() => _UsuariosPageState();
}

class _UsuariosPageState extends State<UsuariosPage> {
  var votantes = Datos.votantes;
  var cargando = false;

  @override
  void initState() {
    this.cargando = true;
    Datos.sincronizarFavoritos().then((value) => setState(() => this.cargando = false));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(title: Text('Ranking de Usuarios', style: TextStyle(fontSize: 22))),
          body: Center(child: mostrarUsuarios())),
    );
  }

  Widget mostrarUsuarios() {
    final usuarios = Datos.usuarios;

    usuarios.sort((a, b) => Datos.cantidadFavoritos(b.dni).compareTo(Datos.cantidadFavoritos(a.dni)));

    return ListView.separated(
      itemBuilder: (_, i) => UsuarioItem(usuario: usuarios[i]),
      itemCount: usuarios.length,
      separatorBuilder: (BuildContext context, int index) => Divider(color: Colores.divisor, height: 1),
    );
  }
}
