import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../drawer/drawer.dart';
import '../view/colores_plantilla.dart';
import 'muestra_quiniela.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class HistorialRegistros extends StatefulWidget {
  const HistorialRegistros({super.key});
  @override
  State<HistorialRegistros> createState() => _HistorialRegistrosState();
}

class _HistorialRegistrosState extends State<HistorialRegistros> {
//traer el token por usuario para mostar su historial//
// Obtener el token almacenado
  Future<String?> obtenerToken() async {
    final storage = FlutterSecureStorage();
    String? token = await storage.read(key: 'token');
    return token;
  }

  List userdata = [];
  Future<void> getRecord() async {
// obtengo el token de la funcion obtenerToken guardado en el dispositivo
    String? token = await obtenerToken();

    String uri = "${GlobalVariables().host}historial.php";
    try {
      var response = await http.post(Uri.parse(uri), body: {
        'token': token ??
            '', // Asegúrate de manejar el caso en el que token sea nulo
      });
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        setState(() {
          userdata = jsonData;
        });
      } else {
        print('Error en la solicitud: ${response.statusCode}');
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    getRecord();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          appBar: AppBar(
            title: const Text("Historial"),
            backgroundColor: DanColors.botones,
          ),
          drawer: const DrawerMenu(),
          body: ListView.builder(
              itemCount: userdata.length,
              itemBuilder: (context, index) {
                return Container(
                  /*decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 191, 197, 202)
                      // Establece el radio de borde para hacerlo redondeado
                      ),
                  padding: const EdgeInsets.all(10.0),*/
                  // Establece el relleno interno
                  child: ListTile(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  MuestraQuiniela(ticket: userdata[index]["id"]
                                      /*id: userdata[index]["id"])),*/
                                      )));

                      // Lógica del onTap
                    },
                    title: Row(
                      children: [
                        Container(
                          constraints: const BoxConstraints(maxWidth: 30),
                          margin: const EdgeInsets.all(10),
                          child: Text(userdata[index]["id"]),
                        ),
                        Container(
                          constraints: const BoxConstraints(maxWidth: 30),
                          margin: const EdgeInsets.all(10),
                          child: Text(userdata[index]["juego1"]),
                        ),
                        Container(
                          constraints: const BoxConstraints(maxWidth: 30),
                          margin: const EdgeInsets.all(10),
                          child: Text(userdata[index]["juego2"]),
                        ),
                        Container(
                          constraints: const BoxConstraints(maxWidth: 30),
                          margin: const EdgeInsets.all(10),
                          child: Text(userdata[index]["juego3"]),
                        ),
                        Container(
                          constraints: const BoxConstraints(maxWidth: 30),
                          margin: const EdgeInsets.all(10),
                          child: Text(userdata[index]["juego4"]),
                        ),
                        Container(
                          constraints: const BoxConstraints(maxWidth: 30),
                          margin: const EdgeInsets.all(10),
                          child: Text(userdata[index]["juego5"]),
                        ),
                        Container(
                          constraints: const BoxConstraints(maxWidth: 30),
                          margin: const EdgeInsets.all(10),
                          child: Text(userdata[index]["juego6"]),
                        ),
                        Container(
                          constraints: const BoxConstraints(maxWidth: 30),
                          margin: const EdgeInsets.all(10),
                          child: Text(userdata[index]["juego7"]),
                        ),
                        Container(
                          constraints: const BoxConstraints(maxWidth: 30),
                          margin: const EdgeInsets.all(10),
                          child: Text(userdata[index]["juego8"]),
                        ),
                        Container(
                          constraints: const BoxConstraints(maxWidth: 30),
                          margin: const EdgeInsets.all(10),
                          child: Text(userdata[index]["juego9"]),
                        ),
                        // Agrega los demás widgets Container aquí
                      ],
                    ),
                    leading: const Icon(
                      CupertinoIcons.text_badge_star,
                      color: Colors.blue,
                    ),
                  ),
                );
              })),
    );
  }
}  
                    /*
          Row(
            children: [
              Container(
                constraints: const BoxConstraints(maxWidth: 30),
                margin: const EdgeInsets.all(10),
                child: Text(userdata[index]["id"]),
              ),
              Container(
                constraints: const BoxConstraints(maxWidth: 30),
                margin: const EdgeInsets.all(10),
                child: Text(userdata[index]["juego1"]),
              ),
              Container(
                constraints: const BoxConstraints(maxWidth: 30),
                margin: const EdgeInsets.all(10),
                child: Text(userdata[index]["juego2"]),
              ),
              Container(
                constraints: const BoxConstraints(maxWidth: 30),
                margin: const EdgeInsets.all(10),
                child: Text(userdata[index]["juego3"]),
              ),
              Container(
                constraints: const BoxConstraints(maxWidth: 30),
                margin: const EdgeInsets.all(10),
                child: Text(userdata[index]["juego4"]),
              ),
              Container(
                constraints: const BoxConstraints(maxWidth: 30),
                margin: const EdgeInsets.all(10),
                child: Text(userdata[index]["juego5"]),
              ),
              Container(
                constraints: const BoxConstraints(maxWidth: 30),
                margin: const EdgeInsets.all(10),
                child: Text(userdata[index]["juego6"]),
              ),
              Container(
                constraints: const BoxConstraints(maxWidth: 30),
                margin: const EdgeInsets.all(10),
                child: Text(userdata[index]["juego7"]),
              ),
              Container(
                constraints: const BoxConstraints(maxWidth: 30),
                margin: const EdgeInsets.all(10),
                child: Text(userdata[index]["juego8"]),
              ),
              Container(
                constraints: const BoxConstraints(maxWidth: 30),
                margin: const EdgeInsets.all(10),
                child: Text(userdata[index]["juego9"]),
              ),
              Expanded(
                // Ancho fijo para el ListTile
                child: ListTile(
                  onTap: () {
                    //paso a
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                MuestraQuiniela(ticket: userdata[index]["id"]
                                    /*id: userdata[index]["id"])),*/
                                    )));
                  },
                  title: Text(userdata[index]["id"]),
                  leading: const Icon(
                    CupertinoIcons.at_badge_minus,
                    color: Colors.amber,
                  ),
                ),
              ),
