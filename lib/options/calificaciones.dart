import 'package:flutter/material.dart';
import '../src/data/database_helper.dart';

class CalificacionesEst extends StatefulWidget {
  const CalificacionesEst({super.key});

  @override
  _CalificacionesScreenState createState() {
    return _CalificacionesScreenState();
  }
}

class _CalificacionesScreenState extends State<CalificacionesEst> {
  List<Map<String, dynamic>> _calificaciones = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCalificaciones();
  }

  Future<void> _fetchCalificaciones() async {
    DatabaseHelper dbHelper = DatabaseHelper();
    List<Map<String, dynamic>> calificaciones = await dbHelper.getCalificaciones();
    setState(() {
      _calificaciones = calificaciones;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calificaciones'),
      ),
      body: _isLoading
        ? const Center(child: CircularProgressIndicator())
        : ListView.builder(
        itemCount: _calificaciones.length,
        itemBuilder: (context, index) {
          final calificacion = _calificaciones[index];
          return ListTile(
            title: Text('Estudiante: ${calificacion['id_est']}'),
            subtitle: Text('Carrera: ${calificacion['id_car']}'),
            trailing: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('Asignatura: ${calificacion['id_asi']}'),
                Text('Calificacion: ${calificacion['calificacion_cal']}'),
              ],
            ),
          );
        },
      ),
    );

  }

}