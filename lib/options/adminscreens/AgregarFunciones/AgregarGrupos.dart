import 'package:flutter/material.dart';
import '/src/data/database_helper.dart';

class AgregarGruposScreen extends StatefulWidget {
  @override
  _AgregarGruposScreenState createState() => _AgregarGruposScreenState();
}

class _AgregarGruposScreenState extends State<AgregarGruposScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _fechainiController = TextEditingController();

  List<Map<String, dynamic>> _carreras = [];
  int? _selectCarreraId;

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
      print('Error al obtener carreras: $e');
    }
  }

  Future<void> _agregarGrupos() async {
    if (_formKey.currentState!.validate()) {
      DatabaseHelper dbHelper = DatabaseHelper();
      await dbHelper.insertGrupos({
        'nombre_gru': _nombreController.text,
        'fechaini_gru': _fechainiController.text,
        'id_car': _selectCarreraId,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Grupo agregado exitosamente')),
      );

      setState(() {
        _selectCarreraId = null;
      });
      _nombreController.clear();
      _fechainiController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agregar Grupo'),
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
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nombreController,
                decoration: InputDecoration(
                  labelText: 'Nombre y Año Grupo',
                  filled: true,
                  fillColor: Colors.lightBlueAccent.withOpacity(0.1),
                  border: InputBorder.none,
                ),
                style: TextStyle(fontWeight: FontWeight.bold),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese el nombre y año del grupo';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _fechainiController,
                decoration: InputDecoration(
                  labelText: 'Fecha de Inicio de Grupo',
                  filled: true,
                  fillColor: Colors.lightBlueAccent.withOpacity(0.1),
                  border: InputBorder.none,
                ),
                style: TextStyle(fontWeight: FontWeight.bold),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese la fecha de inicio de grupo';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              DropdownButtonFormField<int?>(
                decoration: InputDecoration(
                  labelText: 'Carrera',
                  filled: true,
                  fillColor: Colors.lightBlueAccent.withOpacity(0.1),
                  border: InputBorder.none,
                ),
                value: _selectCarreraId,
                onChanged: (int? newValue) {
                  setState(() {
                    _selectCarreraId = newValue;
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
                validator: (value) {
                  if (value == null) {
                    return 'Por favor seleccione una carrera';
                  }
                  return null;
                },
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _agregarGrupos,
                child: Text('Agregar Grupo'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.lightBlue,
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
