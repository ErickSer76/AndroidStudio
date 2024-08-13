import 'package:flutter/material.dart';
import 'package:proyect1/options/adminscreens/Consultar%20Funciones/ConsEstudianteyProfesor/DatosdeCarrera.dart';
import '/src/data/database_helper.dart';

class ConsultarCarrerasScreen extends StatefulWidget {
  @override
  _ConsultarCarrerasScreenState createState() => _ConsultarCarrerasScreenState();
}

class _ConsultarCarrerasScreenState extends State<ConsultarCarrerasScreen> {
  List<Map<String, dynamic>> _carreras = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCarreras();
  }

  Future<void> _fetchCarreras() async {
    DatabaseHelper dbHelper = DatabaseHelper();
    List<Map<String, dynamic>> carreras = await dbHelper.getCarreras();
    setState(() {
      _carreras = carreras;
      _isLoading = false;
    });
  }

  Future<void> _fetchDatosCarreras(int carreraID) async {
    DatabaseHelper dbHelper = DatabaseHelper();
    Map<String, dynamic>? carrera = await dbHelper.getDatoscarrera(carreraID);
    if (carrera != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DatosdeCarreraScreen(carrera: carrera),
        ),
      );
    }
  }

  Future<void> _eliminarCarrera(int carreraID) async {
    DatabaseHelper dbHelper = DatabaseHelper();
    await dbHelper.deleteCarrera(carreraID);
    _fetchCarreras();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Consultar Carreras'),
        backgroundColor: Colors.lightBlue,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Container(
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.lightBlueAccent, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _carreras.length,
                itemBuilder: (context, index) {
                  final carrera = _carreras[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 10.0),
                    elevation: 4.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: ListTile(
                      title: Text(
                        carrera['nombre_car'],
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text('ID: ${carrera['id_car']}'),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          bool? confirm = await showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('Confirmar eliminación'),
                              content: Text('¿Estás seguro de que quieres eliminar esta carrera?'),
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
                            _eliminarCarrera(carrera['id_car']);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Carrera eliminada exitosamente')),
                            );
                          }
                        },
                      ),
                      onTap: () {
                        _fetchDatosCarreras(carrera['id_car']);
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
