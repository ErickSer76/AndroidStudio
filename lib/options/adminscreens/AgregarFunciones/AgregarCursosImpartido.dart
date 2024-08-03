import 'package:flutter/material.dart';
import '/src/data/database_helper.dart';

class AgregarCursoImpartidoScreen extends StatefulWidget {
  @override
  _AgregarCursoImpartidoScreenState createState() => _AgregarCursoImpartidoScreenState();
}

class _AgregarCursoImpartidoScreenState extends State<AgregarCursoImpartidoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombreCursoController = TextEditingController();

  List<Map<String, dynamic>> _profesores = [];
  List<Map<String, dynamic>> _materias = [];
  List<Map<String, dynamic>> _grupos = [];
  List<Map<String, dynamic>> _carreras = [];
  List<Map<String, dynamic>> _cuatrimestres = [];

  int? _selectedProfesorId;
  int? _selectedMateriaId;
  int? _selectedGrupoId;
  int? _selectedCarreraId;
  int? _selectedCuatrimestreId;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchInitialData();
  }

  Future<void> _fetchInitialData() async {
    DatabaseHelper dbHelper = DatabaseHelper();

    List<Map<String, dynamic>> profesores = await dbHelper.getProfesores();
    List<Map<String, dynamic>> materias = await dbHelper.getMaterias();
    List<Map<String, dynamic>> grupos = await dbHelper.getGrupos();
    List<Map<String, dynamic>> carreras = await dbHelper.getCarreras();
    List<Map<String, dynamic>> cuatrimestres = await dbHelper.getCuatrimestres();

    setState(() {
      _profesores = profesores;
      _materias = materias;
      _grupos = grupos;
      _carreras = carreras;
      _cuatrimestres = cuatrimestres;
      _isLoading = false;
    });
  }

  Future<void> _agregarCurso() async {
    if (_formKey.currentState!.validate()) {
      DatabaseHelper dbHelper = DatabaseHelper();
      await dbHelper.insertCursoImpartido({
        'nombre_cui': _nombreCursoController.text,
        'id_pro': _selectedProfesorId,
        'id_asi': _selectedMateriaId,
        'id_gru': _selectedGrupoId,
        'id_car': _selectedCarreraId,
        'id_cua': _selectedCuatrimestreId,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Curso agregado exitosamente')),
      );

      _nombreCursoController.clear();
      setState(() {
        _selectedProfesorId = null;
        _selectedMateriaId = null;
        _selectedGrupoId = null;
        _selectedCarreraId = null;
        _selectedCuatrimestreId = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agregar Curso'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _nombreCursoController,
                  decoration: InputDecoration(labelText: 'Nombre del Curso'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese el nombre del curso';
                    }
                    return null;
                  },
                ),
                DropdownButtonFormField<int>(
                  decoration: InputDecoration(labelText: 'Seleccionar Profesor'),
                  items: _profesores.map((profesor) {
                    return DropdownMenuItem<int>(
                      value: profesor['id_pro'],
                      child: Text('${profesor['nombre_pro']} ${profesor['apellido_pro']}'),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedProfesorId = value;
                    });
                  },
                  validator: (value) => value == null ? 'Seleccione un profesor' : null,
                ),
                DropdownButtonFormField<int>(
                  decoration: InputDecoration(labelText: 'Seleccionar Materia'),
                  items: _materias.map((materia) {
                    return DropdownMenuItem<int>(
                      value: materia['id_asi'],
                      child: Text(materia['nombre_asi']),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedMateriaId = value;
                    });
                  },
                  validator: (value) => value == null ? 'Seleccione una materia' : null,
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
                    });
                  },
                  validator: (value) => value == null ? 'Seleccione un grupo' : null,
                ),
                DropdownButtonFormField<int>(
                  decoration: InputDecoration(labelText: 'Seleccionar Carrera'),
                  items: _carreras.map((carrera) {
                    return DropdownMenuItem<int>(
                      value: carrera['id_car'],
                      child: Text(carrera['nombre_car']),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCarreraId = value;
                    });
                  },
                  validator: (value) => value == null ? 'Seleccione una carrera' : null,
                ),
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
                    });
                  },
                  validator: (value) => value == null ? 'Seleccione un cuatrimestre' : null,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _agregarCurso,
                  child: Text('Agregar Curso'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
