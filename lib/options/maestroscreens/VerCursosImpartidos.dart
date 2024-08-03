import 'package:flutter/material.dart';
import 'package:proyect1/options/maestroscreens/DetallesCursoImpartido/DetallesCursoImpartido.dart';
import '/src/data/database_helper.dart';

class ConsultarCursosImpartidosProfesorScreen extends StatefulWidget {
  final int profesorId;

  ConsultarCursosImpartidosProfesorScreen({required this.profesorId});

  @override
  _ConsultarCursosImpartidosProfesorScreenState createState() => _ConsultarCursosImpartidosProfesorScreenState();
}

class _ConsultarCursosImpartidosProfesorScreenState extends State<ConsultarCursosImpartidosProfesorScreen> {
  List<Map<String, dynamic>> _cursos = [];
  List<Map<String, dynamic>> _cuatrimestres = [];
  int? _selectedCuatrimestreId;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCuatrimestres();
  }

  Future<void> _fetchCuatrimestres() async {
    DatabaseHelper dbHelper = DatabaseHelper();
    List<Map<String, dynamic>> cuatrimestres = await dbHelper.getCuatrimestres();
    setState(() {
      _cuatrimestres = cuatrimestres;
      _isLoading = false;
    });
  }

  Future<void> _fetchCursosImpartidos() async {
    if (_selectedCuatrimestreId == null) return;
    setState(() {
      _isLoading = true;
    });
    DatabaseHelper dbHelper = DatabaseHelper();
    List<Map<String, dynamic>> cursos = await dbHelper.getCursosImpartidosPorProfesorYCuatrimestre(
        widget.profesorId, _selectedCuatrimestreId!);
    setState(() {
      _cursos = cursos;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Consultar Cursos Impartidos'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButtonFormField<int>(
              decoration: InputDecoration(labelText: 'Seleccionar Cuatrimestre'),
              items: _cuatrimestres.map((cuatrimestre) {
                return DropdownMenuItem<int>(
                  value: cuatrimestre['id_cua'],
                  child: Text(cuatrimestre['nombre_cua']),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCuatrimestreId = value;
                });
                _fetchCursosImpartidos();
              },
              validator: (value) => value == null ? 'Seleccione un cuatrimestre' : null,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _cursos.length,
                itemBuilder: (context, index) {
                  final curso = _cursos[index];
                  return ListTile(
                    title: Text(curso['nombre_cui']),
                    subtitle: Text('ID: ${curso['id_cui']}'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetallesCursoImpartidoScreen(cursoId: curso['id_cui']),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
