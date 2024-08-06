import 'package:flutter/material.dart';
import 'package:proyect1/options/adminscreens/AgregarFunciones/AgregarCarrera.dart';
import 'package:proyect1/options/adminscreens/AgregarFunciones/AgregarCuatrimestre.dart';
import 'package:proyect1/options/adminscreens/AgregarFunciones/AgregarCursosImpartido.dart';
import 'package:proyect1/options/adminscreens/AgregarFunciones/AgregarEstudiantes.dart';
import 'package:proyect1/options/adminscreens/AgregarFunciones/AgregarGrupos.dart';
import 'package:proyect1/options/adminscreens/AgregarFunciones/AgregarMaterias.dart';
import 'package:proyect1/options/adminscreens/AgregarFunciones/AgregarParcial.dart';
import 'package:proyect1/options/adminscreens/AgregarFunciones/AgregarProfesor.dart';

class AdminAgregarOpciones extends StatefulWidget {
  @override
  _AdminAgregarOpcionesState createState() => _AdminAgregarOpcionesState();
}

class _AdminAgregarOpcionesState extends State<AdminAgregarOpciones> {
  final List<Map<String, dynamic>> _funciones = [
    {'nombre': 'Estudiantes y Usuarios', 'descripcion': 'Agrega nuevos estudiantes como usuarios'},
    {'nombre': 'Profesores y Usuarios', 'descripcion': 'Agrega nuevos profesores como usuarios'},
    {'nombre': 'Materias', 'descripcion': 'Agrega nuevas materias'},
    {'nombre': 'Grupos', 'descripcion': 'Agrega nuevos Grupos'},
    {'nombre': 'Carreras', 'descripcion': 'Agrega las carreras de la institucion'},
    {'nombre': 'Parciales', 'descripcion': 'Agrega el inicio de un parcial'},
    {'nombre': 'Cuatrimestres', 'descripcion': 'Agrega el inicio de un cuatrimestre'},
    {'nombre': 'Cursos Impartidos', 'descripcion': 'Agrega los Cursos impartidos'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Funciones Administrativas'),
        backgroundColor: Colors.lightBlue,
      ),
      body: Container(
        padding: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.lightBlueAccent,Colors.lightBlueAccent, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView.builder(
          itemCount: _funciones.length,
          itemBuilder: (context, index) {
            return Card(
              color: Colors.white.withOpacity(0.9),
              margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
              child: ListTile(
                title: Text(
                  _funciones[index]['nombre'],
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
                ),
                subtitle: Text(
                  _funciones[index]['descripcion'],
                  style: TextStyle(color: Colors.black54),
                ),
                onTap: () {
                  _navigateToFunction(context, _funciones[index]['nombre']);
                },
                trailing: Icon(Icons.arrow_forward, color: Colors.lightBlue),
              ),
            );
          },
        ),
      ),
    );
  }

  void _navigateToFunction(BuildContext context, String functionName) {
    switch (functionName) {
      case 'Estudiantes y Usuarios':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AgregarEstudianteScreen()),
        );
        break;
      case 'Profesores y Usuarios':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AgregarProfesorScreen()),
        );
        break;
      case 'Cursos Impartidos':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AgregarCursoImpartidoScreen()),
        );
        break;
      case 'Materias':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AgregarMateriaScreen()),
        );
        break;
      case 'Grupos':
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AgregarGruposScreen())
        );
        break;
      case 'Carreras':
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AgregarCarreraScreen())
        );
        break;
      case 'Parciales':
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AgregarParcialScreen())
        );
        break;
      case 'Cuatrimestres':
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AgregarCuatrimestreScreen())
        );
        break;
      default:
        break;
    }
  }
}
