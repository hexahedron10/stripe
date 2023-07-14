import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mi Aplicación',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const PaymentFormPage(),
    );
  }
}

class PaymentFormPage extends StatefulWidget {
  const PaymentFormPage({super.key});

  @override
  _PaymentFormPageState createState() => _PaymentFormPageState();
}

class _PaymentFormPageState extends State<PaymentFormPage> {
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _expMonthController = TextEditingController();
  final TextEditingController _expYearController = TextEditingController();
  final TextEditingController _cvcController = TextEditingController();

  void _makePayment() async {
    final url =
        'https://api.stripe.com/v1/payment_intents'; // Endpoint de la API de Stripe para crear un PaymentIntent

    // Configura los parámetros de la solicitud
    final Map<String, dynamic> params = {
      'amount': 1000, // Monto en centavos
      'currency': 'usd', // Moneda
      'payment_method': {
        'card': {
          'number': _cardNumberController.text,
          'exp_month': int.parse(_expMonthController.text),
          'exp_year': int.parse(_expYearController.text),
          'cvc': _cvcController.text,
        },
      },
    };

    // Realiza la solicitud HTTP
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Authorization':
            'Bearer sk_test_51NOUlkG7VB2W7Zzqa9R41MGdjwjOOzl1j5ceZQ7htoe275gHeeDVvryFqDO5Jx8KowpiRUX9fDzjlboVaXYGVAF1002ZLAEbds', // Reemplaza con tu clave secreta de Stripe
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: params,
    );

    // Maneja la respuesta
    if (response.statusCode == 200) {
      // Pago exitoso
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (_) => const AlertDialog(
          title: Text('Pago exitoso'),
          content: Text('El pago se ha realizado exitosamente.'),
        ),
      );
    } else {
      // Pago fallido
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (_) => const AlertDialog(
          title: Text('Pago fallido'),
          content: Text('Hubo un error al procesar el pago.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Formulario de Cobro'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Número de tarjeta'),
            TextField(
              controller: _cardNumberController,
            ),
            const SizedBox(height: 16.0),
            const Text('Mes de expiración'),
            TextField(
              controller: _expMonthController,
            ),
            const SizedBox(height: 16.0),
            const Text('Año de expiración'),
            TextField(
              controller: _expYearController,
            ),
            const SizedBox(height: 16.0),
            const Text('CVC'),
            TextField(
              controller: _cvcController,
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _makePayment,
              child: const Text('Realizar Pago'),
            ),
          ],
        ),
      ),
    );
  }
}
