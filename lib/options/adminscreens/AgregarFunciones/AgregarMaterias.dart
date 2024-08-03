import 'package:flutter/material.dart';
import '/src/data/database_helper.dart';

class AgregarMateriaScreen extends StatefulWidget {
  @override
  _AgregarMateriaScreenState createState() => _AgregarMateriaScreenState();
}

class _AgregarMateriaScreenState extends State<AgregarMateriaScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _descripcionController = TextEditingController();

  List<Map<String, dynamic>> _carreras = [];
  int? _selectedCarreraId;

  @override
  void initState() {
    super.initState();
    _fetchCarreras();
  }

  Future<void> _fetchCarreras() async {
    try {
      List<Map<String, dynamic>> carreras = await DatabaseHelper().getCarreras();
      setState(() {
        _carreras = carreras;
      });
    } catch (e) {
      print('Error fetching carreras: $e');
    }
  }

  Future<void> _agregarMateria() async {
    if (_formKey.currentState!.validate()) {
      DatabaseHelper dbHelper = DatabaseHelper();
      await dbHelper.insertMateria({
        'id_car': _selectedCarreraId,
        'nombre_asi': _nombreController.text,
        'descripcion_asi': _descripcionController.text,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Materia agregada exitosamente')),
      );

      setState(() {
        _selectedCarreraId = null;
      });
      _nombreController.clear();
      _descripcionController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agregar Materia'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              DropdownButtonFormField<int>(
                decoration: InputDecoration(labelText: 'Carrera'),
                value: _selectedCarreraId,
                onChanged: (int? newValue) {
                  setState(() {
                    _selectedCarreraId = newValue;
                  });
                },
                items: _carreras.map<DropdownMenuItem<int>>((Map<String, dynamic> carrera) {
                  return DropdownMenuItem<int>(
                    value: carrera['id_car'],
                    child: Text(carrera['nombre_car']),
                  );
                }).toList(),
                validator: (value) {
                  if (value == null) {
                    return 'Por favor seleccione una carrera';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _nombreController,
                decoration: InputDecoration(labelText: 'Nombre de Materia'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese el nombre de la materia';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descripcionController,
                decoration: InputDecoration(labelText: 'Descripción'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese una descripción';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _agregarMateria,
                child: Text('Agregar Materia'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

