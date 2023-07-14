import 'package:flutter/material.dart';

//color de los botones
class DanColors {
  static const Color botones = Color(0xFF2196F3);
  //color de los contenedores
  static const Color contenedor = Color(0xFF2196F3);
  //contenedor blanco
  static const Color contenedorblanco = Color.fromARGB(255, 255, 255, 255);
  //color de las letras
  static const Color letrasbotones = Color(0xFFFFFFFF);
// tamaño de letra
  static const double tama = 16;
}

//par avalidar la direccion url y la carpeta
class GlobalVariables {
  static final GlobalVariables _instance = GlobalVariables._internal();
  factory GlobalVariables() {
    return _instance;
  }
  GlobalVariables._internal();
  String host = "https://rocketsapp.com.mx/quiniela/";
  /*String host = "http://localhost/flutter/";*/
}

//////////////////////////////////////////////////
Widget getContainer({required String text}) {
  return Container(
    width: 60,
    height: 50,
    decoration: BoxDecoration(
      color: DanColors.contenedor,
      borderRadius: BorderRadius.circular(8),
    ),
    child: Center(
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20,
        ),
        textAlign: TextAlign.center,
      ),
    ),
  );
}

Widget getContainermenu({required String imagen, VoidCallback? onTap}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      width: 90,
      height: 50,
      decoration: BoxDecoration(
        color: DanColors.contenedor,
        borderRadius: BorderRadius.circular(10),
        image: DecorationImage(
          image: AssetImage(imagen),
          fit: BoxFit.cover,
        ),
      ),
    ),
  );
}
