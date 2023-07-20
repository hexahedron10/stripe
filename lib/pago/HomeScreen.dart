import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_stripe/flutter_stripe.dart';
import 'dart:convert';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);
  Future<void> initPayment(
      {required String email,
      required double amount,
      required BuildContext context}) async {
    try {
      // 1. Create a payment intent on the server
      final response = await http.post(
          Uri.parse(
              'https://us-central1-quiniela-6fadc.cloudfunctions.net/stripePaymentIntentRequest'),
          body: {
            'email': email,
            'amount': amount.toString(),
          });
      final jsonResponse = jsonDecode(response.body);
      log(jsonResponse.toString());
      // 2. Initialize the payment sheet
      await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
        paymentIntentClientSecret: jsonResponse['paymentIntent'],
        merchantDisplayName: 'Qneza',
        customerId: jsonResponse['customer'],
        customerEphemeralKeySecret: jsonResponse['ephemeralKey'],
        testEnv: true,
        merchantCountryCode: 'MX',
      ));
      print(jsonResponse);
      await Stripe.instance.presentPaymentSheet();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('El pago ha sido exitoso'),
        ),
      );
    } catch (errorr) {
      if (errorr is StripeException) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text('ha ocurrido un error ${errorr.error.localizedMessage}'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('ha ocurrido un error $errorr'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: ElevatedButton(
        child: const Text('Pago 50'),
        onPressed: () async {
          await initPayment(
              amount: 5000, context: context, email: 'egdaniel10@hotmail.com');
        },
      )),
    );
  }
}
/*
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:app_q/view/resultados.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //aqui se inicializa el sistema de pago (1)
  @override
  void initState() {
    super.initState();
    makePayment();
  }

  //finaiza (1)
//accedo a la variables guardadas en el dsipositivo (2)
  Future<List<String?>> obtenerDatos() async {
    const storage = FlutterSecureStorage();
    String? id = await storage.read(key: 'id');
    String? name = await storage.read(key: 'name');
    String? email = await storage.read(key: 'email');
    String? token = await storage.read(key: 'token');
    return [id, name, email, token];
  }

  //finaiza (2)
// Funcion que se crea para validar si existe el cliene  (3)
  Future<bool> checkCustomerExists(String customerId) async {
    const apiKey =
        'sk_test_51NOUlkG7VB2W7Zzqa9R41MGdjwjOOzl1j5ceZQ7htoe275gHeeDVvryFqDO5Jx8KowpiRUX9fDzjlboVaXYGVAF1002ZLAEbds';
    final url = 'https://api.stripe.com/v1/customers/$customerId';

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      // El cliente existe en Stripe
      return true;
    } else if (response.statusCode == 404) {
      // El cliente no existe en Stripe
      return false;
    } else {
      // Ocurrió un error al realizar la solicitud
      throw Exception('Error al verificar el cliente en Stripe');
    }
  }
//finaliza (3)

  //creando el cliene el el stripe con parametros de mi base de datos del metodo (1)
  //(4)
  Future<void> createStripeCustomer() async {
    List<String?> datos = await obtenerDatos();
    String? id = datos[0];
    String? name = datos[1];
    String? email = datos[2];
    String? token = datos[3];
    // ID del cliente que deseas verificar
    final customerId = id;
    // Llamar a la función checkCustomerExists (3)
    checkCustomerExists(customerId!).then((exists) async {
      if (exists) {
        print('El cliente existe en Stripe');
      } else {
        print('El cliente no existe en Stripe');
        //lo crea en stripe si no lo encuentra (5)
        try {
          String apiKey =
              'sk_test_51NOUlkG7VB2W7Zzqa9R41MGdjwjOOzl1j5ceZQ7htoe275gHeeDVvryFqDO5Jx8KowpiRUX9fDzjlboVaXYGVAF1002ZLAEbds';

          var response = await http.post(
            Uri.parse('https://api.stripe.com/v1/customers'),
            headers: {
              'Authorization': 'Bearer $apiKey',
              'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: {
              'id': id,
              'name': name,
              'email': email,
              'description': token,
            },
          );
          if (response.statusCode == 200) {
            var jsonResponse = jsonDecode(response.body);
            String customerId = jsonResponse['id'];
            print('Cliente creado en Stripe. ID del cliente: $customerId');
            print(jsonResponse);
          } else {
            print(
                'Error al crear el cliente en Stripe. Código de respuesta: ${response.statusCode}');
          }
        } catch (e) {
          print('Error al crear el cliente en Stripe: $e');
        }
      }
    }).catchError((error) {
      print('Error al verificar el cliente en Stripe: $error');
    });
    //  //finaiza (5)
  }

  Map<String, dynamic>? paymentIntent;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pagando'),
      ),
      body: Center(
        child: TextButton(
          child: const Text('Pagando'),
          onPressed: () async {
            /*await makePayment();*/
          },
        ),
      ),
    );
  }

