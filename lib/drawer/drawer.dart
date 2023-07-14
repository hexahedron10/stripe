import 'package:flutter/material.dart';
import 'package:app_q/main.dart';
import 'package:app_q/view/colores_plantilla.dart';
import 'comentarios.dart';
import 'perfil.dart';

class DrawerMenu extends StatefulWidget {
  const DrawerMenu({Key? key}) : super(key: key);
  @override
  _DrawerMenuState createState() => _DrawerMenuState();
}

class _DrawerMenuState extends State<DrawerMenu> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      // Contenido del Drawer
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            padding: EdgeInsetsDirectional.all(15.0),
            decoration: BoxDecoration(
                image: DecorationImage(image: AssetImage("assets/estadio.png")),
                color: DanColors.botones),
            child: Text(
              'Bienvenidos',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),

          ListTile(
            leading: const Icon(
              Icons.person,
              color: DanColors.botones,
            ),
            title: const Text('Perfil'),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const Perfil()));

              // Acción al seleccionar la opción de inicio
            },
          ),
          ListTile(
            leading: const Icon(Icons.comment, color: DanColors.botones),
            title: const Text('Comentarios'),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const Comentarios()));
              // Acción al seleccionar la opción de configuración
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.question_mark,
              color: DanColors.botones,
            ),
            title: const Text('Preguntas Frecuentes'),
            onTap: () {
              // Acción al seleccionar la opción de configuración
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.person_pin_circle,
              color: DanColors.botones,
            ),
            title: const Text('Compartir'),
            onTap: () {
              // Acción al seleccionar la opción de configuración
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.person_pin_circle,
              color: DanColors.botones,
            ),
            title: const Text('Salir'),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const MyApp()));
              // Acción al seleccionar la opción de configuración
              // Acción al seleccionar la opción de configuración
            },
          ),
          // Agrega más opciones del Drawer según tus necesidades
        ],
      ),
    );
  }
}
