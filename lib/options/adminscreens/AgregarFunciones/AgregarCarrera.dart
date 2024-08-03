import 'package:flutter/material.dart';
import '/src/data/database_helper.dart';

class AgregarCarreraScreen extends StatefulWidget {
  @override
  _AgregarCarreraScreenState createState() => _AgregarCarreraScreenState();
}

class _AgregarCarreraScreenState extends State<AgregarCarreraScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();


  Future<void> _agregarCarrera() async {
    if (_formKey.currentState!.validate()) {
      DatabaseHelper dbHelper = DatabaseHelper();
      await dbHelper.insertCarrera({
        'nombre_car': _nombreController.text,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Carrera agregada exitosamente')),
      );

      _nombreController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agregar Carrera'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nombreController,
                decoration: InputDecoration(labelText: 'Nombre de la Carrera'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese el nombre de la carrera';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _agregarCarrera,
                child: Text('Agregar Carrera'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
