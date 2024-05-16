import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class UserDatabase {
  late Database _db;

  Future<void> initDatabase() async {
    _db = await openDatabase(
      join(await getDatabasesPath(), 'user_database.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE users(id INTEGER PRIMARY KEY, username TEXT UNIQUE, password TEXT, name TEXT, email TEXT UNIQUE, phoneNumber TEXT, dob TEXT, gender TEXT, address TEXT)',
        );
      },
      version: 1,
    );
  }

  Future<void> insertUser(User user) async {
    await _db.insert(
      'users',
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.fail,
    );
  }

  Future<bool> loginUser(String username, String password) async {
    final List<Map<String, dynamic>> result = await _db.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );

    return result.isNotEmpty;
  }

  Future<User> getUserById(int userId) async {
    final List<Map<String, dynamic>> result = await _db.query(
      'users',
      where: 'id = ?',
      whereArgs: [userId],
    );

    if (result.isNotEmpty) {
      return User.fromMap(result.first);
    } else {
      throw Exception('User not found');
    }
  }

  Future<User> getUserByUsername(String username) async {
    final List<Map<String, dynamic>> result = await _db.query(
      'users',
      where: 'username = ?',
      whereArgs: [username],
    );

    if (result.isNotEmpty) {
      return User.fromMap(result.first);
    } else {
      throw Exception('User not found');
    }
  }

  Future<bool> registerUser(User user) async {
    try {
      await _db.insert(
        'users',
        user.toMap(),
        conflictAlgorithm: ConflictAlgorithm.fail,
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> isUsernameAvailable(String username) async {
    try {
      await getUserByUsername(username);
      return false; // Username exists
    } catch (_) {
      return true; // Username is available
    }
  }

  Future<bool> isEmailAvailable(String email) async {
    try {
      final List<Map<String, dynamic>> result = await _db.query(
        'users',
        where: 'email = ?',
        whereArgs: [email],
      );
      return result.isEmpty; // Email is available if result is empty
    } catch (_) {
      return true; // Email is available
    }
  }
}

class User {
  final int? id;
  final String username;
  final String password;
  final String name;
  final String email;
  final String phoneNumber;
  final String dob;
  final String gender;
  final String address;

  User({
    this.id,
    required this.username,
    required this.password,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.dob,
    required this.gender,
    required this.address,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'password': password,
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'dob': dob,
      'gender': gender,
      'address': address,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      username: map['username'],
      password: map['password'],
      name: map['name'],
      email: map['email'],
      phoneNumber: map['phoneNumber'],
      dob: map['dob'],
      gender: map['gender'],
      address: map['address'],
    );
  }
}