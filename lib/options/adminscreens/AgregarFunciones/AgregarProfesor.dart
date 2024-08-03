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


    if(tipouser != null) {
      await dbHelper.agregarProfesor(username, password, tipouser, nombre, apellido,  edad, direccion);

      // Navegar de vuelta o mostrar un mensaje de éxito
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Profesor Agregado con Exito'),
          duration: Duration(seconds: 2),
        ),
      );

      //Navegar despues de un pequeño retraso
      Future.delayed(Duration(seconds: 2), () {
        Navigator.pop(context);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Por favor, Llene todos los datos'),
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
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Usuario'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Contraseña'),
              obscureText: true,
            ),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(labelText: 'Tipo Usuario'),
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
                  child: Text(value),
                );
              }).toList(),
            ),
            TextField(
              controller: _nombreController,
              decoration: InputDecoration(labelText: 'Nombre'),
            ),
            TextField(
              controller: _apellidoController,
              decoration: InputDecoration(labelText: 'Apellido'),
            ),
            TextField(
              controller: _edadController,
              decoration: InputDecoration(labelText: 'Edad'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _direccionController,
              decoration: InputDecoration(labelText: 'Dirección'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _agregarProfesor,
              child: Text('Agregar Profesor'),
            ),
          ],
        ),
      ),
    );
  }
}
