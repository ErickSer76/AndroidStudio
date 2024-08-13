import 'package:flutter/material.dart';
import 'package:proyect1/options/adminscreens/Consultar%20Funciones/ConsEstudianteyProfesor/DatosdeParcial.dart';
import '/src/data/database_helper.dart';

class ConsultarParcialesScreen extends StatefulWidget {
  @override
  _ConsultarParcialesScreenState createState() => _ConsultarParcialesScreenState();
}

class _ConsultarParcialesScreenState extends State<ConsultarParcialesScreen> {
  List<Map<String, dynamic>> _parciales = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchParciales();
  }

  Future<void> _fetchParciales() async {
    DatabaseHelper dbHelper = DatabaseHelper();
    List<Map<String, dynamic>> parciales = await dbHelper.getParciales();
    setState(() {
      _parciales = parciales;
      _isLoading = false;
    });
  }

  Future<void> _fetchDatosParciales(int parcialID) async {
    DatabaseHelper dbHelper = DatabaseHelper();
    Map<String, dynamic>? parcial = await dbHelper.getDatosparcial(parcialID);
    if (parcial != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DatosdeParcialScreen(parcial: parcial),
        ),
      );
    }
  }

  Future<void> _eliminarParcial(int parcialID) async {
    DatabaseHelper dbHelper = DatabaseHelper();
    await dbHelper.deleteParcial(parcialID);
    _fetchParciales();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Consultar Parciales'),
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
                itemCount: _parciales.length,
                itemBuilder: (context, index) {
                  final parcial = _parciales[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 10.0),
                    elevation: 4.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: ListTile(
                      title: Text(
                        parcial['nombre_par'],
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text('ID: ${parcial['id_par']}'),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          bool? confirm = await showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('Confirmar eliminación'),
                              content: Text('¿Estás seguro de que quieres eliminar este parcial?'),
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
                            _eliminarParcial(parcial['id_par']);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Parcial eliminado exitosamente')),
                            );
                          }
                        },
                      ),
                      onTap: () {
                        _fetchDatosParciales(parcial['id_par']);
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
