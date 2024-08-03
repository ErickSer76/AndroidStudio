import 'package:flutter/material.dart';

class DatosdeEstudianteScreen extends StatelessWidget {
  final Map<String, dynamic> estudiante;

  DatosdeEstudianteScreen({required this.estudiante});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Datos de Estudiante'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Nombre: ${estudiante['nombre_est']} ${estudiante['apellido_est']}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text('Matrícula: ${estudiante['matricula_est']}'),
            Text('Carrera: ${estudiante['nombre_car']}'),
            Text('Grupo: ${estudiante['nombre_gru']}'),
            Text(
              'Usuario: ${estudiante['username']}',
            ),
            Text(
              'Contraseña: ${estudiante['password']}',
            ),
            // Añade más campos según sea necesario
          ],
        ),
      ),
    );
  }
}
