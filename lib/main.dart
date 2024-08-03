// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:proyect1/options/admin.dart';
import 'package:proyect1/options/alumno.dart';
import 'package:proyect1/options/maestro.dart';
import 'package:proyect1/options/admin.dart' show Homescreenadmin;
import 'src/data/database_helper.dart'; // Asegúrate de importar correctamente tu archivo database_helper.dart

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() {
    return _LoginScreenState();
  }
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _message = '';

  Future<void> _login() async {
    String username = _usernameController.text;
    String password = _passwordController.text;

    DatabaseHelper dbHelper = DatabaseHelper();
    Map<String, dynamic>? user = await dbHelper.getUser(username, password);

    if (user != null) {
      setState(() {
        _message = 'Login successful';
      });
      if (user['tipo_user'] == 'maestro') {
        Map<String, dynamic>? DatosProfesor = await dbHelper
            .getDatosProfesor(user['id']);
        if( DatosProfesor != null) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) =>
              Homescreenmaestro(user: user, DatosProfesor: DatosProfesor)),
        );
        }  else {
          setState(() {
            _message = 'Datos no encontrados';
          });
        }
      } else if (user['tipo_user'] == 'admin'){
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Homescreenadmin()),
        );

      } else if (user['tipo_user'] == 'alumno') {
        Map<String, dynamic>? DatosEstudiante = await dbHelper
            .getDatosEstudiante(user['id']);
        if (DatosEstudiante != null) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>
                Homescreenalumno(user: user, DatosEstudiante: DatosEstudiante)),
          );
        } else {
          setState(() {
            _message = 'Datos no encontrados';
          });
        }
      }
    } else {
      setState(() {
        _message = 'Invalid credentials';
      });
    }
  }

  Future<void> _register() async {
    String username = _usernameController.text;
    String password = _passwordController.text;

    DatabaseHelper dbHelper = DatabaseHelper();
    await dbHelper.insertUser({'username': username, 'password': password});

    setState(() {
      _message = 'User registered';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 160,
        backgroundColor: Colors.teal.shade400,
        title: Image.asset(
          'assets/img/Logo.png', // ruta imagen
        ),
        centerTitle: true, // centra la imagen dentro del AppBar
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.teal.shade400,Colors.teal.shade700 , Colors.teal.shade900],
                stops: const [0.3,0.7, 0.9],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextField(
                    controller: _usernameController,
                    decoration: const InputDecoration(
                      labelText: 'Username',
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12.0),
                  TextField(
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    obscureText: true,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _login,
                    child: const Text('Login'),
                  ),
                  ElevatedButton(
                    onPressed: _register,
                    child: const Text('Register'),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    _message,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}