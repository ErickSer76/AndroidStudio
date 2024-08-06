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
    try {
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
    } catch (e) {
      print('Error al obtener datos: $e');
    }
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
        title: Text('Agregar Curso Imparido'),
        backgroundColor: Colors.lightBlue, // Color consistente con otras pantallas
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTextField(
                  controller: _nombreCursoController,
                  label: 'Nombre del Curso',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese el nombre del curso';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 24), // Aumentar el espacio entre los campos
                _buildDropdownField(
                  label: 'Seleccionar Profesor',
                  value: _selectedProfesorId,
                  items: _profesores,
                  onChanged: (value) {
                    setState(() {
                      _selectedProfesorId = value;
                    });
                  },
                ),
                SizedBox(height: 24), // Aumentar el espacio entre los campos
                _buildDropdownField(
                  label: 'Seleccionar Materia',
                  value: _selectedMateriaId,
                  items: _materias,
                  onChanged: (value) {
                    setState(() {
                      _selectedMateriaId = value;
                    });
                  },
                ),
                SizedBox(height: 24), // Aumentar el espacio entre los campos
                _buildDropdownField(
                  label: 'Seleccionar Grupo',
                  value: _selectedGrupoId,
                  items: _grupos,
                  onChanged: (value) {
                    setState(() {
                      _selectedGrupoId = value;
                    });
                  },
                ),
                SizedBox(height: 24), // Aumentar el espacio entre los campos
                _buildDropdownField(
                  label: 'Seleccionar Carrera',
                  value: _selectedCarreraId,
                  items: _carreras,
                  onChanged: (value) {
                    setState(() {
                      _selectedCarreraId = value;
                    });
                  },
                ),
                SizedBox(height: 24), // Aumentar el espacio entre los campos
                _buildDropdownField(
                  label: 'Seleccionar Cuatrimestre',
                  value: _selectedCuatrimestreId,
                  items: _cuatrimestres,
                  onChanged: (value) {
                    setState(() {
                      _selectedCuatrimestreId = value;
                    });
                  },
                ),
                SizedBox(height: 40), // Espacio antes del botón
                ElevatedButton(
                  onPressed: _agregarCurso,
                  child: Text('Agregar Curso'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.lightBlue, // Color consistente con otras pantallas
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.lightBlueAccent.withOpacity(0.1),
        border: InputBorder.none,
      ),
      style: TextStyle(fontWeight: FontWeight.bold),
      validator: validator,
    );
  }

  Widget _buildDropdownField({
    required String label,
    required int? value,
    required List<Map<String, dynamic>> items,
    required void Function(int?) onChanged,
  }) {
    return DropdownButtonFormField<int>(
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.lightBlueAccent.withOpacity(0.1),
        border: InputBorder.none,
      ),
      value: value,
      items: items.map((item) {
        return DropdownMenuItem<int>(
          value: item['id_pro'] ?? item['id_asi'] ?? item['id_gru'] ?? item['id_car'] ?? item['id_cua'],
          child: Text(item['nombre_pro'] ?? item['nombre_asi'] ?? item['nombre_gru'] ?? item['nombre_car'] ?? item['nombre_cua']),
        );
      }).toList(),
      onChanged: onChanged,
      validator: (value) => value == null ? 'Seleccione una opción' : null,
    );
  }
}
