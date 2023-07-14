import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:app_q/view/colores_plantilla.dart';

class Ganadores extends StatefulWidget {
  final String jornada;
  const Ganadores({required this.jornada, super.key});

  @override
  State<Ganadores> createState() => _GanadoresState();
}

class _GanadoresState extends State<Ganadores> {
// Obtener el primer elemento del conjunto como una cadena

  final String titulo = "Jornada";
//TRAEMOS EÑL TOKEN DEL DISPOSITIVO
  List userdata = [];
  Future<void> getrecordresultado() async {
    String uri = "${GlobalVariables().host}quiniela_ganadora.php";
    try {
      var response =
          await http.post(Uri.parse(uri), body: {'jornada': widget.jornada});
      if (response.statusCode == 200) {
        // La respuesta fue exitosa (código de estado 200)
        setState(() {
          userdata = jsonDecode(response.body);
        });
      } else {
        // Hubo un error en la respuesta
        print('Error en la respuesta: ${response.statusCode}');
      }
    } catch (e) {
      // Hubo un error en la solicitud
      print('Error en la solicitud: $e');
    }
  }

  List userdata2 = [];
  Future<void> getrecordresultado2do() async {
    String uri = "${GlobalVariables().host}quiniela_ganadora2.php";
    try {
      var response =
          await http.post(Uri.parse(uri), body: {'jornada': widget.jornada});
      if (response.statusCode == 200) {
        // La respuesta fue exitosa (código de estado 200)
        setState(() {
          userdata2 = jsonDecode(response.body);
        });
      } else {
        // Hubo un error en la respuesta
        print('Error en la respuesta: ${response.statusCode}');
      }
    } catch (e) {
      // Hubo un error en la solicitud
      print('Error en la solicitud: $e');
    }
  }

