import 'package:flutter/material.dart';
import '../src/data/database_helper.dart';

class EstudiantesScreen extends StatefulWidget {
  @override
  _EstudiantesScreenState createState() => _EstudiantesScreenState();
}

class _EstudiantesScreenState extends State<EstudiantesScreen> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('General'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: _estudiantes.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_estudiantes[index]['nombre_est']),
            subtitle: Text('Edad: ${_estudiantes[index]['edad_est']}'),
            trailing: Text('Direccion:${_estudiantes[index]['direccion_est']}'),
          );
        },
      ),
    );
  }
}