// esta es la funcion importante que hace elk pago (7)
  Future<void> makePayment() async {
    try {
      //se manda a llamar a la funcion para crear al cliente
      await createStripeCustomer();

      // se mada a llamar a la funcion para crear la intencion de pago
      paymentIntent = await createPaymentIntent('50', 'MXN');
      //Payment Sheet
      await Stripe.instance
          .initPaymentSheet(
              paymentSheetParameters: SetupPaymentSheetParameters(
                  paymentIntentClientSecret: paymentIntent!['client_secret'],
                  testEnv: true,
                  merchantCountryCode: 'MX',
                  // applePay: const PaymentSheetApplePay(merchantCountryCode: '+92',),
                  // googlePay: const PaymentSheetGooglePay(testEnv: true, currencyCode: "US", merchantCountryCode: "+92"),
                  style: ThemeMode.dark,
                  merchantDisplayName: 'QNeza'))
          .then((value) {});

      ///now finally display payment sheeet
      displayPaymentSheet();
    } catch (e, s) {
      print('exception:$e$s');
    }
  }

  displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet().then((value) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            content: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: Color.fromARGB(255, 5, 7, 177),
                    ),
                    Text("Pago Realizado"),
                  ],
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Cerrar'),
                onPressed: () {
                  Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Resultados()))
                      .then((_) => Navigator.of(context).pop());
                  /*Navigator.of(context).pop();*/ // Cierra el diálogo
                },
              ),
            ],
          ),
        );

        // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("paid successfully")));
        paymentIntent = null;
      }).onError((error, stackTrace) {
        print('Error is:--->$error $stackTrace');
      });
    } on StripeException catch (e) {
      print('Error is:---> $e');
      showDialog(
          context: context,
          builder: (_) => const AlertDialog(
                content: Text("Cancelled "),
              ));
    } catch (e) {
      print('$e');
    }
  }

  //  Future<Map<String, dynamic>>
  createPaymentIntent(String amount, String currency) async {
    // se trae la lista del dispositivo guardado
    List<String?> datos = await obtenerDatos();
    String? id = datos[0];
    String? name = datos[1];
    String? email = datos[2];
    String? token = datos[3];
    try {
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount),
        'currency': currency,
        'payment_method_types[]': 'card',
        'customer': id,
        'metadata[token]': token,
        'description': 'Quiniela',
        'setup_future_usage': 'on_session'
      };
      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization':
              'Bearer sk_test_51NOUlkG7VB2W7Zzqa9R41MGdjwjOOzl1j5ceZQ7htoe275gHeeDVvryFqDO5Jx8KowpiRUX9fDzjlboVaXYGVAF1002ZLAEbds',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: body,
      );
      print('Payment Intent Body->>> ${response.body.toString()}');
      return jsonDecode(response.body);
    } catch (err) {
      // ignore: avoid_print
      print('err charging user: ${err.toString()}');
    }
  }

  calculateAmount(String amount) {
    final calculatedAmout = (int.parse(amount)) * 100;
    return calculatedAmout.toString();
  }
}
*/