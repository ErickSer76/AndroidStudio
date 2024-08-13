import 'package:flutter/material.dart';
import 'package:proyect1/options/adminscreens/Consultar%20Funciones/ConsultarCarreras.dart';
import 'package:proyect1/options/adminscreens/Consultar%20Funciones/ConsultarCuatrimestre.dart';
import 'package:proyect1/options/adminscreens/Consultar%20Funciones/ConsultarCursosImpartidos.dart';
import 'package:proyect1/options/adminscreens/Consultar%20Funciones/ConsultarEstudiantes.dart';
import 'package:proyect1/options/adminscreens/Consultar%20Funciones/ConsultarGrupos.dart';
import 'package:proyect1/options/adminscreens/Consultar%20Funciones/ConsultarMateria.dart';
import 'package:proyect1/options/adminscreens/Consultar%20Funciones/ConsultarParcial.dart';
import 'package:proyect1/options/adminscreens/Consultar%20Funciones/ConsultarProfesores.dart';

class AdminConsultarOpciones extends StatefulWidget {
  @override
  _AdminConsultarOpcionesState createState() => _AdminConsultarOpcionesState();
}

class _AdminConsultarOpcionesState extends State<AdminConsultarOpciones> {
  final List<Map<String, dynamic>> _funciones = [
    {'nombre': 'Estudiantes', 'descripcion': 'Consulta y edita los datos de estudiantes'},
    {'nombre': 'Profesores', 'descripcion': 'Consulta y edita los datos de profesores'},
    {'nombre': 'Materias', 'descripcion': 'Consulta y edita las materias'},
    {'nombre': 'Grupos', 'descripcion': 'Consulta y edita los grupos'},
    {'nombre': 'Carreras', 'descripcion': 'Consulta y edita las carreras'},
    {'nombre': 'Parciales', 'descripcion': 'Consulta el parcial actual y anteriores'},
    {'nombre': 'Cuatrimestres', 'descripcion': 'Consulta el cuatrimestre actual y anteriores'},
    {'nombre': 'Cursos Impartidos', 'descripcion':'Consulta cursos impartidos'}
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Consultas y Edición'),
        backgroundColor: Colors.lightBlue,
      ),
      body: Container(
        padding: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.lightBlueAccent, Colors.lightBlueAccent, Colors.white],
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
      case 'Estudiantes':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ConsultarEstudiantesScreen()),
        );
        break;
      case 'Profesores':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ConsultarProfesoresScreen()),
        );
        break;
      case 'Cursos Impartidos':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ConsultarCursoImpartidoScreen()),
        );
        break;
      case 'Materias':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ConsultarMateriasScreen()),
        );
        break;
      case 'Grupos':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ConsultarGruposScreen()),
        );
        break;
      case 'Carreras':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ConsultarCarrerasScreen()),
        );
        break;
      case 'Parciales':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ConsultarParcialesScreen()),
        );
        break;
      case 'Cuatrimestres':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ConsultarCuatrimestresScreen()),
        );
        break;
      default:
        break;
    }
  }
}
