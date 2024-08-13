import 'package:flutter/material.dart';
import 'package:proyect1/options/adminscreens/Consultar%20Funciones/ConsEstudianteyProfesor/DatosdeEstudiante.dart';
import '/src/data/database_helper.dart';

class ConsultarEstudiantesScreen extends StatefulWidget {
  @override
  _ConsultarEstudiantesScreenState createState() => _ConsultarEstudiantesScreenState();
}

class _ConsultarEstudiantesScreenState extends State<ConsultarEstudiantesScreen> {
  List<Map<String, dynamic>> _estudiantes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchEstudiantes();
  }

  Future<void> _fetchEstudiantes() async {
    DatabaseHelper dbHelper = DatabaseHelper();
    List<Map<String, dynamic>> estudiantes = await dbHelper.getEstudiantes();
    setState(() {
      _estudiantes = estudiantes;
      _isLoading = false;
    });
  }

  Future<void> _fetchDatosEstudiante(int userID) async {
    DatabaseHelper dbHelper = DatabaseHelper();
    Map<String, dynamic>? estudiante = await dbHelper.getDatosEstudiante(userID);
    if (estudiante != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DatosdeEstudianteScreen(estudiante: estudiante),
        ),
      );
    }
  }

  Future<void> _eliminarEstudianteYUsuario(int userId) async {
    DatabaseHelper dbHelper = DatabaseHelper();
    await dbHelper.deleteEstudianteYUsuario(userId);
    _fetchEstudiantes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Consultar Estudiantes'),
        backgroundColor: Colors.blueAccent,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Container(
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _estudiantes.length,
                itemBuilder: (context, index) {
                  final estudiante = _estudiantes[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 10.0),
                    elevation: 4.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: ListTile(
                      title: Text(
                        estudiante['nombre_est'],
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text('Matricula: ${estudiante['matricula_est']}'),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          bool? confirm = await showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('Confirmar eliminación'),
                              content: Text('¿Estás seguro de que quieres eliminar este estudiante?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context, false),
                                  child: Text('Cancelar'),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  child: Text('Eliminar'),
                                ),
                              ],
                            ),
                          );

                          if (confirm == true) {
                            _eliminarEstudianteYUsuario(estudiante['user_id']);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Estudiante eliminado exitosamente')),
                            );
                          }
                        },
                      ),
                      onTap: () {
                        _fetchDatosEstudiante(estudiante['user_id']);
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
