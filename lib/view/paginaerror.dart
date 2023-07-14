import 'package:flutter/material.dart';

void main() => runApp(const MyError());

class MyError extends StatelessWidget {
  const MyError({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Material App',
      home: Paginaerror(),
    );
  }
}

class Paginaerror extends StatefulWidget {
  const Paginaerror({super.key});

  @override
  State<Paginaerror> createState() => _PaginaerrorState();
}

class _PaginaerrorState extends State<Paginaerror> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Error 404")),
      body: const Center(child: Text("Pasa ala pagina principal")),
    );
  }
}
