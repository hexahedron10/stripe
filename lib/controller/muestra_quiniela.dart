import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:app_q/view/colores_plantilla.dart';

class MuestraQuiniela extends StatefulWidget {
  final String ticket;
  const MuestraQuiniela({required this.ticket, super.key});

  @override
  State<MuestraQuiniela> createState() => _MuestraQuinielaState();
}

class _MuestraQuinielaState extends State<MuestraQuiniela> {
  final String titulo = "Historial Ticket";

  List userdata = [];
  Future<void> getrecord() async {
    String uri = "${GlobalVariables().host}plantilla_jornada.php";
    try {
      var response = await http.get(Uri.parse(uri));
      setState(() {
        userdata = jsonDecode(response.body);
      });
    } catch (e) {
      print(e);
    }
  }

//TRAEMOS EÑL TOKEN DEL DISPOSITIVO
  Future<String?> obtenerToken() async {
    final storage = FlutterSecureStorage();
    return await storage.read(key: 'token');
  }

  List userdataresultado = [];
  Future<void> getrecordresultado() async {
    String uri = "${GlobalVariables().host}historial_ticket.php";
    try {
      String? token = await obtenerToken();
      var response = await http
          .post(Uri.parse(uri), body: {'id': widget.ticket, 'token': token});

      if (token != null) {
      } else {}

      setState(() {
        userdataresultado = jsonDecode(response.body);
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    getrecord();
    getrecordresultado();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text('$titulo ${widget.ticket}')),
      body: Row(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: userdata.length,
              itemBuilder: (context, index) {
                return Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Image.asset(
                            'assets/${userdata[index]['equipo_local_img']}',
                            height: 20,
                            width: 20,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Text(userdata[index]['equipo_local']),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Image.asset(
                            'assets/${userdata[index]['equipo_visita_img']}',
                            height: 20,
                            width: 20,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Text(userdata[index]['equipo_visita']),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: userdataresultado.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Column(
                    children: [
                      Text(userdataresultado[index]['juego1']),
                      Text(userdataresultado[index]['juego2']),
                      Text(userdataresultado[index]['juego3']),
                      Text(userdataresultado[index]['juego4']),
                      Text(userdataresultado[index]['juego5']),
                      Text(userdataresultado[index]['juego6']),
                      Text(userdataresultado[index]['juego7']),
                      Text(userdataresultado[index]['juego8']),
                      Text(userdataresultado[index]['juego9']),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
