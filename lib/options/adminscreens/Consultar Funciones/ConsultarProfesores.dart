import 'package:flutter/material.dart';
import 'package:proyect1/options/adminscreens/Consultar%20Funciones/ConsEstudianteyProfesor/DatosdeProfesor.dart';
import '/src/data/database_helper.dart';

class ConsultarProfesoresScreen extends StatefulWidget {
  @override
  _ConsultarProfesoresScreenState createState() => _ConsultarProfesoresScreenState();
}

class _ConsultarProfesoresScreenState extends State<ConsultarProfesoresScreen> {
  List<Map<String, dynamic>> _profesores = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchProfesores();
  }

  Future<void> _fetchProfesores() async {
    DatabaseHelper dbHelper = DatabaseHelper();
    List<Map<String, dynamic>> profesores = await dbHelper.getProfesores();
    setState(() {
      _profesores = profesores;
      _isLoading = false;
    });
  }

  Future<void> _fetchDatosProfesor(int userID) async {
    DatabaseHelper dbHelper = DatabaseHelper();
    Map<String, dynamic>? profesor = await dbHelper.getDatosProfesor(userID);
    if (profesor != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DatosdeProfesorScreen(profesor: profesor),
        ),
      );
    }
  }

  Future<void> _eliminarProfesorYUsuario(int userId) async {
    DatabaseHelper dbHelper = DatabaseHelper();
    await dbHelper.deleteProfesorYUsuario(userId);
    _fetchProfesores();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Consultar Profesores'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _profesores.length,
                itemBuilder: (context, index) {
                  final profesor = _profesores[index];
                  return ListTile(
                    title: Text(profesor['nombre_pro']),
                    subtitle: Text('Edad: ${profesor['edad_pro']}'),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () async {
                        bool? confirm = await showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Confirmar eliminación'),
                            content: Text('¿Estás seguro de que quieres eliminar este profesor?'),
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
                          _eliminarProfesorYUsuario(profesor['user_id']);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Profesor eliminado exitosamente')),
                          );
                        }
                      },
                    ),
                    onTap: () {
                      _fetchDatosProfesor(profesor['user_id']);
                    },
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
