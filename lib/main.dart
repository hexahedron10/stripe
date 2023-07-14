import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:app_q/view/registro_nuevo.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'controller/menuquiniela.dart';
import 'view/colores_plantilla.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  /*await Firebase.initilazeApp();*/
  ///la clave pubica de stripe
  Stripe.publishableKey =
      "pk_test_51NOUlkG7VB2W7Zzqf2GNHaO4dnMBO2aiqrESVJMn6l8T0r2m5UJEonIcYfmIS67QjK0quKj6gWVI3O3aH0I1rd5500JTH2Ag95";
  Stripe.instance.applySettings();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isLoading = false; // Variable para controlar el estado de carga
//vamos a gurdar el token con esta funcion

  Future<void> guardarToken(
    String id,
    String name,
    String email,
    String token,
  ) async {
    final storage = FlutterSecureStorage();
    await storage.write(key: 'id', value: id);
    await storage.write(key: 'name', value: name);
    await storage.write(key: 'email', value: email);
    await storage.write(key: 'token', value: token);
  }

/*
  Future<void> guardarToken(String token) async {
    final storage = new FlutterSecureStorage();
    await storage.write(key: 'token', value: token);
  }

  Future<void> guardarid(int id) async {
    final storage = FlutterSecureStorage();
    await storage.write(key: 'id', value: 'id');
  }
*/
  //TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  final _keyform = GlobalKey<FormState>();

  Future<void> valida(BuildContext context) async {
    if (/*name.text != "" ||*/ email.text != "" || password.text != "") {
      try {
        String uri = "${GlobalVariables().host}index.php";

        var res = await http.post(Uri.parse(uri), body: {
          //'name': name.text,
          'email': email.text,
          'password': password.text
        });
        var response = jsonDecode(res.body);
        if (response["success"] == true) {
          // Obtener el token de la respuesta
          int id = response["q_id"];
          String idString = id.toString();
          String name = response["name"];
          String email = response["email"];
          String token = response["token"];
          // ignore: unnecessary_null_comparison
          if (token != null) {
            await guardarToken(idString, name, email, token);
            print(idString);
            print(name);
            print(email);
            print(token);
            // Llamar a la función para guardar el token en el dispositivo
          } else {
            print("El token es nulo");
          }

// Navegar a la siguiente página utilizando el contexto obtenido
          // ignore: use_build_context_synchronously
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MyQuinielamenu()),
            /*MaterialPageRoute(builder: (context) => const ControLLer()),*/
          );
          print("Has Ingresado correctamente");
          print(token);
        } else {
          // ignore: use_build_context_synchronously
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Registro no valido'),
                content: const Text('¡Tus datos son incorrectos!'),
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
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Login",
                style: TextStyle(
                  fontSize: 22,
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
                            return 'Este Campo no puede estar vacio';
                          }
                          if (!RegExp("^[a-zA-Z0-9r+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                              .hasMatch(valor)) {
                            return 'Introduce un correo valido ';
                          }
                          return null;
                        },
                        controller: email,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.email_sharp),
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
                        obscureText: true,
                        obscuringCharacter: "*",
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
                          //aqui cambien el elvate button por gestoredetector
                          return GestureDetector(
                            onTap: () async {
                              setState(() {
                                isLoading =
                                    true; // Activa el indicador de carga
                              });
                              if (_keyform.currentState!.validate()) {
                                // Obtener el contexto del widget que contiene el Navigator
                                final navigatorContext =
                                    Navigator.of(context).context;
                                // Llamar a la función inserta() y pasar el contexto obtenido
                                await valida(navigatorContext);
                                setState(() {
                                  isLoading =
                                      false; // Desactiva el indicador de carga
                                });
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
                                child: isLoading
                                    ? const CircularProgressIndicator() // Indicador de carga
                                    : const Text(
                                        'Entrar',
                                        style: TextStyle(
                                            color: DanColors.letrasbotones,
                                            fontSize: DanColors.tama,
                                            fontWeight: FontWeight.bold),
                                      )),
                          );
                        },
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(10),
                      child: Builder(
                        builder: (context) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const RegistroNuevo()));
                            },
                            child: Container(
                                width: double.maxFinite,
                                height: 50,
                                decoration: const BoxDecoration(
                                  color: DanColors.botones,
                                  borderRadius: BorderRadius.only(),
                                ),
                                alignment: Alignment.center,
                                child: const Text(
                                  'Registrarse',
                                  style: TextStyle(
                                      color: DanColors.letrasbotones,
                                      fontSize: DanColors.tama,
                                      fontWeight: FontWeight.bold),
                                )),
                          );
                        },
                      ),
                    ),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
