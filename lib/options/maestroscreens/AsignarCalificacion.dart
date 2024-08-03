import 'package:flutter/material.dart';
import '/src/data/database_helper.dart';

class CalificarScreen extends StatefulWidget {
  final int profesorId;

  CalificarScreen({required this.profesorId});

  @override
  _CalificarScreenState createState() => _CalificarScreenState();
}

class _CalificarScreenState extends State<CalificarScreen> {
  final _formKey = GlobalKey<FormState>();
  final _calificacionController = TextEditingController();

  List<Map<String, dynamic>> _cuatrimestres = [];
  List<Map<String, dynamic>> _parciales = [];
  List<Map<String, dynamic>> _grupos = [];
  List<Map<String, dynamic>> _materias = [];
  List<Map<String, dynamic>> _alumnos = [];

  int? _selectedCuatrimestreId;
  int? _selectedParcialId;
  int? _selectedGrupoId;
  int? _selectedMateriaId;
  int? _selectedAlumnoId;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchInitialData();
  }

  Future<void> _fetchInitialData() async {
    DatabaseHelper dbHelper = DatabaseHelper();

    List<Map<String, dynamic>> cuatrimestres = await dbHelper.getCuatrimestres();
    List<Map<String, dynamic>> parciales = await dbHelper.getParciales();
    List<Map<String, dynamic>> grupos = await dbHelper.getGrupos();
    List<Map<String, dynamic>> materias = await dbHelper.getCursosImpartidosPorProfesor(widget.profesorId);
    List<Map<String, dynamic>> alumnos = await dbHelper.getEstudiantes();

    setState(() {
      _cuatrimestres = cuatrimestres;
      _parciales = parciales;
      _grupos = grupos;
      _materias = materias;
      _alumnos = alumnos;
      _isLoading = false;
    });
  }

  Future<void> _fetchParcialesPorCuatrimestre(int idCuatrimestre) async {
    DatabaseHelper dbHelper = DatabaseHelper();
    List<Map<String, dynamic>> parciales = await dbHelper.getParcialesPorCuatrimestre(idCuatrimestre);

    setState(() {
      _parciales = parciales;
      _selectedParcialId = null;
    });
  }

  Future<void> _fetchAlumnosPorGrupo(int idGrupo) async {
    DatabaseHelper dbHelper = DatabaseHelper();
    List<Map<String, dynamic>> alumnos = await dbHelper.getEstudiantesPorGrupo(idGrupo);

    setState(() {
      _alumnos = alumnos;
      _selectedAlumnoId = null;
    });
  }

  Future<void> _fetchMateriasPorGrupoYProfesor(int idGrupo, int idProfesor) async {
    DatabaseHelper dbHelper = DatabaseHelper();
    List<Map<String, dynamic>> materias = await dbHelper.getCursosImpartidosPorGrupoYProfesor(idGrupo, idProfesor);

    setState(() {
      _materias = materias;
      _selectedMateriaId = null;
    });
  }

  Future<void> _agregarCalificacion() async {
    if (_formKey.currentState!.validate() && _selectedAlumnoId != null && _selectedMateriaId != null && _selectedParcialId != null) {
      DatabaseHelper dbHelper = DatabaseHelper();
      await dbHelper.insertCalificacion({
        'id_est': _selectedAlumnoId,
        'id_cui': _selectedMateriaId,
        'id_gru': _selectedGrupoId,
        'id_par': _selectedParcialId,
        'id_cua': _selectedCuatrimestreId,
        'calificacion_cal': double.parse(_calificacionController.text),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Calificación agregada exitosamente')),
      );

      _calificacionController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agregar Calificación'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              DropdownButtonFormField<int>(
                decoration: InputDecoration(labelText: 'Seleccionar Cuatrimestre'),
                items: _cuatrimestres.map((cuatrimestre) {
                  return DropdownMenuItem<int>(
                    value: cuatrimestre['id_cua'],
                    child: Text(cuatrimestre['nombre_cua']),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCuatrimestreId = value;
                    _fetchParcialesPorCuatrimestre(value!);
                  });
                },
                validator: (value) => value == null ? 'Seleccione un cuatrimestre' : null,
              ),
              DropdownButtonFormField<int>(
                decoration: InputDecoration(labelText: 'Seleccionar Parcial'),
                items: _parciales.map((parcial) {
                  return DropdownMenuItem<int>(
                    value: parcial['id_par'],
                    child: Text(parcial['nombre_par'].toString()),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedParcialId = value;
                  });
                },
                value: _selectedParcialId,
                validator: (value) => value == null ? 'Seleccione un parcial' : null,
              ),
              DropdownButtonFormField<int>(
                decoration: InputDecoration(labelText: 'Seleccionar Grupo'),
                items: _grupos.map((grupo) {
                  return DropdownMenuItem<int>(
                    value: grupo['id_gru'],
                    child: Text(grupo['nombre_gru']),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedGrupoId = value;
                    _fetchAlumnosPorGrupo(value!);
                    _fetchMateriasPorGrupoYProfesor(value, widget.profesorId);
                  });
                },
                validator: (value) => value == null ? 'Seleccione un grupo' : null,
              ),
              DropdownButtonFormField<int>(
                decoration: InputDecoration(labelText: 'Seleccionar Curso'),
                items: _materias.map((materia) {
                  return DropdownMenuItem<int>(
                    value: materia['id_cui'],
                    child: Text(materia['nombre_cui']),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedMateriaId = value;
                  });
                },
                value: _selectedMateriaId,
                validator: (value) => value == null ? 'Seleccione un Curso' : null,
              ),
              DropdownButtonFormField<int>(
                decoration: InputDecoration(labelText: 'Seleccionar Alumno'),
                items: _alumnos.map((alumno) {
                  return DropdownMenuItem<int>(
                    value: alumno['id_est'],
                    child: Text('${alumno['nombre_est']} ${alumno['apellido_est']}'),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedAlumnoId = value;
                  });
                },
                value: _selectedAlumnoId,
                validator: (value) => value == null ? 'Seleccione un alumno' : null,
              ),
              TextFormField(
                controller: _calificacionController,
                decoration: InputDecoration(labelText: 'Calificación'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese la calificación';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _agregarCalificacion,
                child: Text('Agregar Calificación'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
