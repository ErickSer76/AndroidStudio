import 'package:flutter/material.dart';
import 'package:proyect1/options/adminscreens/Consultar%20Funciones/ConsEstudianteyProfesor/DatosdeCuatrimestre.dart';
import '/src/data/database_helper.dart';

class ConsultarCuatrimestresScreen extends StatefulWidget {
  @override
  _ConsultarCuatrimestresScreenState createState() => _ConsultarCuatrimestresScreenState();
}

class _ConsultarCuatrimestresScreenState extends State<ConsultarCuatrimestresScreen> {
  List<Map<String, dynamic>> _cuatrimestres = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCuatrimestres();
  }

  Future<void> _fetchCuatrimestres() async {
    DatabaseHelper dbHelper = DatabaseHelper();
    List<Map<String, dynamic>> cuatrimestres = await dbHelper.getCuatrimestres();
    setState(() {
      _cuatrimestres = cuatrimestres;
      _isLoading = false;
    });
  }

  Future<void> _fetchDatosCuatrimestres(int cuatrimestresID) async {
    DatabaseHelper dbHelper = DatabaseHelper();
    Map<String, dynamic>? cuatrimestre = await dbHelper.getDatosCuatrimestre(cuatrimestresID);
    if (cuatrimestre != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DatosdeCuatrimestreScreen(cuatrimestre: cuatrimestre),
        ),
      );
    }
  }

  Future <void> _eliminarCuatrimestres(int cuatrimestreID) async {
    DatabaseHelper dbHelper = DatabaseHelper();
    await dbHelper.deleteCuatrimestre(cuatrimestreID);
    _fetchCuatrimestres();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Consultar Cuatrimestres'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _cuatrimestres.length,
                itemBuilder: (context, index) {
                  final cuatrimestre = _cuatrimestres[index];
                  return ListTile(
                    title: Text(cuatrimestre['nombre_cua']),
                    subtitle: Text('ID: ${cuatrimestre['id_cua']}'),
                    trailing: IconButton (
                      icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          bool? confirm = await showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('Confirmar eliminacion'),
                              content: Text('¿Estas seguro de que quieres eliminar este cuatrimestre?'),
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
                            )
                          );

                          if (confirm == true) {
                            _eliminarCuatrimestres(cuatrimestre['id_cua']);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Carrera eliminada exitosamente')),
                              );
                            }
                          },
                        ),
                        onTap: () {
                          _fetchDatosCuatrimestres(cuatrimestre['id_cua']);
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