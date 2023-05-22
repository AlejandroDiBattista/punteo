import 'package:flutter/material.dart';

import '../colores.dart';
import '../widgets/progreso_widget.dart';
import '/modelos/votante.dart';
import '../modelos/datos.dart';
import '../modelos/favorito.dart';

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
      itemBuilder: (_, i) => mostrarUsuario(usuarios[i]),
      itemCount: usuarios.length,
      separatorBuilder: (BuildContext context, int index) => Divider(color: Colores.divisor, height: 1),
    );
  }

  Padding mostrarUsuario(Votante usuario) {
    final sesiones = Favorito.calcularSesiones(usuario.dni);
    final tiempo = Favorito.calcularMinutosTrabajado(usuario.dni);
    final activo = Favorito.calcularUsuarioActivo(usuario.dni);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${usuario.nombre}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text('${Datos.cantidadFavoritos(usuario.dni)} favoritos',
                  style: TextStyle(fontSize: 14, color: Colors.cyan)),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text('DNI ${usuario.dni} - ${usuario.domicilio} '),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text("${sesiones.length} sesiones, $tiempo minutos ${activo ? '(activo)' : ''}",
                style: TextStyle(fontSize: 16, color: Colors.cyan)),
          ),
        ],
      ),
    );
  }
}
