import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:app_q/view/resultados.dart';
import '../view/quiniela_ganadora.dart';
import 'historial.dart';
import 'jornadas.dart';
import 'jornadas_ganadores.dart';

class ControLLer extends StatefulWidget {
  const ControLLer({super.key});
  @override
  State<ControLLer> createState() => _ControLLerState();
}

class _ControLLerState extends State<ControLLer> {
  int indexTap = 0;
  final List<Widget> widgetsChildren = [
    const Resultados(),
    const HistorialRegistros(),
    const CatJornada(),
    const JornadaGanadores(),
    const Quinielaganadora()
  ];
  void onTapTapped(int index) async {
    setState(() {
      indexTap = index;
    });
  }

  Future<String?> obtenerToken() async {
    final storage = FlutterSecureStorage();
    return await storage.read(key: 'token');
  }

  Future<String?> validatoken() async {
    final token = await obtenerToken();
    if (token == 'vCYk9LEKmCzTjE7DmwvnPBkQZEhSQIZWkwkLcCTyw5M=') {
      return token;
    }
    return ''; // Valor por defecto en caso de token inválido
  }

/*
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widgetsChildren[indexTap],
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
            canvasColor: const Color.fromARGB(255, 8, 133, 216),
            primaryColor: const Color.fromARGB(255, 8, 4, 240)),
        child: BottomNavigationBar(
            onTap: onTapTapped,
            currentIndex: indexTap,
            backgroundColor: const Color.fromARGB(255, 36, 21, 243),
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'token'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.history_toggle_off), label: 'Historial'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.exit_to_app), label: 'Jornadas'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.emoji_events), label: 'Ganadores'),
            ]),
      ),
    );
  }*/
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widgetsChildren[indexTap],
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
            canvasColor: const Color.fromARGB(255, 8, 133, 216),
            primaryColor: const Color.fromARGB(255, 8, 4, 240)),
        child: FutureBuilder<String?>(
          //mando a llamar a la funcion
          future: validatoken(),
          builder: (context, snapshot) {
            //se crea la variable isvalidtoken si no esta vacia o es null
            final isValidToken =
                snapshot.data != null && snapshot.data!.isNotEmpty;
            return BottomNavigationBar(
              onTap: onTapTapped,
              currentIndex: indexTap,
              backgroundColor: const Color.fromARGB(255, 36, 21, 243),
              items: [
                const BottomNavigationBarItem(
                    icon: Icon(Icons.home), label: 'home'),
                const BottomNavigationBarItem(
                  icon: Icon(Icons.history_toggle_off),
                  label: 'Historial',
                ),
                const BottomNavigationBarItem(
                  icon: Icon(Icons.exit_to_app),
                  label: 'Jornadas',
                ),
                const BottomNavigationBarItem(
                  icon: Icon(Icons.emoji_events),
                  label: 'Ganadores',
                ),
                if (isValidToken)
                  const BottomNavigationBarItem(
                    icon: Icon(Icons.admin_panel_settings),
                    label: 'Admin',
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
