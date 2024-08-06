import 'package:flutter/material.dart';
import '/src/data/database_helper.dart';

class AgregarEstudianteScreen extends StatefulWidget {
  @override
  _AgregarEstudianteScreenState createState() => _AgregarEstudianteScreenState();
}

class _AgregarEstudianteScreenState extends State<AgregarEstudianteScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _apellidoController = TextEditingController();
  final TextEditingController _matriculaController = TextEditingController();
  final TextEditingController _edadController = TextEditingController();
  final TextEditingController _direccionController = TextEditingController();

  String? _selectedTipoUsuario;
  int? _selectedCarreraId;
  int? _selectedGrupoId;

  List<Map<String, dynamic>> _carreras = [];
  List<Map<String, dynamic>> _grupos = [];

  final DatabaseHelper dbHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    _fetchCarrerasYGrupos();
  }

  Future<void> _fetchCarrerasYGrupos() async {
    try {
      List<Map<String, dynamic>> carreras = await dbHelper.getCarreras();
      List<Map<String, dynamic>> grupos = await dbHelper.getGrupos();

      setState(() {
        _carreras = carreras;
        _grupos = grupos;
      });
    } catch (e) {
      print('Error fetching carreras and grupos: $e');
    }
  }

  Future<void> _agregarEstudiante() async {
    String username = _usernameController.text;
    String password = _passwordController.text;
    String? tipouser = _selectedTipoUsuario;
    String nombre = _nombreController.text;
    String apellido = _apellidoController.text;
    int matricula = int.tryParse(_matriculaController.text) ?? 0;
    int edad = int.tryParse(_edadController.text) ?? 0;
    String direccion = _direccionController.text;
    int idGrupo = _selectedGrupoId ?? 0;
    int idCarrera = _selectedCarreraId ?? 0;

    if (tipouser != null && idGrupo != 0 && idCarrera != 0) {
      await dbHelper.agregarEstudiante(username, password, tipouser, nombre, apellido, matricula, edad, direccion, idGrupo, idCarrera);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Estudiante agregado con éxito'),
          duration: Duration(seconds: 2),
        ),
      );

      Future.delayed(Duration(seconds: 2), () {
        Navigator.pop(context);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Por favor, llene todos los datos'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agregar Estudiante'),
        backgroundColor: Colors.lightBlue,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Usuario',
                  filled: true,
                  fillColor: Colors.lightBlueAccent.withOpacity(0.1),
                  border: InputBorder.none,
                ),
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Contraseña',
                  filled: true,
                  fillColor: Colors.lightBlueAccent.withOpacity(0.1),
                  border: InputBorder.none,
                ),
                obscureText: true,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Tipo Usuario',
                  filled: true,
                  fillColor: Colors.lightBlueAccent.withOpacity(0.1),
                  border: InputBorder.none,
                ),
                value: _selectedTipoUsuario,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedTipoUsuario = newValue;
                  });
                },
                items: <String>['alumno']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  );
                }).toList(),
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _nombreController,
                decoration: InputDecoration(
                  labelText: 'Nombre',
                  filled: true,
                  fillColor: Colors.lightBlueAccent.withOpacity(0.1),
                  border: InputBorder.none,
                ),
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _apellidoController,
                decoration: InputDecoration(
                  labelText: 'Apellido',
                  filled: true,
                  fillColor: Colors.lightBlueAccent.withOpacity(0.1),
                  border: InputBorder.none,
                ),
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _matriculaController,
                decoration: InputDecoration(
                  labelText: 'Matricula',
                  filled: true,
                  fillColor: Colors.lightBlueAccent.withOpacity(0.1),
                  border: InputBorder.none,
                ),
                keyboardType: TextInputType.number,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _edadController,
                decoration: InputDecoration(
                  labelText: 'Edad',
                  filled: true,
                  fillColor: Colors.lightBlueAccent.withOpacity(0.1),
                  border: InputBorder.none,
                ),
                keyboardType: TextInputType.number,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _direccionController,
                decoration: InputDecoration(
                  labelText: 'Dirección',
                  filled: true,
                  fillColor: Colors.lightBlueAccent.withOpacity(0.1),
                  border: InputBorder.none,
                ),
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              DropdownButtonFormField<int>(
                decoration: InputDecoration(
                  labelText: 'Carrera',
                  filled: true,
                  fillColor: Colors.lightBlueAccent.withOpacity(0.1),
                  border: InputBorder.none,
                ),
                value: _selectedCarreraId,
                onChanged: (int? newValue) {
                  setState(() {
                    _selectedCarreraId = newValue;
                  });
                },
                items: _carreras.map<DropdownMenuItem<int>>((Map<String, dynamic> carrera) {
                  return DropdownMenuItem<int>(
                    value: carrera['id_car'],
                    child: Text(
                      carrera['nombre_car'],
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  );
                }).toList(),
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              DropdownButtonFormField<int>(
                decoration: InputDecoration(
                  labelText: 'Grupo',
                  filled: true,
                  fillColor: Colors.lightBlueAccent.withOpacity(0.1),
                  border: InputBorder.none,
                ),
                value: _selectedGrupoId,
                onChanged: (int? newValue) {
                  setState(() {
                    _selectedGrupoId = newValue;
                  });
                },
                items: _grupos.map<DropdownMenuItem<int>>((Map<String, dynamic> grupo) {
                  return DropdownMenuItem<int>(
                    value: grupo['id_gru'],
                    child: Text(
                      grupo['nombre_gru'],
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  );
                }).toList(),
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _agregarEstudiante,
                child: Text('Agregar Estudiante'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Colors.lightBlue,
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
    );
  }
}
