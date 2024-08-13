import 'package:flutter/material.dart';
import 'package:proyect1/options/adminscreens/Consultar%20Funciones/ConsEstudianteyProfesor/DatosdeMateria.dart';
import '/src/data/database_helper.dart';

class ConsultarMateriasScreen extends StatefulWidget {
  @override
  _ConsultarMateriasScreenState createState() => _ConsultarMateriasScreenState();
}

class _ConsultarMateriasScreenState extends State<ConsultarMateriasScreen> {
  List<Map<String, dynamic>> _materias = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchMaterias();
  }

  Future<void> _fetchMaterias() async {
    DatabaseHelper dbHelper = DatabaseHelper();
    List<Map<String, dynamic>> materias = await dbHelper.getMaterias();
    setState(() {
      _materias = materias;
      _isLoading = false;
    });
  }

  Future<void> _fetchDatosMateria(int materiaID) async {
    DatabaseHelper dbHelper = DatabaseHelper();
    Map<String, dynamic>? materia = await dbHelper.getDatosMateria(materiaID);
    if (materia != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DatosdeMateriaScreen(materia: materia),
        ),
      );
    }
  }

  Future<void> _eliminarMateria(int materiaID) async {
    DatabaseHelper dbHelper = DatabaseHelper();
    await dbHelper.deleteMateria(materiaID);
    _fetchMaterias();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Consultar Materias'),
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
                itemCount: _materias.length,
                itemBuilder: (context, index) {
                  final materia = _materias[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 10.0),
                    elevation: 4.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: ListTile(
                      title: Text(
                        materia['nombre_asi'],
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text('Descripción: ${materia['descripcion_asi']}'),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          bool? confirm = await showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('Confirmar eliminación'),
                              content: Text('¿Estás seguro de que quieres eliminar esta materia?'),
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
                            _eliminarMateria(materia['id_asi']);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Materia eliminada exitosamente')),
                            );
                          }
                        },
                      ),
                      onTap: () {
                        _fetchDatosMateria(materia['id_asi']);
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
