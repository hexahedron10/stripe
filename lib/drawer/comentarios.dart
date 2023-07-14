import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../view/colores_plantilla.dart';

void main() => runApp(const Comentarios());

class Comentarios extends StatelessWidget {
  const Comentarios({super.key});

  @override
  Widget build(BuildContext context) {
// controlamos el  campo de formualrio.
    TextEditingController comentarios = TextEditingController();
//variable  para que funcuone el formulario
    final _keyform = GlobalKey<FormState>();
//Traemos el token con eta funcion
    Future<String?> obtenerToken() async {
      final storage = FlutterSecureStorage();
      return await storage.read(key: 'token');
    }

    Future<void> insertacomentarios(BuildContext context) async {
// se manda a llamar al token almacenado en el dispositivo
      final token = await obtenerToken();
// la liga para pasar a inserta los datos
      String uri = "${GlobalVariables().host}comentarios.php";
      var res = await http.post(Uri.parse(uri),
          body: {'token': token, 'comentarios': comentarios.text});
      var response = jsonDecode(res.body);
      if (response["success"] == true) {
        comentarios.text = "";
        print("los comentarios se han insertado");
      } else {
        print("los comentarios no se insertaron");
      }
    }

    return MaterialApp(
        title: 'Material App',
        home: Scaffold(
          appBar: AppBar(
            title: const Text('Comentarios'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          body: Center(
            child: Form(
              key: _keyform,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.all(10),
                      child: TextFormField(
                        maxLines: 5, // Permite múltiples líneas de texto
                        keyboardType: TextInputType.multiline,
                        inputFormatters: [
                          //permite letras y \s espacios en blanco
                          FilteringTextInputFormatter.allow(
                              RegExp(r'[a-zA-Z\s]')),
                          LengthLimitingTextInputFormatter(
                              255), // Limita la longitud a 100 caracteres
                        ],
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Por favor, ingresa tus comentarios';
                          }
                          return null;
                        },
                        controller: comentarios,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.person),
                          filled: true,
                          border: OutlineInputBorder(),
                          labelText:
                              'Ingrese su comentario', // Cambiamos label por labelText
                        ),
                      ),
                    ),
                    Container(
                        margin: const EdgeInsets.all(10),
                        child: Builder(builder: (context) {
                          //aqui cambien el elvate button por gestoredetector
                          return GestureDetector(
                            onTap: () async {
                              if (_keyform.currentState!.validate()) {
                                // Obtener el contexto del widget que contiene el Navigator
                                final navigatorContext =
                                    Navigator.of(context).context;
                                // Llamar a la función inserta() y pasar el contexto obtenido
                                await insertacomentarios(navigatorContext);
                                /*Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const Opciones()));
                                */
                                print('validacion exitosa');
                              } else {
                                print('Ha ocurrido un error');
                              }
                              /*regsiterUser();*/
                            },
                            child: Container(
                                width: double.maxFinite,
                                height: 50,
                                decoration: const BoxDecoration(
                                  color: DanColors.botones,
                                ),
                                alignment: Alignment.center,
                                child: const Text(
                                  'Entrar',
                                  style: TextStyle(
                                      color: DanColors.letrasbotones,
                                      fontSize: DanColors.tama,
                                      fontWeight: FontWeight.bold),
                                )),
                          );
                        }))
                  ]),
            ),
          ),
        ));
  }
}
