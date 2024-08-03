import 'package:flutter/material.dart';

class DatosdeGrupoScreen extends StatelessWidget {
  final Map<String, dynamic> grupo;

  DatosdeGrupoScreen({required this.grupo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Datos de Grupo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Nombre: ${grupo['nombre_gru']}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              'Carrera: ${grupo['nombre_car']}',
            ),
            Text('Fecha de Inicio: ${grupo['fechaini_gru']}'),
          ],
        ),
      ),
    );
  }
}
