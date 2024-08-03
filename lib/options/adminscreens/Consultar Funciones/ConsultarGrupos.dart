import 'package:flutter/material.dart';
import 'package:proyect1/options/adminscreens/Consultar%20Funciones/ConsEstudianteyProfesor/DatosdeGrupo.dart';
import '/src/data/database_helper.dart';

class ConsultarGruposScreen extends StatefulWidget {
  @override
  _ConsultarGruposScreenState createState() => _ConsultarGruposScreenState();
}

class _ConsultarGruposScreenState extends State<ConsultarGruposScreen> {
  List<Map<String, dynamic>> _grupos = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchGrupos();
  }

  Future<void> _fetchGrupos() async {
    DatabaseHelper dbHelper = DatabaseHelper();
    List<Map<String, dynamic>> grupos = await dbHelper.getGrupos();
    setState(() {
      _grupos = grupos;
      _isLoading = false;
    });
  }

  Future<void> _fetchDatosMateria(int grupoID) async {
    DatabaseHelper dbHelper = DatabaseHelper();
    Map<String, dynamic>? grupo = await dbHelper.getDatosGrupos(grupoID);
    if (grupo != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DatosdeGrupoScreen(grupo: grupo),
        ),
      );
    }
  }

  Future<void> _eliminarGrupo(int grupoID) async {
    DatabaseHelper dbHelper = DatabaseHelper();
    await dbHelper.deleteGrupo(grupoID);
    _fetchGrupos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Consultar Grupos'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _grupos.length,
                itemBuilder: (context, index) {
                  final grupo = _grupos[index];
                  return ListTile(
                    title: Text(grupo['nombre_gru']),
                    subtitle: Text('Fecha de Inicio: ${grupo['fechaini_gru']}'),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () async {
                        bool? confirm = await showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Confirmar eliminación'),
                            content: Text('¿Estás seguro de que quieres eliminar este grupo?'),
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
                          _eliminarGrupo(grupo['id_gru']);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Grupo eliminado exitosamente')),
                          );
                        }
                      },
                    ),
                    onTap: () {
                      _fetchDatosMateria(grupo['id_gru']);
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
