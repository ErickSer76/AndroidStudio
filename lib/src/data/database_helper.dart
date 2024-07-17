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
          "CREATE TABLE asignaturas(id_asi INTEGER PRIMARY KEY, id_car INTEGER, nombre_asi TEXT, descripcion_asi TEXT, FOREIGN KEY(id_car) REFERENCES carreras(id_car))",
        );
        await db.execute(
          "CREATE TABLE calificaciones(id_cal INTEGER PRIMARY KEY, id_est INTEGER, id_car INTEGER, id_asi INTEGER, calificacion_cal REAL, FOREIGN KEY(id_est) REFERENCES estudiantes(id_est), FOREIGN KEY(id_asi) REFERENCES asignaturas(id_asi), FOREIGN KEY(id_car) REFERENCES carreras(id_car))",
        );
        await db.execute(
          "CREATE TABLE carreras(id_car INTEGER PRIMARY KEY, nombre_car TEXT)",
        );
        await db.execute(
          "CREATE TABLE parcial(id_par INTEGER PRIMARY KEY, nombre_par TEXT)",
        );
        await db.execute(
            "CREATE TABLE cuatrimestre(id_cua INTEGER PRIMARY KEY, nombre_cua TEXT)",
        );
        await db.execute(
          "CREATE TABLE grupos(id_gru INTEGER PRIMARY KEY, nombre_gru TEXT, fechaini_gru TEXT, id_car INTEGER, FOREIGN KEY(id_car) REFERENCES carreras(id_car))",
        );

        // Insertar datos dummy
        await db.insert('users', {'id': 1, 'username': 'admin', 'password': 'admin123', 'tipo_user':'admin'});
        await db.insert('users', {'id': 2, 'username': 'user', 'password': 'user123', 'tipo_user':'maestro'});
        await db.insert('users', {'id': 3, 'username': 'erick serrano', 'password':'erick123', 'tipo_user':'alumno','id_est':2});
        await db.insert('users', {'id': 4, 'username': 'luis', 'password':'luis123', 'tipo_user':'alumno','id_est':1});

        await db.insert('estudiantes', {'id_est': 1, 'nombre_est': 'Luis', 'apellido_est':'Mapula', 'matricula_est':23040002, 'edad_est': 18, 'id_gru': 1,'direccion_est': 'Los Angeles', 'id_car': 1, 'user_id': 4});
        await db.insert('estudiantes', {'id_est': 2, 'nombre_est': 'Erick', 'apellido_est':'Serrano', 'matricula_est':23040004, 'edad_est': 18, 'id_gru': 1, 'direccion_est': 'Basuron', 'id_car': 1, 'user_id': 3});

        await db.insert('asignaturas', {'id_asi': 1, 'id_car':1, 'nombre_asi': 'Funciones Matematicas', 'descripcion_asi': 'Curso de Matemáticas'});
        await db.insert('asignaturas', {'id_asi': 2, 'id_car':1, 'nombre_asi': 'Interconexion de redes', 'descripcion_asi': 'Curso de redes'});

        await db.insert('calificaciones', {'id_cal': 1, 'id_est': 1, 'id_car':1, 'id_asi': 1, 'calificacion_cal': 85.5});
        await db.insert('calificaciones', {'id_cal': 2, 'id_est': 1, 'id_car':1,'id_asi': 2, 'calificacion_cal': 80.5});

        await db.insert('carreras', {'id_car': 1, 'nombre_car': 'Tecnologias de la Informacion'});
        await db.insert('carreras', {'id_car': 2, 'nombre_car': 'Gastronomia'});

        await db.insert('parcial', {'id_par': 1, 'nombre_par': 'parcial1-ene-abr'});

        await db.insert('cuatrimestre', {'id_cua': 1, 'nombre_cua':'Enero-Abril 2024'});

        await db.insert('grupos', {'id_gru': 1, 'nombre_gru': 'TI2', 'fechaini_gru':'2023-01-02', 'id_car': 1});
      },
    );
  }


  Future<List<Map<String, dynamic>>> getEstudiantes() async {
    final db = await database;
    return await db.query('estudiantes');
  }

  Future<List<Map<String, dynamic>>> getCalificaciones() async {
    final db = await database;
    return await db.query('calificaciones');
  }


  Future<void> insertUser(Map<String, dynamic> user) async {
    final db = await database;
    await db.insert('users', user, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<Map<String, dynamic>?> getDatosEstudiante(int userID) async {
    final db = await database;
    final result = await db.rawQuery('''
    SELECT estudiantes.*, carreras.nombre_car as nombre_car, grupos.nombre_gru as nombre_gru
    FROM estudiantes
    INNER JOIN carreras ON estudiantes.id_car = carreras.id_car
    INNER JOIN grupos ON estudiantes.id_gru = grupos.id_gru
    WHERE estudiantes.user_id = ?  
    ''', [userID]);

    if (result.isNotEmpty) {
      return result.first;
    }
    return null;
  }

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