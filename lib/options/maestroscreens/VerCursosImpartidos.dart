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
    const Color naranjaClaro = Color(0xFFFFC107); // Color naranja claro

    return Scaffold(
      appBar: AppBar(
        title: Text('Consultar Cursos Impartidos'),
        backgroundColor: naranjaClaro,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: DropdownButtonFormField<int>(
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 16),
                  border: InputBorder.none,
                  hintText: 'Seleccionar Cuatrimestre',
                  hintStyle: TextStyle(color: Colors.grey),
                ),
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
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _cursos.length,
                itemBuilder: (context, index) {
                  final curso = _cursos[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 5,
                    child: ListTile(
                      contentPadding: EdgeInsets.all(16),
                      title: Text(
                        curso['nombre_cui'],
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text('ID: ${curso['id_cui']}'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetallesCursoImpartidoScreen(cursoId: curso['id_cui']),
                          ),
                        );
                      },
                    ),
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
