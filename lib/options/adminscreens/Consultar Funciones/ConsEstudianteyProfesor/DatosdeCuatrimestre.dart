import 'package:flutter/material.dart';

class DatosdeCuatrimestreScreen extends StatelessWidget {
  final Map<String, dynamic> cuatrimestre;

  DatosdeCuatrimestreScreen({required this.cuatrimestre});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Datos de Cuatrimestre'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Nombre: ${cuatrimestre['nombre_cua']}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            // Añade más campos según sea necesario
          ],
        ),
      ),
    );
  }
}
