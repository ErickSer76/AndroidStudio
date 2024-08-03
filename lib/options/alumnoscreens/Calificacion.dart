import 'package:flutter/material.dart';
import '/src/data/database_helper.dart';

class CalificacionesPorEstudiante extends StatefulWidget {
  final int estudianteID;

  const CalificacionesPorEstudiante({Key? key, required this.estudianteID}) : super(key: key);

  @override
  _CalificacionesPorEstudianteState createState() => _CalificacionesPorEstudianteState();
}

class _CalificacionesPorEstudianteState extends State<CalificacionesPorEstudiante> {
  List<Map<String, dynamic>> _calificaciones = [];
  List<Map<String, dynamic>> _filteredCalificaciones = [];
  bool _isLoading = true;

  String? _selectedParcial;
  String? _selectedCuatrimestre;
  List<String> _parciales = [];
  List<String> _cuatrimestres = [];

  @override
  void initState() {
    super.initState();
    _fetchCalificacionesPorEstudiante();
  }

  Future<void> _fetchCalificacionesPorEstudiante() async {
    setState(() {
      _isLoading = true;
    });

    try {
      DatabaseHelper dbHelper = DatabaseHelper();
      List<Map<String, dynamic>> calificaciones = await dbHelper.getCalificacionesPorEstudiante(widget.estudianteID);

      // Obtener valores únicos para los filtros
      _parciales = calificaciones.map((calificacion) => calificacion['nombre_par'] as String).toSet().toList();
      _cuatrimestres = calificaciones.map((calificacion) => calificacion['nombre_cua'] as String).toSet().toList();

      setState(() {
        _calificaciones = calificaciones;
        _filteredCalificaciones = calificaciones;
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching calificaciones: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _applyFilters() {
    setState(() {
      _filteredCalificaciones = _calificaciones.where((calificacion) {
        final bool matchesParcial = _selectedParcial == null || calificacion['nombre_par'] == _selectedParcial;
        final bool matchesCuatrimestre = _selectedCuatrimestre == null || calificacion['nombre_cua'] == _selectedCuatrimestre;
        return matchesParcial && matchesCuatrimestre;
      }).toList();
    });
  }

  void _clearFilters() {
    setState(() {
      _selectedParcial = null;
      _selectedCuatrimestre = null;
      _filteredCalificaciones = _calificaciones;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calificaciones del Estudiante'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DropdownButton<String>(
                  hint: Text('Seleccionar Parcial'),
                  value: _selectedParcial,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedParcial = newValue;
                    });
                  },
                  items: _parciales.map<DropdownMenuItem<String>>((value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                DropdownButton<String>(
                  hint: Text('Seleccionar Cuatrimestre'),
                  value: _selectedCuatrimestre,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedCuatrimestre = newValue;
                    });
                  },
                  items: _cuatrimestres.map<DropdownMenuItem<String>>((value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: _applyFilters,
                  child: Text('Aplicar Filtros'),
                ),
                ElevatedButton(
                  onPressed: _clearFilters,
                  child: Text('Quitar Filtros'),
                ),
              ],
            ),
            Expanded(
              child: _filteredCalificaciones.isNotEmpty
                  ? ListView.builder(
                itemCount: _filteredCalificaciones.length,
                itemBuilder: (context, index) {
                  final calificacion = _filteredCalificaciones[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Nombre: ${calificacion['nombre_est']} ${calificacion['apellido_est']}',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Text('Asignatura: ${calificacion['nombre_asi']}'),
                        Text('Parcial: ${calificacion['nombre_par']}'),
                        Text('Cuatrimestre: ${calificacion['nombre_cua']}'),
                        Text('Calificación: ${calificacion['calificacion_cal']}'),
                        Divider(thickness: 1, color: Colors.grey),
                      ],
                    ),
                  );
                },
              )
                  : Text('No hay calificaciones disponibles'),
            ),
          ],
        ),
      ),
    );
  }
}
