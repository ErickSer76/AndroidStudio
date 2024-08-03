import 'package:flutter/material.dart';

class DatosdeCursoImpartidoScreen extends StatelessWidget {
  final Map<String, dynamic> cursoimpartido;

  DatosdeCursoImpartidoScreen({required this.cursoimpartido});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Datos de Curso Impartido'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Nombre: ${cursoimpartido['nombre_cui']}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              'Profesor: ${cursoimpartido['nombre_pro']} ${cursoimpartido['apellido_pro']}',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              'Materia: ${cursoimpartido['nombre_asi']}',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              'Grupo: ${cursoimpartido['nombre_gru']}',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              'Carrera: ${cursoimpartido['nombre_car']}',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              'Cuatrimestre: ${cursoimpartido['nombre_cua']}',
              style: TextStyle(fontSize: 16),
            ),
            // Añade más campos según sea necesario
          ],
        ),
      ),
    );
  }
}
