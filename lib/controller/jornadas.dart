import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:app_q/controller/participantes_totales_jornada.dart';
import '../drawer/drawer.dart';
import '../view/colores_plantilla.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class CatJornada extends StatefulWidget {
  const CatJornada({super.key});
  @override
  State<CatJornada> createState() => _CatJornadaState();
}

class _CatJornadaState extends State<CatJornada> {
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
    String uri = "${GlobalVariables().host}catalogo_jornada.php";
    try {
      var response = await http.post(Uri.parse(uri));
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        setState(() {
          userdata = jsonData;
          /*print(userdata[0]["jornada"]);*/
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
          title: const Text("Historial participantes por jornada"),
          backgroundColor: DanColors.botones,
        ),
        drawer: const DrawerMenu(),
        body: GridView.count(
          crossAxisCount: 4,
          childAspectRatio: 2.0,
          padding: const EdgeInsets.only(top: 15.0),
          children: List<Widget>.generate(userdata.length, (index) {
            return ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PartotalesJornada(
                      jornada: userdata[index]["jornada"],
                    ),
                  ),
                );
              },
              title: getContainer(
                text: userdata[index]["jornada"],
              ),
            );
          }),
        ),
      ),
    );
  }
/*
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Historial participantes"),
          backgroundColor: DanColors.botones,
        ),
        drawer: const DrawerMenu(),
        body: ListView.builder(
          itemCount: (userdata.length / 4)
              .ceil(), // Calcular la cantidad de filas necesarias
          itemBuilder: (context, rowIndex) {
            final startIndex = rowIndex * 4; // Índice inicial de cada fila
            final endIndex = startIndex + 4; // Índice final de cada fila
            final rowData = userdata.sublist(
                startIndex, endIndex); // Obtener los datos de cada fila

            return Row(
              children: rowData.map((userData) {
                return Expanded(
                  child: ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MuestraQuiniela(
                            ticket: userData["jornada"],
                          ),
                        ),
                      );
                    },
                    title: getContainer(text: userData["jornada"]),
                    leading: const Icon(
                      CupertinoIcons.text_badge_star,
                      color: Colors.blue,
                    ),
                  ),
                );
              }).toList(),
            );
          },
        ),
      ),
    );
  }*/
}
