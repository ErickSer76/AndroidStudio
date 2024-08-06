import 'package:flutter/material.dart';
import '/src/data/database_helper.dart';

class AgregarProfesorScreen extends StatefulWidget {
  @override
  _AgregarProfesorScreenState createState() => _AgregarProfesorScreenState();
}

class _AgregarProfesorScreenState extends State<AgregarProfesorScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _apellidoController = TextEditingController();
  final TextEditingController _edadController = TextEditingController();
  final TextEditingController _direccionController = TextEditingController();

  String? _selectedTipoUsuario;
  final DatabaseHelper dbHelper = DatabaseHelper();

  Future<void> _agregarProfesor() async {
    String username = _usernameController.text;
    String password = _passwordController.text;
    String? tipouser = _selectedTipoUsuario;
    String nombre = _nombreController.text;
    String apellido = _apellidoController.text;
    int edad = int.tryParse(_edadController.text) ?? 0;
    String direccion = _direccionController.text;

    if (tipouser != null) {
      await dbHelper.agregarProfesor(username, password, tipouser, nombre, apellido, edad, direccion);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Profesor agregado con éxito'),
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
        title: Text('Agregar Profesor'),
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
                items: <String>['maestro']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value, style: TextStyle(fontWeight: FontWeight.bold)),
                  );
                }).toList(),
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
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _agregarProfesor,
                child: Text('Agregar Profesor'),
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