  @override
  void initState() {
    /*getrecord();*/
    getrecordresultado();
    getrecordresultado2do();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //cuento los registros de la consulta
    int totalRegistros = userdata.length;
    int totalRegistros2 = userdata2.length;
// Luego puedes mostrar el total de registros en cualquier lugar que desees, por ejemplo
    return Scaffold(
        appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: Text(
                '$titulo ${widget.jornada} -1er Lugar: $totalRegistros- 2do Lugar $totalRegistros2')),
        body: Column(
          children: [
            Expanded(
                child: ListView.builder(
              padding: const EdgeInsets.only(top: 20.0),
              itemCount: userdata.length,
              itemBuilder: (context, index) {
                return Row(children: [
                  const Padding(padding: EdgeInsets.only(top: 20.0)),
                  Container(
                      constraints: const BoxConstraints(maxWidth: 30),
                      margin: const EdgeInsets.all(10),
                      child: Text(userdata[index]["id"].toString())),
                  //.toString convierte n entero a string para pasarlo a lsita como me dio lata esto
                  Container(
                      constraints: const BoxConstraints(maxWidth: 200),
                      margin: const EdgeInsets.all(10),
                      child: Text(userdata[index]["email"])),
                  Container(
                      constraints: const BoxConstraints(maxWidth: 30),
                      margin: const EdgeInsets.all(10),
                      child: Text(userdata[index]["juego1"])),
                  Container(
                      constraints: const BoxConstraints(maxWidth: 30),
                      margin: const EdgeInsets.all(10),
                      child: Text(userdata[index]["juego2"])),
                  Container(
                      constraints: const BoxConstraints(maxWidth: 30),
                      margin: const EdgeInsets.all(10),
                      child: Text(userdata[index]["juego3"])),
                  Container(
                      constraints: const BoxConstraints(maxWidth: 30),
                      margin: const EdgeInsets.all(10),
                      child: Text(userdata[index]["juego4"])),
                  Container(
                      constraints: const BoxConstraints(maxWidth: 30),
                      margin: const EdgeInsets.all(10),
                      child: Text(userdata[index]["juego5"])),
                  Container(
                      constraints: const BoxConstraints(maxWidth: 30),
                      margin: const EdgeInsets.all(10),
                      child: Text(userdata[index]["juego6"])),
                  Container(
                      constraints: const BoxConstraints(maxWidth: 30),
                      margin: const EdgeInsets.all(10),
                      child: Text(userdata[index]["juego7"])),
                  Container(
                      constraints: const BoxConstraints(maxWidth: 30),
                      margin: const EdgeInsets.all(10),
                      child: Text(userdata[index]["juego8"])),
                  Container(
                      constraints: const BoxConstraints(maxWidth: 30),
                      margin: const EdgeInsets.all(10),
                      child: Text(userdata[index]["juego9"])),
                ]);
              },
            )),
            Expanded(
                child: ListView.builder(
              padding: const EdgeInsets.only(top: 20.0),
              itemCount: userdata2.length,
              itemBuilder: (context, index) {
                return Row(children: [
                  const Padding(padding: EdgeInsets.only(top: 20.0)),
                  Container(
                      constraints: const BoxConstraints(maxWidth: 30),
                      margin: const EdgeInsets.all(10),
                      child: Text(userdata2[index]["id"].toString())),
                  //.toString convierte n entero a string para pasarlo a lsita como me dio lata esto
                  Container(
                      constraints: const BoxConstraints(maxWidth: 200),
                      margin: const EdgeInsets.all(10),
                      child: Text(userdata2[index]["email"])),
                  Container(
                      constraints: const BoxConstraints(maxWidth: 30),
                      margin: const EdgeInsets.all(10),
                      child: Text(userdata2[index]["juego1"])),
                  Container(
                      constraints: const BoxConstraints(maxWidth: 30),
                      margin: const EdgeInsets.all(10),
                      child: Text(userdata2[index]["juego2"])),
                  Container(
                      constraints: const BoxConstraints(maxWidth: 30),
                      margin: const EdgeInsets.all(10),
                      child: Text(userdata2[index]["juego3"])),
                  Container(
                      constraints: const BoxConstraints(maxWidth: 30),
                      margin: const EdgeInsets.all(10),
                      child: Text(userdata2[index]["juego4"])),
                  Container(
                      constraints: const BoxConstraints(maxWidth: 30),
                      margin: const EdgeInsets.all(10),
                      child: Text(userdata2[index]["juego5"])),
                  Container(
                      constraints: const BoxConstraints(maxWidth: 30),
                      margin: const EdgeInsets.all(10),
                      child: Text(userdata2[index]["juego6"])),
                  Container(
                      constraints: const BoxConstraints(maxWidth: 30),
                      margin: const EdgeInsets.all(10),
                      child: Text(userdata2[index]["juego7"])),
                  Container(
                      constraints: const BoxConstraints(maxWidth: 30),
                      margin: const EdgeInsets.all(10),
                      child: Text(userdata2[index]["juego8"])),
                  Container(
                      constraints: const BoxConstraints(maxWidth: 30),
                      margin: const EdgeInsets.all(10),
                      child: Text(userdata2[index]["juego9"])),
                ]);
              },
            ))
          ],
        ));
  } /*
  @override
  Widget build(BuildContext context) {
    // Cuento los registros de la consulta
    int totalRegistros = userdata.length;
    int totalRegistros2 = userdata2.length;

    // Luego puedes mostrar el total de registros en cualquier lugar que desees, por ejemplo

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
            '$titulo ${widget.jornada} - 1er Lugar: $totalRegistros - 2do Lugar $totalRegistros2'),
      ),
      body: Column(
        // Cambiado de Row a Column
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(top: 20.0),
              itemCount: userdata.length,
              itemBuilder: (context, index) {
                return Row(
                  children: [
                    const Padding(padding: EdgeInsets.only(top: 20.0)),
                    Container(
                      constraints: const BoxConstraints(maxWidth: 30),
                      margin: const EdgeInsets.all(10),
                      child: Text(userdata[index]["id"].toString()),
                    ),
                    Container(
                      constraints: const BoxConstraints(maxWidth: 200),
                      margin: const EdgeInsets.all(10),
                      child: Text(userdata[index]["email"]),
                    ),
                    // Resto de los contenedores de userdata[index]
                  ],
                );
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(top: 20.0),
              itemCount: userdata2.length,
              itemBuilder: (context, index) {
                return Row(
                  children: [
                    const Padding(padding: EdgeInsets.only(top: 20.0)),
                    Container(
                      constraints: const BoxConstraints(maxWidth: 30),
                      margin: const EdgeInsets.all(10),
                      child: Text(userdata2[index]["id"].toString()),
                    ),
                    Container(
                      constraints: const BoxConstraints(maxWidth: 200),
                      margin: const EdgeInsets.all(10),
                      child: Text(userdata2[index]["email"]),
                    ),
                    // Resto de los contenedores de userdata2[index]
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }*/
}
