import 'package:flutter/material.dart';
import '/src/data/database_helper.dart';

class AgregarParcialScreen extends StatefulWidget {
  @override
  _AgregarParcialScreenState createState() => _AgregarParcialScreenState();
}

class _AgregarParcialScreenState extends State<AgregarParcialScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();

  List<Map<String, dynamic>> _cuatrimestres = [];
  int? _selectedCuatrimestre;

  @override
  void initState() {
    super.initState();
    _fetchCuatrimestres();
  }

  Future <void> _fetchCuatrimestres() async {
    try {
      List<Map<String, dynamic>> cuatrimestres = await DatabaseHelper().getCuatrimestres();
      setState(() {
        _cuatrimestres = cuatrimestres;
      });
    } catch (e) {
      print('Error al obtener cuatrimestres: $e');
    }
  }

  Future<void> _agregarParcial() async {
    if (_formKey.currentState!.validate()) {
      DatabaseHelper dbHelper = DatabaseHelper();
      await dbHelper.insertParcial({
        'nombre_par': _nombreController.text,
        'id_cua': _selectedCuatrimestre,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Parcial agregado exitosamente')),
      );

      setState(() {
        _selectedCuatrimestre = null;
      });

      _nombreController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agregar Parcial'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nombreController,
                decoration: InputDecoration(labelText: 'Nombre de Parcial'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese el nombre del parcial';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<int>(
                decoration: InputDecoration(labelText: 'Cuatrimestre'),
                value: _selectedCuatrimestre,
                onChanged: (int? newValue){
                  setState(() {
                    _selectedCuatrimestre = newValue;
                  });
                },
                items: _cuatrimestres.map<DropdownMenuItem<int>>((Map<String, dynamic> cuatrimestre) {
                  return DropdownMenuItem<int>(
                    value: cuatrimestre['id_cua'],
                    child: Text(cuatrimestre['nombre_cua']),
                  );
                }).toList(),
                validator: (value) {
                  if (value == null) {
                    return 'Por favor seleccione un cuatrimestre';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _agregarParcial,
                child: Text('Agregar Parcial'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
