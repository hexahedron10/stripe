import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../controller/muestra_juego.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'colores_plantilla.dart';

class Resultados extends StatefulWidget {
  const Resultados({Key? key}) : super(key: key);
  @override
  State<Resultados> createState() => _ResultadosState();
}

class _ResultadosState extends State<Resultados> {
//obtiene el token guardado en el dispositivo
  Future<String?> obtenerToken() async {
    final storage = FlutterSecureStorage();
    return await storage.read(key: 'token');
  }

  Future<String?> validaemail() async {
    final token = await obtenerToken();
    String uri = "${GlobalVariables().host}trae_email.php";
    var res = await http.post(Uri.parse(uri), body: {'token': token});
    var response = jsonDecode(res.body);
    if (response["success"] == true) {
      // Obtener el token de la respuesta
      String? email = response["email"];
      return email;
    }
  }

// utilizar el token en una solicitud
/*
  Future<void> hacerSolicitudConToken() async {
    String? token = await obtenerToken();
    String dan = "que buen pp";

    if (token != null) {
      print('$dan + $token');
      // Realizar la solicitud utilizando el token
      // Aquí puedes agregar el encabezado 'Authorization' con el token en tus solicitudes HTTP
      // Ejemplo:
      // headers: {'Authorization': 'Bearer $token'}
    } else {
      print('que pasa con esto del token');
      // El token no está disponible, maneja el caso en consecuencia
    }
  }
*/
  //se inicializa el valor de la variable en vacio
  String selectedOption = '';
  String selectedOptions = '';
// Actualizar propiedad selectedOption para que fucione la casilla de option
  void onOptionSelected(int index, String? value) {
    setState(() {
//juega con el valor local empate visita    value! indica que no puede ser nulo
      userdata[index]['selectedOption'] = value!;
    });
  }

  Future<void> insertaresultado(BuildContext context) async {
    String jornada = "";
    List<String?> selectedOptions = [
      for (var item in userdata) item['selectedOption']
    ];

    try {
      String uri = "${GlobalVariables().host}resultados.php";

      var body = {};
      // Validar si los elementos de selectedOptions son nulos o una cadena vacía
      // se crea el for par recorrer la opciones selectedOptions.length checacuants opcioes
      //hay en la lista que debes de ser nuevo juegos
      for (int i = 0; i < selectedOptions.length; i++) {
        if (selectedOptions[i]?.isNotEmpty == true) {
          body['juego${i + 1}'] = selectedOptions[i]!;
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('El juego ${i + 1} está vacío'),
            ),
          );
          return; // salimos de la función si el valor es nulo o una cadena vacía
        }
      }
      if (selectedOptions[1]?.isEmpty == false)
        body['juego2'] = selectedOptions[1]!;
      if (selectedOptions[2]?.isEmpty == false)
        body['juego3'] = selectedOptions[2]!;
      if (selectedOptions[3]?.isEmpty == false)
        body['juego4'] = selectedOptions[3]!;
      if (selectedOptions[4]?.isEmpty == false)
        body['juego5'] = selectedOptions[4]!;
      if (selectedOptions[5]?.isEmpty == false)
        body['juego6'] = selectedOptions[5]!;
      if (selectedOptions[6]?.isEmpty == false)
        body['juego7'] = selectedOptions[6]!;
      if (selectedOptions[7]?.isEmpty == false)
        body['juego8'] = selectedOptions[7]!;
      if (selectedOptions[8]?.isEmpty == false)
        body['juego9'] = selectedOptions[8]!;
//inserta la jornada
      if (userdata.isNotEmpty) {
        body['jornada'] = userdata[0]['jornada'];
      }
      String? token = await obtenerToken();
      if (token != null) {
        body['token'] = token;
      } else {
        print('tu base de datos o tiene token');
        // El token no está disponible, maneja el caso en consecuencia
      }
      String? email = await validaemail();
      if (email != null) {
        body['email'] = email;
      } else {
        print('tu base de datos no tiene email');
        // El token no está disponible, maneja el caso en consecuencia
      }
      var res = await http.post(Uri.parse(uri), body: body);
      var response = jsonDecode(res.body);
      if (response["success"] == true) {
        print('se insertaron Goooooooodddd');
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MuestraJuego()),
        );
      } else {
        print('No se inserto nada');
      }
    } catch (e) {
      print("que pasa aqui");
    }
  }

  //TRAE LA LISTA DE LA JORNADA DE LA BASE DE DATOS
  List userdata = [];

  Future<void> getrecord() async {
    String uri = "${GlobalVariables().host}plantilla_jornada.php";
    try {
      var response = await http.get(Uri.parse(uri));
      setState(() {
        userdata = jsonDecode(response.body);
        final String jornada = userdata[0][
            'jornada']; // Obtengo  el valor de "jornada" del primer objeto en "userdata"
        for (var item in userdata) {
          item['selectedOption'] = ''; // Agregar propiedad selectedOption
        }
      });
    } catch (e) {
      print(e);
    }
  }

