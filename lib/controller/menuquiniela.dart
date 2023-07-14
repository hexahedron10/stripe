import 'package:flutter/material.dart';
import 'package:app_q/controller/controller.dart';
import 'package:app_q/view/colores_plantilla.dart';
import '../drawer/drawer.dart';

void main() => runApp(const MyQuinielamenu());

class MyQuinielamenu extends StatefulWidget {
  const MyQuinielamenu({super.key});
  @override
  State<MyQuinielamenu> createState() => _MyQuinielamenuState();
}

class _MyQuinielamenuState extends State<MyQuinielamenu> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Juegos'),
        ),
        drawer: const DrawerMenu(),
        body: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              getContainermenu(
                imagen: 'assets/MX_logo.png',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ControLLer()),
                    /*MaterialPageRoute(builder: (context) => const ControLLer()),*/
                  );
                  // Acción al hacer clic en "MX"
                  print("Clic en MX");
                },
              ), /*
              getContainermenu(
                imagen: 'assets/mls-logo-0.png',
                onTap: () {
                  // Acción al hacer clic en "MLS"
                  print("Clic en MLS");
                },
              ),
              getContainermenu(
                imagen: 'assets/NFL.png',
                onTap: () {
                  // Acción al hacer clic en "NFL"
                  print("Clic en NFL");
                },
              ),
              getContainermenu(
                imagen: 'assets/champions.png',
                onTap: () {
                  // Acción al hacer clic en "CHAMPIONS"
                  print("Clic en CHAMPIONS");
                },
              ),*/
            ],
          ),
        ),
      ),
    );
  }
}
