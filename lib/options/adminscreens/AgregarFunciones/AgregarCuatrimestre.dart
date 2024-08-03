import 'package:flutter/material.dart';
import '/src/data/database_helper.dart';

class AgregarCuatrimestreScreen extends StatefulWidget {
  @override
  _AgregarCuatrimestreScreenState createState() => _AgregarCuatrimestreScreenState();
}

class _AgregarCuatrimestreScreenState extends State<AgregarCuatrimestreScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();


  Future<void> _agregarCuatrimestre() async {
    if (_formKey.currentState!.validate()) {
      DatabaseHelper dbHelper = DatabaseHelper();
      await dbHelper.insertCuatrimestre({
        'nombre_cua': _nombreController.text,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Cuatrimestre agregado exitosamente')),
      );

      _nombreController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agregar Cuatrimestre'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nombreController,
                decoration: InputDecoration(labelText: 'Nombre del Cuatrimestre'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese el nombre del cuatrimestre';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _agregarCuatrimestre,
                child: Text('Agregar Cuatrimestre'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
