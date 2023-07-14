import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:app_q/view/colores_plantilla.dart';
import '../drawer/drawer.dart';

class MuestraJuego extends StatefulWidget {
  const MuestraJuego({Key? key}) : super(key: key);

  @override
  State<MuestraJuego> createState() => _MuestraJuegoState();
}

class _MuestraJuegoState extends State<MuestraJuego> {
//crear variable para el pago
  //var obj = PaymentController();
//implentacion del pago  de stipe
//Map se usa par un  estrctura de cleves  su
//clave - valor me imagino que los trae en un json
  Map<String, dynamic>? paymentIntent;

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

//TRAE EL TOKEN DEl DISPOSITIVO
  Future<String?> obtenerToken() async {
    final storage = FlutterSecureStorage();
    return await storage.read(key: 'token');
  }

////////////////////////////////////////
  List userdataresultado = [];
  Future<void> getrecordresultado() async {
    try {
      String? token = await obtenerToken();

      if (token == null) {
// redirececcionar una pagina de error
      } else {
        String uri = "${GlobalVariables().host}resultados_usuario.php";
        var response = await http.post(Uri.parse(uri), body: {'token': token});
        setState(() {
          userdataresultado = jsonDecode(response.body);
        });
      }
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

  String titulo = "Tu juego";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        /*leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),*/
        title: const Text("Tu juego"),
      ),
      drawer: const DrawerMenu(),
      body: Row(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: userdata.length,
              itemBuilder: (context, index) {
                return Row(
                  children: [
                    Container(
                      constraints: const BoxConstraints(maxWidth: 50),
                      child: Expanded(
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
                    ),
                    Container(
                      constraints: const BoxConstraints(maxWidth: 70),
                      child: Expanded(
                        child: Column(
                          children: [
                            Text(userdata[index]['equipo_local']),
                          ],
                        ),
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
          Container(
            margin: const EdgeInsets.all(15),
            child: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () {},
                  child: null,
                  /*onPressed: () =>
                        /obj.makePayment(amount: '30', currency: 'MXN'),
                    child: const Text("pagar")*/
                );
                /*
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Pago()));*/
              },
            ),
          ),
        ],
      ),
    );
  }
/*
  Future<void> payment() async {
    //paso 1
    try {
//este es otro map
      Map<String, dynamic> body = {
        'amount': 2000,
        'currency': "MXN",
      };
//se conecta con stripe
      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization':
              'Bearer sk_test_51NDbPYEel3Qkpt0vDWQQMAlt73dgg1tbFkLl1XfZsyCS5nWzbogU9cuF08vdnIYJpkq2ngh10GGT6s92rLnxFqX900HlXnrSLO',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
      );
      paymentIntent = json.decode(response.body);
    } catch (error) {
      throw Exception(error);
    }
    //paso 2
    await Stripe.instance
        .initPaymentSheet(
            paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntent!['client_secret'],
          style: ThemeMode.light,
          merchantDisplayName: 'Quin Nez',
        ))
        .then((value) => {});

//paso 3
    try {
      await Stripe.instance.presentPaymentSheet().then((value) => {
//succes
            print("Pyment Succes"),
          });
    } catch (error) {}
  }*/
}
