import 'package:flutter/material.dart';
import '/src/data/database_helper.dart';

class DetallesCursoImpartidoScreen extends StatefulWidget {
  final int cursoId;

  DetallesCursoImpartidoScreen({required this.cursoId});

  @override
  _DetallesCursoImpartidoScreenState createState() => _DetallesCursoImpartidoScreenState();
}

class _DetallesCursoImpartidoScreenState extends State<DetallesCursoImpartidoScreen> {
  Map<String, dynamic>? _detallesCurso;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchDetallesCursoImpartido();
  }

  Future<void> _fetchDetallesCursoImpartido() async {
    DatabaseHelper dbHelper = DatabaseHelper();
    Map<String, dynamic> detallesCurso = await dbHelper.getDetallesCursoImpartido(widget.cursoId);
    setState(() {
      _detallesCurso = detallesCurso;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalles del Curso Impartido'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _detallesCurso == null
          ? Center(child: Text('No se encontraron detalles'))
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Curso: ${_detallesCurso!['curso_impartido']['nombre_cui']}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text('Grupo: ${_detallesCurso!['grupos']['nombre_gru']}',
            style: TextStyle(fontSize: 17),),
            Text('Carrera: ${_detallesCurso!['carreras']['nombre_car']}',
            style: TextStyle(fontSize: 17),),
            SizedBox(height: 20),
            Text('Estudiantes:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Expanded(
              child: ListView.builder(
                itemCount: _detallesCurso!['estudiantes'].length,
                itemBuilder: (context, index) {
                  final estudiante = _detallesCurso!['estudiantes'][index];
                  return ListTile(
                    title: Text('${estudiante['nombre_est']} ${estudiante['apellido_est']}'),
                    subtitle: Text('Matricula: ${estudiante['matricula_est']}'),
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