*/
              /*
              Expanded(
                  child: Container(
                margin: const EdgeInsets.all(10),
                child: Text(userdata[index]["juego1"]),
              )),
              Expanded(
                  child: Container(
                margin: const EdgeInsets.all(10),
                child: Text(userdata[index]["juego2"]),
              )),
              Expanded(
                  child: Container(
                margin: const EdgeInsets.all(10),
                child: Text(userdata[index]["juego3"]),
              )),
              Expanded(
                  child: Container(
                margin: const EdgeInsets.all(10),
                child: Text(userdata[index]["juego4"]),
              )),
              Expanded(
                  child: Container(
                margin: const EdgeInsets.all(10),
                child: Text(userdata[index]["juego5"]),
              )),
              Expanded(
                  child: Container(
                margin: const EdgeInsets.all(10),
                child: Text(userdata[index]["juego6"]),
              )),
              Expanded(
                  child: Container(
                margin: const EdgeInsets.all(10),
                child: Text(userdata[index]["juego7"]),
              )),
              Expanded(
                  child: Container(
                margin: const EdgeInsets.all(10),
                child: Text(userdata[index]["juego8"]),
              )),
              Expanded(
                  child: Container(
                margin: const EdgeInsets.all(10),
                child: Text(userdata[index]["juego9"]),
              )),*/
          
/*
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'muestra_quiniela.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:indu/controller/controller.dart';

class HistorialRegistros extends StatefulWidget {
  const HistorialRegistros({Key? key}) : super(key: key);

  @override
  State<HistorialRegistros> createState() => _HistorialRegistrosState();
}

class _HistorialRegistrosState extends State<HistorialRegistros> {
  // Traer el token por usuario para mostrar su historial
  // Obtener el token almacenado
  Future<String?> obtenerToken() async {
    final storage = FlutterSecureStorage();
    String? token = await storage.read(key: 'token');
    return token;
  }

  List userdata = [];

  Future<void> getRecord() async {
    // Obtengo el token de la función obtenerToken guardado en el dispositivo
    String? token = await obtenerToken();

    String uri = "http://localhost/flutter/historial.php";
    try {
      var response = await http.post(Uri.parse(uri), body: {
        'token': token ?? '', // Asegúrate de manejar el caso en el que token sea nulo
      });
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        setState(() {
          userdata = jsonData;
        });
      } else {
        print('Error en la solicitud: ${response.statusCode}');
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    getRecord();
    super.initState();
  }

  Widget customListTile(String id) {
    return GestureDetector(
      onTap: () {
        // Acción al hacer clic en el widget
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MuestraQuiniela(ticket: id),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            const Icon(
              CupertinoIcons.at_badge_minus,
              color: Colors.amber,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(id),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Historial")),
      body: ListView.builder(
        itemCount: userdata.length,
        itemBuilder: (context, index) {
          return customListTile(userdata[index]["id"]);
        },
      ),
    );
  }
}
*/