/////////////////////////////////////////////////////
//traer el usuario  y validarlo con el token
/*
  Future<void> validateEmail() async {
    List<Map<String, dynamic>> userdata =
        []; // Necesitas inicializar userdata como una lista vacía o con datos

    Future<String?> obtenerToken() async {
      final storage = FlutterSecureStorage();
      return await storage.read(key: 'token');
    }

    String? token = await obtenerToken();
    String uri = "http://localhost/flutter/email.php";
    var res = await http.post(Uri.parse(uri), body: {'token': token});
    var response = jsonDecode(res.body);
    if (response["success"] == true) {
      final String userdatamail = userdata[0]['email'];
      print(userdatamail);
    } else {
      print('no trae nada');
    }
  }
*/
////////////////////////////////////////////////////
  @override
  void initState() {
    getrecord();
    /*validateEmail();*/
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
        title: const Text("Jornada"),
        backgroundColor: DanColors.botones,
      ),
      //SE MANDA A LLAMAR AL MENU DRAWER HECHO POR SEPARADO
      /*drawer: const DrawerMenuderecho(),*/
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Row(
              children: [
                Expanded(
                  child: Text('Local'),
                ),
                Expanded(
                  child: Text('empate'),
                ),
                Expanded(
                  child: Text('Vsita'),
                ),
              ],
            ),
            Expanded(
              child: ListView.builder(
                itemCount: userdata.length,
                itemBuilder: (BuildContext context, int index) {
                  return Row(
                    children: [
                      Row(
                        children: [Text("${userdata[index]['id'] + ".-"}")],
                      ),
                      // EMPEIZA LA OPCION DE LOCAL
                      Container(
                        constraints: const BoxConstraints(
                            maxWidth:
                                30), // Establece un ancho máximo para el contenedor
                        child: RadioListTile(
                          value: 'L',
                          groupValue: userdata[index]['selectedOption'],
                          onChanged: (value) =>
                              onOptionSelected(index, value as String?),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        constraints: const BoxConstraints(maxWidth: 30),
                        child: Image.asset(
                          'assets/${userdata[index]['equipo_local_img']}',
                          height: 25,
                          width: 25,
                        ), // Establece un ancho m
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        /*constraints: const BoxConstraints(maxWidth: 10),*/
                        child: Text("${userdata[index]['equipo_local']}"),
                      ),
                      // EMPEIZA LA OPCION DE EMPATE
                      Container(
                        constraints: const BoxConstraints(
                            maxWidth:
                                30), // Establece un ancho máximo para el contenedor
                        child: RadioListTile(
                          value: 'E',
                          groupValue: userdata[index]['selectedOption'],
                          onChanged: (value) =>
                              onOptionSelected(index, value as String?),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        constraints: const BoxConstraints(maxWidth: 30),
                        child: Image.asset(
                          'assets/${userdata[index]['equipo_visita_img']}',
                          height: 25,
                          width: 25,
                        ), // Establece un ancho m
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        /*constraints: const BoxConstraints(maxWidth: 10),*/
                        child: Text("${userdata[index]['equipo_visita']}"),
                      ),
                      const SizedBox(width: 10),
                      //EMPIZA LA OPCION  DE VISITA
                      Container(
                        constraints: const BoxConstraints(
                            maxWidth:
                                30), // Establece un ancho máximo para el contenedor
                        child: RadioListTile(
                          value: 'V',
                          groupValue: userdata[index]['selectedOption'],
                          onChanged: (value) =>
                              onOptionSelected(index, value as String?),
                        ),
                      ),
                    ],
                  );

                  /*
                  Row(
                    children: [
                      Expanded(
                        child: RadioListTile(
                          title: Row(children: [
                            Expanded(
                                child: Image.asset(
                              'assets/${userdata[index]['equipo_local_img']}',
                              height: 20,
                              width: 20,
                            )),
                            Expanded(
                              child: Text("${userdata[index]['equipo_local']}"),
                            ),
                          ]),
                          value: 'L',
                          groupValue: userdata[index]['selectedOption'],
                          onChanged: (value) =>
                              onOptionSelected(index, value as String?),
                        ),
                      ),
                      Expanded(
                        child: RadioListTile(
                          title: Row(
                            children: [
                              Expanded(
                                  child: Image.asset(
                                'assets/${userdata[index]['equipo_visita_img']}',
                                height: 20,
                                width: 20,
                              )),
                              Expanded(
                                child:
                                    Text("${userdata[index]['equipo_visita']}"),
                              )
                            ],
                          ),
                          value: 'E',
                          groupValue: userdata[index]['selectedOption'],
                          onChanged: (value) =>
                              onOptionSelected(index, value as String?),
                        ),
                      ),
                      Expanded(
                        child: RadioListTile(
                          value: 'V',
                          groupValue: userdata[index]['selectedOption'],
                          onChanged: (value) =>
                              onOptionSelected(index, value as String?),
                        ),
                      ),
                      /*Text('resultados: ${userdata[index]['selectedOption']}'),*/
                    ],
                  );*/
                },
              ),
            ),
            GestureDetector(
              onTap: () async {
                final navigatorContext = Navigator.of(context).context;
                await insertaresultado(navigatorContext);
              },
              child: Container(
                  margin: const EdgeInsets.all(20),
                  width: double.maxFinite,
                  height: 50,
                  decoration: const BoxDecoration(
                    color: DanColors.botones,
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    'Jugar',
                    style: TextStyle(
                        color: DanColors.letrasbotones,
                        fontSize: DanColors.tama,
                        fontWeight: FontWeight.bold),
                  )),
            )
            /* 
            Container(
              padding: const EdgeInsets.all(10),
              child: ElevatedButton(
                onPressed: () async {
                  // ignore: unnecessary_null_comparison
                  // Mostrar mensaje de error o hacer algo similar
                  final navigatorContext = Navigator.of(context).context;
                  await insertaresultado(navigatorContext);
                  // La variable no está vacía, agrregar aquí el código que se ejecutará si no está vacía.
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: DanColors.letrasbotones,
                  backgroundColor: DanColors.botones,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('Jugar'),
              ),
            ),*/
          ],
        ),
      ),
    );
  }
}
