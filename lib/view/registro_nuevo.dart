import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:app_q/view/paginaerror.dart';
import 'package:app_q/main.dart';
import 'colores_plantilla.dart';

void main() {
  runApp(const RegistroNuevo());
}

class RegistroNuevo extends StatefulWidget {
  const RegistroNuevo({super.key});
  @override
  State<RegistroNuevo> createState() => _RegistroNuevoState();
}

class _RegistroNuevoState extends State<RegistroNuevo> {
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  final _keyform = GlobalKey<FormState>();

  Future<void> inserta(BuildContext context) async {
    if (name.text != "" || email.text != "" || password.text != "") {
      try {
        String uri = "${GlobalVariables().host}registro.php";

        var res = await http.post(Uri.parse(uri), body: {
          'name': name.text,
          'email': email.text,
          'password': password.text
        });
        var response = jsonDecode(res.body);
        if (response["success"] == true) {
          /*ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Han sido Insertado tu registro'),
          ));*/
          // ignore: use_build_context_synchronously
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Registro exitoso'),
                content:
                    const Text('¡Han sido insertados tus datos correctamente!'),
                actions: [
                  TextButton(
                    child: const Text('Cerrar'),
                    onPressed: () {
                      Navigator.of(context).pop(); // Cerrar el AlertDialog
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const MyApp()),
                      );
                    },
                  ),
                ],
              );
            },
          );
          name.text = "";
          email.text = "";
          password.text = "";
          print("los datos has sido ingresados correctamente");

          // ignore: use_build_context_synchronously
          /*Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MyApp()),
          );*/
        } else {
          // ignore: use_build_context_synchronously
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Paginaerror()),
          );
          print("los datos no coinciden");
        }
      } catch (e) {
        print(e);
      }
    } else {
      print("rellena todos los campos");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            title: const Text('Registro Nuevo'),
            backgroundColor: DanColors.botones,
            /*leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),*/
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Registrate",
                  style: TextStyle(
                    fontSize: DanColors.tama,
                    fontWeight: FontWeight.bold,
                    color: DanColors.botones,
                  ),
                  textAlign: TextAlign.left,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Form(
                    key: _keyform,
                    child: Column(children: [
                      Container(
                        margin: const EdgeInsets.all(10),
                        child: TextFormField(
                          validator: (valor) {
                            if (valor!.isEmpty) {
                              return "este campo no puede estar vacio";
                            }
                            return null;
                          },
                          controller: name,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.person),
                            filled: true,
                            border: OutlineInputBorder(),
                            label: Text('Ingrea tu nombre'),
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.all(10),
                        child: TextFormField(
                          validator: (valor) {
                            if (valor!.isEmpty) {
                              return 'Este Campo no puede estar vacio';
                            }
                            if (!RegExp(
                                    "^[a-zA-Z0-9r+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                                .hasMatch(valor)) {
                              return 'Introduce un correo valido ';
                            }
                            return null;
                          },
                          controller: email,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.email),
                            filled: true,
                            border: OutlineInputBorder(),
                            label: Text(
                              'Ingresa tu correo',
                            ),
                            /*CODIGO PARA VALIDAR EL MAIL*/
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.all(10),
                        child: TextFormField(
                          validator: (valor) {
                            if (valor!.isEmpty) {
                              return "este campo no puede estar vacio";
                            }
                            return null;
                          },
                          controller: password,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.lock),
                            filled: true,
                            border: OutlineInputBorder(),
                            label: Text('Ingresa tu paswword'),
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.all(10),
                        child: Builder(
                          builder: (context) {
                            return GestureDetector(
                              onTap: () async {
                                if (_keyform.currentState!.validate()) {
                                  // Obtener el contexto del widget que contiene el Navigator
                                  final navigatorContext =
                                      Navigator.of(context).context;
                                  // Llamar a la función inserta() y pasar el contexto obtenido
                                  await inserta(navigatorContext);
                                  /*Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const Opciones()));
                                */
                                  print('validacion exitosa');
                                } else {
                                  print('Ha ocurrido un error');
                                }
                              },
                              child: Container(
                                  width: double.maxFinite,
                                  height: 60,
                                  decoration: const BoxDecoration(
                                    color: DanColors.botones,
                                    borderRadius: BorderRadius.only(),
                                  ),
                                  alignment: Alignment.center,
                                  child: const Text(
                                    'Entrar',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: DanColors.tama,
                                        fontWeight: FontWeight.bold),
                                  )),
                            );
                            // REGRESAR POR CUALQUIER COSA AL ELEVATE BUTTON

                            /*ElevatedButton(
                                onPressed: () async {
                                  if (_keyform.currentState!.validate()) {
                                    // Obtener el contexto del widget que contiene el Navigator
                                    final navigatorContext =
                                        Navigator.of(context).context;
                                    // Llamar a la función inserta() y pasar el contexto obtenido
                                    await inserta(navigatorContext);
                                    /*Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const Opciones()));
                                */
                                    print('validacion exitosa');
                                  } else {
                                    print('Ha ocurrido un error');
                                  }
                                },
                                child: const Text('Entrar'));*/
                          },
                        ),
                      ),
                    ]),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
