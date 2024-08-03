import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sql.dart';
import 'package:path/path.dart';
class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }


  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'my_database.db');

    // Eliminar la base de datos existente (solo para pruebas)
    await deleteDatabase(path);

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
          "CREATE TABLE users(id INTEGER PRIMARY KEY, username TEXT, password TEXT, tipo_user TEXT, id_est INTEGER)",
        );
        await db.execute(
          "CREATE TABLE estudiantes(id_est INTEGER PRIMARY KEY, nombre_est TEXT, apellido_est TEXT, matricula_est INTEGER, edad_est INTEGER, id_gru INTEGER, direccion_est TEXT, id_car INTEGER, user_id INTEGER, FOREIGN KEY(id_gru) REFERENCES grupos(id_gru), FOREIGN KEY(id_car) REFERENCES carreras(id_car), FOREIGN KEY(user_id) REFERENCES users(id))",
        );
        await db.execute(
          "CREATE TABLE profesores(id_pro INTEGER PRIMARY KEY, nombre_pro TEXT, apellido_pro TEXT, edad_pro INTEGER, direccion_pro TEXT, user_id INTEGER, FOREIGN KEY(user_id) REFERENCES users(id))",
        );
        await db.execute(
          "CREATE TABLE asignaturas(id_asi INTEGER PRIMARY KEY, id_car INTEGER, nombre_asi TEXT, descripcion_asi TEXT, FOREIGN KEY(id_car) REFERENCES carreras(id_car))",
        );
        await db.execute(
          "CREATE TABLE calificaciones(id_cal INTEGER PRIMARY KEY, id_est INTEGER, id_car INTEGER, id_gru INTEGER, id_asi INTEGER, id_par INTEGER, id_cua INTEGER, calificacion_cal REAL, FOREIGN KEY(id_est) REFERENCES estudiantes(id_est), FOREIGN KEY(id_asi) REFERENCES asignaturas(id_asi), FOREIGN KEY(id_gru) REFERENCES grupos(id_gru), FOREIGN KEY(id_car) REFERENCES carreras(id_car), FOREIGN KEY(id_par) REFERENCES parcial(id_par), FOREIGN KEY(id_cua) REFERENCES cuatrimestre(id_cua))",
        );
        await db.execute(
          "CREATE TABLE carreras(id_car INTEGER PRIMARY KEY, nombre_car TEXT)",
        );
        await db.execute(
          "CREATE TABLE parcial(id_par INTEGER PRIMARY KEY, nombre_par TEXT, id_cua TEXT)",
        );
        await db.execute(
            "CREATE TABLE cuatrimestre(id_cua INTEGER PRIMARY KEY, nombre_cua TEXT)",
        );
        await db.execute(
          "CREATE TABLE grupos(id_gru INTEGER PRIMARY KEY, nombre_gru TEXT, fechaini_gru TEXT, id_car INTEGER, FOREIGN KEY(id_car) REFERENCES carreras(id_car))",
        );
        await db.execute(
          'CREATE TABLE curso_impartido(id_cui INTEGER PRIMARY KEY, nombre_cui TEXT, id_pro INTEGER, id_asi INTEGER, id_gru INTEGER, id_car INTEGER, id_cua INTEGER, FOREIGN KEY(id_pro) REFERENCES profesores(id_pro), FOREIGN KEY(id_asi) REFERENCES asignaturas(id_asi), FOREIGN KEY(id_gru) REFERENCES grupos(id_gru), FOREIGN KEY(id_car) REFERENCES carreras(id_car), FOREIGN KEY(id_cua) REFERENCES cuatrimestre(id_cua))',
        );

        // Insertar datos dummy
        await db.insert('users', {'id': 1, 'username': 'admin', 'password': 'admin123', 'tipo_user':'admin'});
        await db.insert('users', {'id': 2, 'username': 'joel', 'password': 'joel123', 'tipo_user':'maestro'});
        await db.insert('users', {'id': 3, 'username': 'erick serrano', 'password':'erick123', 'tipo_user':'alumno','id_est':2});
        await db.insert('users', {'id': 4, 'username': 'luis', 'password':'luis123', 'tipo_user':'alumno','id_est':1});
        await db.insert('users', {'id': 5, 'username': 'osmar', 'password':'osmar123', 'tipo_user':'alumno','id_est':3});
        await db.insert('users', {'id': 6, 'username': 'alberto', 'password':'alberto123', 'tipo_user':'alumno','id_est':4});
        await db.insert('users', {'id': 7, 'username': 'juan', 'password':'juan123', 'tipo_user':'maestro'});


        await db.insert('estudiantes', {'id_est': 1, 'nombre_est': 'Luis Alberto', 'apellido_est':'Mapula Garcia', 'matricula_est':23040002, 'edad_est': 18, 'id_gru': 1,'direccion_est': 'Los Angeles', 'id_car': 1, 'user_id': 4});
        await db.insert('estudiantes', {'id_est': 2, 'nombre_est': 'Erick Nolberto', 'apellido_est':'Serrano Mendoza', 'matricula_est':23040004, 'edad_est': 18, 'id_gru': 1, 'direccion_est': 'Basuron', 'id_car': 1, 'user_id': 3});
        await db.insert('estudiantes', {'id_est': 3, 'nombre_est': 'Osmar', 'apellido_est':'Niebla Olachea', 'matricula_est':23040003, 'edad_est': 18, 'id_gru': 1, 'direccion_est': 'Las Colinas', 'id_car': 1, 'user_id': 5});
        await db.insert('estudiantes', {'id_est': 4, 'nombre_est': 'Alberto', 'apellido_est':'Medina Ochoa', 'matricula_est':23050001, 'edad_est': 18, 'id_gru': 2, 'direccion_est': 'Las Colinas', 'id_car': 2, 'user_id': 6});


        await db.insert('profesores', {'id_pro': 1, 'nombre_pro': 'Joel', 'apellido_pro': 'Vazquez', 'edad_pro': 29, 'direccion_pro': 'Las colinas', 'user_id':2});
        await db.insert('profesores', {'id_pro': 2, 'nombre_pro': 'Juan', 'apellido_pro': 'Valdez', 'edad_pro': 31, 'direccion_pro': 'Valle Alto', 'user_id':7});


        await db.insert('asignaturas', {'id_asi': 1, 'id_car':1, 'nombre_asi': 'Funciones Matematicas', 'descripcion_asi': 'Curso de Matemáticas'});
        await db.insert('asignaturas', {'id_asi': 2, 'id_car':1, 'nombre_asi': 'Interconexion de redes', 'descripcion_asi': 'Curso de redes'});
        await db.insert('asignaturas', {'id_asi': 3, 'id_car':2, 'nombre_asi': 'Matematicas Aplicadas a la Gastronomia', 'descripcion_asi': 'Materia de Matematicas'});

        await db.insert('calificaciones', {'id_cal': 1, 'id_est': 1, 'id_car':1, 'id_gru': 1, 'id_asi': 1, 'id_par': 1, 'id_cua': 1, 'calificacion_cal': 85.5});
        await db.insert('calificaciones', {'id_cal': 2, 'id_est': 2, 'id_car':1, 'id_gru': 1, 'id_asi': 2, 'id_par': 2, 'id_cua': 1, 'calificacion_cal': 80.5});

        await db.insert('carreras', {'id_car': 1, 'nombre_car': 'Tecnologias de la Informacion'});
        await db.insert('carreras', {'id_car': 2, 'nombre_car': 'Gastronomia'});

        await db.insert('parcial', {'id_par': 1, 'nombre_par': 'Parcial1 Ene-Abr-2024', 'id_cua': 1});
        await db.insert('parcial', {'id_par': 2, 'nombre_par': 'Parcial2  Ene-Abr-2024', 'id_cua': 1});
        await db.insert('parcial', {'id_par': 3, 'nombre_par': 'Parcial3  Ene-Abr-2024', 'id_cua': 1});

        await db.insert('cuatrimestre', {'id_cua': 1, 'nombre_cua':'Enero-Abril 2024'});

        await db.insert('grupos', {'id_gru': 1, 'nombre_gru': 'TI2', 'fechaini_gru':'2023-01-02', 'id_car': 1});
        await db.insert('grupos', {'id_gru': 2, 'nombre_gru': 'GAS2', 'fechaini_gru':'2023-01-02', 'id_car': 2});


        await db.insert('curso_impartido', {'id_cui': 1, 'nombre_cui':'Curso Interconexion de redes','id_pro': 1, 'id_asi':1, 'id_gru': 1, 'id_car':1, 'id_cua':1});
      },
    );
  }

  //FUNCIONES DE USUARIO ADMINISTRADOR

    //Insertar usuarios
  Future<int> insertUserA(Map<String, dynamic> user) async {
    final db = await database;
    return await db.insert('users', user);
  }
    //Insertar estudiantes
  Future<int> insertEstudiante(Map<String, dynamic> estudiante) async {
    final db = await database;
    return await db.insert('estudiantes', estudiante);
  }
    //AGREGA estudiantes y usuarios
  Future<void> agregarEstudiante(String username, String password, String tipouser, String nombre, String apellido, int matricula, int edad, String direccion, int idGrupos, int idCarrera) async {
    final db = await database;

    // Inicia una transacción
    await db.transaction((txn) async {
      // Inserta en la tabla users
      int userId = await txn.insert('users', {
        'username': username,
        'password': password,
        'tipo_user': tipouser,
      });

      // Inserta en la tabla estudiantes con el user_id generado
      await txn.insert('estudiantes', {
        'user_id': userId,
        'nombre_est': nombre,
        'apellido_est': apellido,
        'matricula_est': matricula,
        'edad_est': edad,
        'id_gru': idGrupos,
        'direccion_est': direccion,
        'id_car': idCarrera,
      });
    });
  }

  //Elimina Estudiantes y Usuarios
  Future<void> deleteEstudianteYUsuario(int userId) async {
    final db = await database;
    await db.transaction((txn) async {
      await txn.delete('estudiantes', where: 'user_id = ?', whereArgs: [userId]);
      await txn.delete('users', where: 'id = ?', whereArgs: [userId]);
    });
  }

  //AGREGA profesores y usuarios
  Future<void> agregarProfesor(String username, String password, String tipouser, String nombre, String apellido, int edad, String direccion) async {
    final db = await database;

    // Inicia una transacción
    await db.transaction((txn) async {
      // Inserta en la tabla users
      int userId = await txn.insert('users', {
        'username': username,
        'password': password,
        'tipo_user': tipouser,
      });

      // Inserta en la tabla profesores con el user_id generado
      await txn.insert('profesores', {
        'user_id': userId,
        'nombre_pro': nombre,
        'apellido_pro': apellido,
        'edad_pro': edad,
        'direccion_pro': direccion,
      });
    });
  }

  //ELIMINA Profesores y Usuarios
  Future<void> deleteProfesorYUsuario(int userId) async {
    final db = await database;
    await db.transaction((txn) async {
      await txn.delete('profesores', where: 'user_id = ?', whereArgs: [userId]);
      await txn.delete('users', where: 'id = ?', whereArgs: [userId]);
    });
  }


  //MATERIAS
  //AGREGA Materias
  Future<void> insertMateria(Map<String, dynamic> asignatura) async {
    final db = await database;
    await db.insert('asignaturas', asignatura);
  }

  //CONSULTA materias
  Future<List<Map<String, dynamic>>> getMaterias() async {
    final db = await database;
    return await db.query('asignaturas');
  }

  //CONSULTA datos de Materias
  Future<Map<String, dynamic>?> getDatosMateria(int carreraID) async {
    final db = await database;
    final result = await db.rawQuery('''
    SELECT asignaturas.*, carreras.nombre_car as nombre_car
    FROM asignaturas
    INNER JOIN carreras ON asignaturas.id_car = carreras.id_car
    WHERE asignaturas.id_asi = ?  
    ''', [carreraID]);

    if (result.isNotEmpty) {
      return result.first;
    }
    return null;
  }

  //ELIMINA Datos de Materias
  Future<void> deleteMateria(int materiaID) async {
    final db = await database;
    await db.delete('asignaturas', where: 'id_asi = ?', whereArgs: [materiaID]);
  }


  //CARRERAS
  //AGREGA Carreras
  Future<void> insertCarrera(Map<String, dynamic> carrera) async {
    final db = await database;
    await db.insert('carreras', carrera);
  }

  //CONSULTA Carreras
  Future<List<Map<String, dynamic>>> getCarreras() async {
    final db = await database;
    return await db.query('carreras');
  }

  //CONSULTA datos de Carreras
  Future<Map<String, dynamic>?> getDatoscarrera(int carreraID) async {
    final db = await database;
    final result = await db.rawQuery('''
    SELECT *
    FROM carreras
    WHERE id_car = ?  
    ''', [carreraID]);

    if (result.isNotEmpty) {
      return result.first;
    }
    return null;
  }

  //ELIMINA carreras
  Future<void> deleteCarrera(int idCarrera) async {
    final db = await database;
    await db.delete('carreras', where: 'id_car = ?', whereArgs: [idCarrera]);
  }



  //AGREGA Parciales
  Future<void> insertParcial(Map<String, dynamic> parcial) async {
    final db = await database;
    await db.insert('parcial', parcial);
  }

  //CONSULTA Parciales
  Future<List<Map<String, dynamic>>> getParciales() async {
    final db = await database;
    return await db.query('parcial');
  }

  //CONSULTA datos de Parciales
  Future<Map<String, dynamic>?> getDatosparcial(int parcialID) async {
    final db = await database;
    final result = await db.rawQuery('''
    SELECT parcial.*, cuatrimestre.nombre_cua as nombre_cua
    FROM parcial
    INNER JOIN cuatrimestre ON parcial.id_cua = cuatrimestre.id_cua
    WHERE id_par = ?  
    ''', [parcialID]);

    if (result.isNotEmpty) {
      return result.first;
    }
    return null;
  }

  //ELIMINA Parciales
  Future<void> deleteParcial(int parcialID) async {
    final db = await database;
    await db.delete('parcial', where: 'id_par = ?', whereArgs: [parcialID]);
  }

  //CUATRIMESTRE
  //AGREGA Cuatrimestres
  Future<void> insertCuatrimestre(Map<String, dynamic> cuatrimestre) async {
    final db = await database;
    await db.insert('cuatrimestre', cuatrimestre);
  }

  //CONSULTA Cuatrimestres
  Future<List<Map<String, dynamic>>> getCuatrimestres() async {
    final db = await database;
    return await db.query('cuatrimestre');
  }

  //CONSULTA datos de Cuatrimestres
  Future<Map<String, dynamic>?> getDatosCuatrimestre(int cuatrimestreID) async {
    final db = await database;
    final result = await db.rawQuery('''
    SELECT *
    FROM cuatrimestre
    WHERE id_cua = ?  
    ''', [cuatrimestreID]);

    if (result.isNotEmpty) {
      return result.first;
    }
    return null;
  }

  //ELIMINA cuatrimestres
  Future<void> deleteCuatrimestre(int idCuatrimestre) async {
    final db = await database;
    await db.delete('cuatrimestre', where: 'id_cua = ?', whereArgs: [idCuatrimestre]);
  }

  //Consulta datos de Cursos Impartidos
  Future<List<Map<String, dynamic>>> getCursosImpartidos() async {
    final db = await database;
    return await db.query('curso_impartido');
  }
  //CONSULTA datos de Cursos Impartidos
  Future<Map<String, dynamic>?> getDatosCursosImpartidos(int cursoImpID) async {
    final db = await database;
    final result = await db.rawQuery('''
    SELECT curso_impartido.*,
     profesores.nombre_pro as nombre_pro,
     profesores.apellido_pro as apellido_pro,
     asignaturas.nombre_asi as nombre_asi,
     grupos.nombre_gru as nombre_gru,
     carreras.nombre_car as nombre_car,
     cuatrimestre.nombre_cua as nombre_cua
    FROM curso_impartido
    INNER JOIN profesores ON curso_impartido.id_pro = profesores.id_pro
    INNER JOIN asignaturas ON curso_impartido.id_asi = asignaturas.id_asi
    INNER JOIN grupos ON curso_impartido.id_gru = grupos.id_gru
    INNER JOIN carreras ON curso_impartido.id_car = carreras.id_car
    INNER JOIN cuatrimestre ON curso_impartido.id_cua = cuatrimestre.id_cua
    WHERE id_cui = ?  
    ''', [cursoImpID]);

    if (result.isNotEmpty) {
      return result.first;
    }
    return null;
  }

  //ELIMINA Cursos Impartidos
  Future<void> deleteCursoImpartido(int cursoImpID) async {
    final db = await database;
    await db.delete('curso_impartido', where: 'id_cui = ?', whereArgs: [cursoImpID]);
  }

  //GRUPOS
  //AGREGA Grupos
  Future<void> insertGrupos(Map<String, dynamic> grupo) async {
    final db = await database;
    await db.insert('grupos', grupo);
  }

  //CONSULTA Grupos
  Future<List<Map<String, dynamic>>> getGrupos() async {
    final db = await database;
    return await db.query('grupos');
  }

  //CONSULTA datos de Grupos
  Future<Map<String, dynamic>?> getDatosGrupos(int grupoID) async {
    final db = await database;
    final result = await db.rawQuery('''
    SELECT grupos.*, carreras.nombre_car as nombre_car
    FROM grupos
    INNER JOIN carreras ON grupos.id_car = carreras.id_car
    WHERE grupos.id_gru = ?  
    ''', [grupoID]);

    if (result.isNotEmpty) {
      return result.first;
    }
    return null;
  }

  //ELIMINA Grupos
  Future<void> deleteGrupo(int grupoID) async {
    final db = await database;
    await db.delete('grupos', where: 'id_gru = ?', whereArgs: [grupoID]);
  }

    Future<List<Map<String, dynamic>>> getEstudiantes() async {
    final db = await database;
    return await db.query('estudiantes');
  }

  Future<List<Map<String, dynamic>>> getProfesores() async {
    final db = await database;
    return await db.query('profesores');
  }

  Future<List<Map<String, dynamic>>> getCalificaciones() async {
    final db = await database;
    return await db.query('calificaciones');
  }

  //FUNCIONES DE USUARIO PROFESOR y estudiante

  //INSERTAR calificacion
  Future<int> insertCalificacion(Map<String, dynamic> calificacion) async {
    final db = await database;
    return await db.insert('calificaciones', calificacion);
  }

  //INSERTAR curso impartido
  Future<int> insertCursoImpartido(Map<String, dynamic> cursoimpartido) async {
    final db = await database;
    return await db.insert('curso_impartido', cursoimpartido);
  }

  //FILTRO Obtener Alumnos mediante grupos
  Future<List<Map<String, dynamic>>> getEstudiantesPorGrupo(int idGrupo) async {
    final db = await database;
    return await db.query(
      'estudiantes',
      where: 'id_gru = ?',
      whereArgs: [idGrupo],
    );
  }

  //FILTRO Obtener Parciales por cuatrimestre
  Future<List<Map<String, dynamic>>> getParcialesPorCuatrimestre(int idCuatrimestre) async {
    final db = await database;
    return await db.query(
      'parcial',
      where: 'id_cua = ?',
      whereArgs: [idCuatrimestre],
    );
  }

  //Obtener Calificaciones por estudiante
  Future<List<Map<String, dynamic>>> getCalificacionesPorEstudiante(int estudianteId) async {
    final db = await database;
    return await db.rawQuery('''
    SELECT calificaciones.*, estudiantes.nombre_est as nombre_est, estudiantes.apellido_est as apellido_est,  
    asignaturas.nombre_asi as nombre_asi, parcial.nombre_par as nombre_par, cuatrimestre.nombre_cua as nombre_cua
    FROM calificaciones
    INNER JOIN estudiantes ON calificaciones.id_est = estudiantes.id_est
    INNER JOIN asignaturas ON calificaciones.id_asi = asignaturas.id_asi
    INNER JOIN parcial ON calificaciones.id_par = parcial.id_par
    INNER JOIN cuatrimestre ON calificaciones.id_cua = cuatrimestre.id_cua
    WHERE calificaciones.id_est = ?
  ''', [estudianteId]);
  }

  //Obtener curso impartido por varios datos
  Future<List<Map<String, dynamic>>> getCursosImpartidosPorProfesor(int cursoID) async {
    final db = await database;
    return await db.rawQuery('''
    SELECT curso_impartido.*,
     profesores.nombre_pro as nombre_pro,
     profesores.apellido_pro as apellido_pro,
     asignaturas.nombre_asi as nombre_asi,
     grupos.nombre_gru as nombre_gru,
     carreras.nombre_car as nombre_car,
     cuatrimestre.nombre_cua as nombre_cua
    FROM curso_impartido
    INNER JOIN profesores ON curso_impartido.id_pro = profesores.id_pro
    INNER JOIN asignaturas ON curso_impartido.id_asi = asignaturas.id_asi
    INNER JOIN grupos ON curso_impartido.id_gru = grupos.id_gru
    INNER JOIN carreras ON curso_impartido.id_car = carreras.id_car
    INNER JOIN cuatrimestre ON curso_impartido.id_cua = cuatrimestre.id_cua
    WHERE curso_impartido.id_pro = ?
    ''', [cursoID]);
  }

  //Obtener curso impartido para Profesor
  Future<List<Map<String, dynamic>>> getCursosImpartidosPorProfesorYCuatrimestre(int profesorId, int cuatrimestreId) async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.query(
      'curso_impartido',
      where: 'id_pro = ? AND id_cua = ?',
      whereArgs: [profesorId, cuatrimestreId],
    );
    return result;
  }

  //DETALLES de curso impartido para profesor
  Future<Map<String, dynamic>> getDetallesCursoImpartido(int cursoId) async {
    Database db = await database;

    // Query to get course details including group and career
    var curso = await db.query('curso_impartido', where: 'id_cui = ?', whereArgs: [cursoId]);
    if (curso.isNotEmpty) {
      var grupo = await db.query('grupos', where: 'id_gru = ?', whereArgs: [curso[0]['id_gru']]);
      var carrera = await db.query('carreras', where: 'id_car = ?', whereArgs: [grupo[0]['id_car']]);
      var estudiantes = await db.query('estudiantes', where: 'id_gru = ?', whereArgs: [curso[0]['id_gru']]);

      return {
        'curso_impartido': curso[0],
        'grupos': grupo[0],
        'carreras': carrera[0],
        'estudiantes': estudiantes,
      };
    }
    return {};
  }

  //Obtener calificaciones por estudiantes con filtros de Parcial y Cuatrimestre:

  Future<List<Map<String, dynamic>>> getCalificacionesPorEstudianteConFiltros(
      int estudianteID, {String? parcial, String? cuatrimestre}) async {
    final db = await database;
    String whereString = 'estudianteID = ?';
    List<dynamic> whereArguments = [estudianteID];

    if (parcial != null) {
      whereString += ' AND nombre_par = ?';
      whereArguments.add(parcial);
    }
    if (cuatrimestre != null) {
      whereString += ' AND nombre_cua = ?';
      whereArguments.add(cuatrimestre);
    }

    final List<Map<String, dynamic>> result = await db.query(
      'calificaciones',
      where: whereString,
      whereArgs: whereArguments,
    );

    return result;
  }




  //FUNCIONES DE USUARIO ESTUDIANTE

  Future<void> insertUser(Map<String, dynamic> user) async {
    final db = await database;
    await db.insert('users', user, conflictAlgorithm: ConflictAlgorithm.replace);
  }
  //Obtener datos de Estudiante en Estudiantes
  Future<Map<String, dynamic>?> getDatosEstudiante(int userID) async {
    final db = await database;
    final result = await db.rawQuery('''
    SELECT estudiantes.*, carreras.nombre_car as nombre_car, grupos.nombre_gru as nombre_gru, users.username as username, users.password as password
    FROM estudiantes
    INNER JOIN carreras ON estudiantes.id_car = carreras.id_car
    INNER JOIN grupos ON estudiantes.id_gru = grupos.id_gru
    INNER JOIN users ON estudiantes.user_id = users.id
    WHERE estudiantes.user_id = ?  
    ''', [userID]);

    if (result.isNotEmpty) {
      return result.first;
    }
    return null;
  }

  //Obtener datos de Profesor en Profesores
  Future<Map<String, dynamic>?> getDatosProfesor(int userID) async {
    final db = await database;
    final result = await db.rawQuery('''
    SELECT profesores.*, users.username as username, users.password as password
    FROM profesores
    INNER JOIN users ON profesores.user_id = users.id
    WHERE profesores.user_id = ?  
    ''', [userID]);

    if (result.isNotEmpty) {
      return result.first;
    }
    return null;
  }

  //Obtener usuarios en el inicio de sesion
  Future<Map<String, dynamic>?> getUser(String username, String password) async {
    final db = await database;
    List<Map<String, dynamic>> results = await db.query(
      'users',
      where: "username = ? AND password = ?",
      whereArgs: [username, password],
    );
    return results.isNotEmpty ? results.first : null;
  }
}