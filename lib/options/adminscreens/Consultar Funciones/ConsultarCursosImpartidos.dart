import 'package:flutter/material.dart';
import 'package:proyect1/options/adminscreens/Consultar%20Funciones/ConsEstudianteyProfesor/DatosCursosImpartidos.dart';
import '/src/data/database_helper.dart';

class ConsultarCursoImpartidoScreen extends StatefulWidget {
  @override
  _ConsultarCursoImpartidoScreenState createState() => _ConsultarCursoImpartidoScreenState();
}

class _ConsultarCursoImpartidoScreenState extends State<ConsultarCursoImpartidoScreen> {
  List<Map<String, dynamic>> _cursosimpartidos = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCursosImpartidos();
  }

  Future<void> _fetchCursosImpartidos() async {
    DatabaseHelper dbHelper = DatabaseHelper();
    List<Map<String, dynamic>> cursosimpartidos = await dbHelper.getCursosImpartidos();
    setState(() {
      _cursosimpartidos = cursosimpartidos;
      _isLoading = false;
    });
  }

  Future<void> _fetchDatosCursosImpartidos(int cursoImpID) async {
    DatabaseHelper dbHelper = DatabaseHelper();
    Map<String, dynamic>? cursoimpartido = await dbHelper.getDatosCursosImpartidos(cursoImpID);
    if (cursoimpartido != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DatosdeCursoImpartidoScreen(cursoimpartido: cursoimpartido),
        ),
      );
    }
  }

  Future<void> _eliminarCursoImpartido(int cursoImpID) async {
    DatabaseHelper dbHelper = DatabaseHelper();
    await dbHelper.deleteCursoImpartido(cursoImpID);
    _fetchCursosImpartidos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Consultar Curso Impartido'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _cursosimpartidos.length,
                itemBuilder: (context, index) {
                  final cursoimpartido = _cursosimpartidos[index];
                  return ListTile(
                    title: Text(cursoimpartido['nombre_cui']),
                    subtitle: Text('ID: ${cursoimpartido['id_cui']}'),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () async {
                        bool? confirm = await showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Confirmar eliminación'),
                            content: Text('¿Estás seguro de que quieres eliminar este curso impartido?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: Text('Cancelar'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: Text('Eliminar'),
                              ),
                            ],
                          ),
                        );

                        if (confirm == true) {
                          _eliminarCursoImpartido(cursoimpartido['id_cui']);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Curso impartido eliminado exitosamente')),
                          );
                        }
                      },
                    ),
                    onTap: () {
                      _fetchDatosCursosImpartidos(cursoimpartido['id_cui']);
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
