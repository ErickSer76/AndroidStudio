import 'package:flutter/material.dart';

class DatosdeMateriaScreen extends StatelessWidget {
  final Map<String, dynamic> materia;

  DatosdeMateriaScreen({required this.materia});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Datos de Materia'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Nombre: ${materia['nombre_asi']}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              'Carrera: ${materia['nombre_car']}',
            ),
            Text('Descripcion: ${materia['descripcion_asi']}'),
          ],
        ),
      ),
    );
  }
}
