import 'package:flutter/material.dart';
import 'package:proyect1/options/maestroscreens/AsignarCalificacion.dart';
import 'package:proyect1/options/maestroscreens/VerCursosImpartidos.dart';
import 'general_data.dart';
import 'package:proyect1/main.dart';

class Homescreenmaestro extends StatelessWidget {
  final Map<String, dynamic> user;
  final Map<String, dynamic> DatosProfesor;

  Homescreenmaestro({ required this.user, required this.DatosProfesor});

  void _logout(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
          (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.teal.shade400,
              ),
              child: Image.asset(
                'assets/img/Logo.png',
              ),
            ),
            ListTile(
              title: Text('General'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EstudiantesScreen()),
                );
              },
            ),
            ListTile(
              title: Text('Calificar'),
              onTap: (){
                Navigator.push(
                  context, MaterialPageRoute(builder: (context) => CalificarScreen()),
                );
              },
            ),
            ListTile(
              title: Text('Cursos Impartidos'),
              onTap: () {
                int profesorId = DatosProfesor['id_pro']; // Asegúrate de que el ID del profesor esté aquí
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ConsultarCursosImpartidosProfesorScreen(profesorId: profesorId),
                  ),
                );
              },
            ),
            ListTile(
              title: Text('Cerrar Sesion'),
              onTap: () {
                _logout(context);
              },
            ),
            // Otros elementos del Drawer
          ],
        ),
      ),
      appBar: AppBar(
        toolbarHeight: 140,
        backgroundColor: Colors.teal.shade400,
        title: Image.asset(
          'assets/img/Logo.png',
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.teal.shade400,
                  Colors.teal.shade300,
                  Colors.teal.shade200
                ],
                stops: const [0.3, 0.7, 0.9],
              ),
            ),
          ),
          Center(
            child: Container(
              width: 350,
              height: 550,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3),
                  ),
                ],
                border: Border.all(
                  color: Colors.grey,
                  width: 3,
                ),
              ),
              child:Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text(
                      'Profesor',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Image.asset(
                      'assets/img/user.jpg',
                      width: 100,
                      height: 100,
                    ),
                    SizedBox(height: 20),
                    Text (
                      'Nombre: ${DatosProfesor['nombre_pro']} ${DatosProfesor['apellido_pro']}',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 20),
                    Text (
                      'Edad: ${DatosProfesor['edad_pro']}',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 20),
                    Text (
                      'Direccion: ${DatosProfesor['direccion_pro']}',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
