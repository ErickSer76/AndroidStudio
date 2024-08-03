import 'package:flutter/material.dart';

class DatosdeProfesorScreen extends StatelessWidget {
  final Map<String, dynamic> profesor;

  DatosdeProfesorScreen({required this.profesor});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Datos de Profesor'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Nombre: ${profesor['nombre_pro']}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              'Apellido: ${profesor['apellido_pro']}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text('Edad: ${profesor['edad_pro']}'),
            Text('Direccion: ${profesor['direccion_pro']}'),
            Text(
              'Usuario: ${profesor['username']}',
            ),
            Text(
              'Contraseña: ${profesor['password']}',
            ),
            // Añade más campos según sea necesario
          ],
        ),
      ),
    );
  }
}
