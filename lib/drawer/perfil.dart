import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:app_q/view/paginaerror.dart';
import 'package:app_q/view/colores_plantilla.dart';
import '../controller/menuquiniela.dart';

void main() {
  runApp(const Perfil());
}

class Perfil extends StatefulWidget {
  const Perfil({super.key});
  @override
  State<Perfil> createState() => _PerfilState();
}

class _PerfilState extends State<Perfil> {
  late String
      selectedOption; // Declaración de la variable global para llenar el combo de los bancos

//se crea una funcon para traer los datos del usuario
  Future<String?> obtenerToken() async {
    final storage = FlutterSecureStorage();
    return await storage.read(key: 'token');
  }

  Future<void> trae() async {
    //obtiene el token guardado en el dispositivo

    //mando a llamar a token
    final token = await obtenerToken();
// se conecta a php para validar el token del dispisitivo y l token de la base de datos
    String uri = "${GlobalVariables().host}actualiza.php";
    var res = await http.post(Uri.parse(uri), body: {
      'token': token,
    });
    var response = jsonDecode(res.body);
    if (response["success"] == true) {
      var data = response["data"];
      var namevalor = data["name"];
      var emailvalor = data["email"];
      var passwordvalor = data["password"];
      var telefonovalor = data["telefono"];
      var cuentavalor = data["cuenta"];
      var bancovalor = data["banco"];
      var token = data["token"];
      print("Name: $namevalor");
      print("Email: $emailvalor d");
      print("Password: $passwordvalor");
      print("telefono: $telefonovalor");
      print("cuenta:  $cuentavalor");
      print("banco:  $bancovalor");
      print("token:  $token");
//
/*
      if (data["telefono"] == null) {
        var telefonovalor = 0;
      } else {
        var telefonovalor = data["telefono"];
      }
      if (data["cuenta"] == null) {
        var cuentavalor = 0;
      } else {
        var token = data["token"];
      }
      */

      name.text = namevalor;
      email.text = emailvalor;
      password.text = passwordvalor;
      telefono.text = telefonovalor;
      cuenta.text = cuentavalor;
      banco.text = bancovalor;
    }
  }

  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController telefono = TextEditingController();
  TextEditingController cuenta = TextEditingController();
  TextEditingController banco = TextEditingController();
// variable par insertar _keyform
  final _keyform = GlobalKey<FormState>();

  Future<void> inserta(BuildContext context) async {
    final token = await obtenerToken();
    //obenemos el token con esta funcion ya esta guardado el el dispositivo
    if (name.text != "" || email.text != "" || password.text != "") {
      try {
        String uri = "${GlobalVariables().host}actualiza_registro_perfil.php";
        var res = await http.post(Uri.parse(uri), body: {
          'name': name.text,
          'email': email.text,
          'password': password.text,
          'telefono': telefono.text,
          'cuenta': cuenta.text,
          'banco': banco.text,
          'token': token
        });
        var response = jsonDecode(res.body);
        if (response["success"] == true) {
          name.text = "";
          email.text = "";
          password.text = "";
          telefono.text = "";
          cuenta.text = "";
          banco.text = "";
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
                        MaterialPageRoute(
                            builder: (context) => const MyQuinielamenu()),
                      );
                    },
                  ),
                ],
              );
            },
          );

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

  void initState() {
    trae();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            title: const Text('Actualiza Datos'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
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
                        child: TextFormField(
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                          ],
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Por favor, ingresa un valor';
                            }
                            if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
                              return 'El valor debe ser de 10 dígitos numéricos';
                            }
                            return null;
                          },
                          /*validator: (valor) {
                            if (valor!.isEmpty) {
                              return "este campo no puede estar vacio";
                            }
                            return null;
                          },*/
                          controller: telefono,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.phone),
                            filled: true,
                            border: OutlineInputBorder(),
                            label: Text('Ingresa tu telefono de contacto'),
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.all(10),
                        child: TextFormField(
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                          ],
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Por favor, ingresa tu numero de cuenta';
                            }
                            if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
                              return 'El valor debe ser de 10 dígitos numéricos';
                            }
                            return null;
                          },
                          /*validator: (valor) {
                            if (valor!.isEmpty) {
                              return "este campo no puede estar vacio";
                            }
                            return null;
                          },*/
                          controller: cuenta,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.credit_card),
                            filled: true,
                            border: OutlineInputBorder(),
                            label: Text('Ingresa tu numero de cuenta'),
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.all(10),
                        child: TextFormField(
                          inputFormatters: [
                            //permite letras y \s espacios en blanco
                            FilteringTextInputFormatter.allow(
                                RegExp(r'[a-zA-Z\s]')),
                          ],
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Por favor, ingresa nombre de tu banco';
                            }
                            return null;
                          },
                          controller: banco,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.business),
                            filled: true,
                            border: OutlineInputBorder(),
                            label: Text('Ingresa nombre de tu banco'),
                          ),
                        ),
                      ),
/*
                      DropdownButtonFormField<String>(
                        value: dropdownController.text,
                        onChanged: (value) {
                          setState(() {
                            dropdownController.text = value!;
                          });
                        },
                        items: const [
                          DropdownMenuItem(
                            value: 'opcion1',
                            child: Text('Bancomer'),
                          ),
                          DropdownMenuItem(
                            value: 'opcion2',
                            child: Text('Banamex'),
                          ),
                          DropdownMenuItem(
                            value: 'opcion3',
                            child: Text('Banco Azteca'),
                          ),
                        ],
                      ),*/
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
                                    'Actualiza',
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
