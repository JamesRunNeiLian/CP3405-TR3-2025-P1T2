import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'smartseat.db');
    
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Create users table
    await db.execute('''
      CREATE TABLE users(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        email TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL,
        role TEXT NOT NULL,
        full_name TEXT,
        student_id TEXT,
        created_at TEXT NOT NULL
      )
    ''');

    // Create classrooms table
    await db.execute('''
      CREATE TABLE classrooms(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        building TEXT NOT NULL,
        room_number TEXT NOT NULL,
        capacity INTEGER NOT NULL,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    ''');

    // Create seats table
    await db.execute('''
      CREATE TABLE seats(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        classroom_id INTEGER NOT NULL,
        seat_number TEXT NOT NULL,
        row_number INTEGER NOT NULL,
        column_number INTEGER NOT NULL,
        is_available INTEGER NOT NULL DEFAULT 1,
        FOREIGN KEY (classroom_id) REFERENCES classrooms (id) ON DELETE CASCADE
      )
    ''');

    // Create reservations table
    await db.execute('''
      CREATE TABLE reservations(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        seat_id INTEGER NOT NULL,
        classroom_id INTEGER NOT NULL,
        reservation_date TEXT NOT NULL,
        start_time TEXT NOT NULL,
        end_time TEXT NOT NULL,
        status TEXT NOT NULL,
        created_at TEXT NOT NULL,
        FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE,
        FOREIGN KEY (seat_id) REFERENCES seats (id) ON DELETE CASCADE,
        FOREIGN KEY (classroom_id) REFERENCES classrooms (id) ON DELETE CASCADE
      )
    ''');

    // Create layouts table
    await db.execute('''
      CREATE TABLE layouts(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        classroom_id INTEGER NOT NULL,
        layout_name TEXT NOT NULL,
        layout_data TEXT NOT NULL,
        created_by INTEGER NOT NULL,
        is_active INTEGER NOT NULL DEFAULT 0,
        created_at TEXT NOT NULL,
        FOREIGN KEY (classroom_id) REFERENCES classrooms (id) ON DELETE CASCADE,
        FOREIGN KEY (created_by) REFERENCES users (id) ON DELETE CASCADE
      )
    ''');

    // Insert sample admin user
    await db.insert('users', {
      'email': 'admin@example.com',
      'password': 'admin123', // In production, use proper password hashing
      'role': 'admin',
      'full_name': 'System Administrator',
      'created_at': DateTime.now().toIso8601String(),
    });

    // Insert sample lecturer
    await db.insert('users', {
      'email': 'lecturer@example.com',
      'password': 'lecturer123',
      'role': 'lecturer',
      'full_name': 'Dr. Tan',
      'created_at': DateTime.now().toIso8601String(),
    });

    // Insert sample student
    await db.insert('users', {
      'email': 'student@my.jcu.edu.au',
      'password': 'student123',
      'role': 'student',
      'full_name': 'Dennis',
      'student_id': 'jd123456',
      'created_at': DateTime.now().toIso8601String(),
    });
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Handle database upgrades here
    if (oldVersion < newVersion) {
      // Add migration logic as needed
    }
  }

  // User operations
  Future<int> insertUser(Map<String, dynamic> user) async {
    Database db = await database;
    return await db.insert('users', user);
  }

  Future<Map<String, dynamic>?> getUser(String email, String password) async {
    Database db = await database;
    List<Map<String, dynamic>> results = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );
    return results.isNotEmpty ? results.first : null;
  }

  Future<Map<String, dynamic>?> getUserById(int id) async {
    Database db = await database;
    List<Map<String, dynamic>> results = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );
    return results.isNotEmpty ? results.first : null;
  }

  Future<List<Map<String, dynamic>>> getAllUsers() async {
    Database db = await database;
    return await db.query('users');
  }

  Future<int> updateUser(int id, Map<String, dynamic> user) async {
    Database db = await database;
    return await db.update('users', user, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteUser(int id) async {
    Database db = await database;
    return await db.delete('users', where: 'id = ?', whereArgs: [id]);
  }

  // Classroom operations
  Future<int> insertClassroom(Map<String, dynamic> classroom) async {
    Database db = await database;
    return await db.insert('classrooms', classroom);
  }

  Future<List<Map<String, dynamic>>> getAllClassrooms() async {
    Database db = await database;
    return await db.query('classrooms');
  }

  Future<Map<String, dynamic>?> getClassroom(int id) async {
    Database db = await database;
    List<Map<String, dynamic>> results = await db.query(
      'classrooms',
      where: 'id = ?',
      whereArgs: [id],
    );
    return results.isNotEmpty ? results.first : null;
  }

  Future<int> updateClassroom(int id, Map<String, dynamic> classroom) async {
    Database db = await database;
    return await db.update('classrooms', classroom, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteClassroom(int id) async {
    Database db = await database;
    return await db.delete('classrooms', where: 'id = ?', whereArgs: [id]);
  }

  // Seat operations
  Future<int> insertSeat(Map<String, dynamic> seat) async {
    Database db = await database;
    return await db.insert('seats', seat);
  }

  Future<List<Map<String, dynamic>>> getSeatsByClassroom(int classroomId) async {
    Database db = await database;
    return await db.query('seats', where: 'classroom_id = ?', whereArgs: [classroomId]);
  }

  Future<int> updateSeat(int id, Map<String, dynamic> seat) async {
    Database db = await database;
    return await db.update('seats', seat, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteSeat(int id) async {
    Database db = await database;
    return await db.delete('seats', where: 'id = ?', whereArgs: [id]);
  }

  // Reservation operations
  Future<int> insertReservation(Map<String, dynamic> reservation) async {
    Database db = await database;
    return await db.insert('reservations', reservation);
  }

  Future<List<Map<String, dynamic>>> getReservationsByUser(int userId) async {
    Database db = await database;
    return await db.query('reservations', where: 'user_id = ?', whereArgs: [userId]);
  }

  Future<List<Map<String, dynamic>>> getReservationsByClassroom(int classroomId) async {
    Database db = await database;
    return await db.query('reservations', where: 'classroom_id = ?', whereArgs: [classroomId]);
  }

  Future<int> updateReservation(int id, Map<String, dynamic> reservation) async {
    Database db = await database;
    return await db.update('reservations', reservation, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteReservation(int id) async {
    Database db = await database;
    return await db.delete('reservations', where: 'id = ?', whereArgs: [id]);
  }

  // Layout operations
  Future<int> insertLayout(Map<String, dynamic> layout) async {
    Database db = await database;
    return await db.insert('layouts', layout);
  }

  Future<List<Map<String, dynamic>>> getLayoutsByClassroom(int classroomId) async {
    Database db = await database;
    return await db.query('layouts', where: 'classroom_id = ?', whereArgs: [classroomId]);
  }

  Future<Map<String, dynamic>?> getActiveLayout(int classroomId) async {
    Database db = await database;
    List<Map<String, dynamic>> results = await db.query(
      'layouts',
      where: 'classroom_id = ? AND is_active = 1',
      whereArgs: [classroomId],
    );
    return results.isNotEmpty ? results.first : null;
  }

  Future<int> updateLayout(int id, Map<String, dynamic> layout) async {
    Database db = await database;
    return await db.update('layouts', layout, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteLayout(int id) async {
    Database db = await database;
    return await db.delete('layouts', where: 'id = ?', whereArgs: [id]);
  }

  // Utility methods
  Future<void> clearAllTables() async {
    Database db = await database;
    await db.delete('reservations');
    await db.delete('layouts');
    await db.delete('seats');
    await db.delete('classrooms');
    await db.delete('users');
  }

  Future<void> closeDatabase() async {
    Database db = await database;
    await db.close();
  }
}