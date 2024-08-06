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
        backgroundColor: Colors.lightBlue, // Establecer el color de AppBar
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nombreController,
                decoration: InputDecoration(
                  labelText: 'Nombre del Cuatrimestre',
                  filled: true,
                  fillColor: Colors.lightBlueAccent.withOpacity(0.1),
                  border: InputBorder.none,
                ),
                style: TextStyle(fontWeight: FontWeight.bold),
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
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.lightBlue, // Color de fondo del botón
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
