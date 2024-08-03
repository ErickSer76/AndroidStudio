import 'package:flutter/material.dart';

class DatosdeParcialScreen extends StatelessWidget {
  final Map<String, dynamic> parcial;

  DatosdeParcialScreen({required this.parcial});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Datos de Parcial'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Nombre: ${parcial['nombre_par']}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text('Cuatrimestre: ${parcial['nombre_cua']}'),
            // Añade más campos según sea necesario
          ],
        ),
      ),
    );
  }
}
