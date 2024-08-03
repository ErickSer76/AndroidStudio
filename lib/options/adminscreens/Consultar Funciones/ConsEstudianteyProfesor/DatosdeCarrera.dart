import 'package:flutter/material.dart';

class DatosdeCarreraScreen extends StatelessWidget {
  final Map<String, dynamic> carrera;

  DatosdeCarreraScreen({required this.carrera});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Datos de Carrera'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Nombre: ${carrera['nombre_car']}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            // Añade más campos según sea necesario
          ],
        ),
      ),
    );
  }
}
