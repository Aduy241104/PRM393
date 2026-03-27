import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

class Db {
  Db._();
  static final Db instance = Db._();

  static Database? _db;

  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await _open();
    return _db!;
  }

  Future<Database> _open() async {
    final dir = await getDatabasesPath();
    final path = p.join(dir, 'pet_app.db');

    debugPrint("📂 DB Path: $path");

    return openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
      onOpen: (db) async {
        await seedIfEmpty(db);
      },
    );
  }

  // ================= CREATE TABLE =================
  Future<void> _onCreate(Database db, int version) async {
    debugPrint("🟣 Creating tables...");

    // USERS
    await db.execute('''
  CREATE TABLE users (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    username TEXT NOT NULL,
    password TEXT NOT NULL,
    email TEXT NOT NULL,
    phone TEXT,
    address TEXT,
    created_at TEXT
  );
''');

    // OWNERS
    await db.execute('''
      CREATE TABLE owners (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        name TEXT NOT NULL,
        phone TEXT,
        email TEXT,
        address TEXT
      );
    ''');

    // PETS
    await db.execute('''
      CREATE TABLE pets (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        owner_id INTEGER NOT NULL,
        name TEXT NOT NULL,
        type TEXT,
        breed TEXT,
        age INTEGER,
        image TEXT
      );
    ''');

    // MEDICAL RECORDS
    await db.execute('''
      CREATE TABLE medical_records (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        pet_id INTEGER NOT NULL,
        diagnosis TEXT,
        treatment TEXT,
        date TEXT
      );
    ''');

    // VACCINES
    await db.execute('''
      CREATE TABLE vaccines (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        pet_id INTEGER NOT NULL,
        vaccine_name TEXT,
        date TEXT,
        next_due_date TEXT
      );
    ''');

    // SERVICES (đã gộp)
    await db.execute('''
      CREATE TABLE services (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        pet_id INTEGER NOT NULL,
        service_name TEXT,
        price REAL,
        date TEXT,
        note TEXT
      );
    ''');

    debugPrint("🟢 Tables created");
  }

  // ================= SEED =================
  Future<void> seedIfEmpty(Database db) async {
    debugPrint("🌱 Checking seed...");

    final count =
        Sqflite.firstIntValue(
          await db.rawQuery('SELECT COUNT(*) FROM users'),
        ) ??
        0;

    if (count > 0) {
      debugPrint("🟢 Seed skipped");
      return;
    }

    debugPrint("🟡 Seeding data...");

    // ===== USER =====
   await db.insert('users', {
      'username': 'admin',
      'password': '123456',
      'email': 'admin@gmail.com',
      'phone': '0123456789',
      'address': 'Can Tho',
      'created_at': DateTime.now().toString(),
    });

    // ===== OWNER =====
    await db.insert('owners', {
      'user_id': 1,
      'name': 'Nguyen Van A',
      'phone': '0123456789',
      'email': 'a@gmail.com',
      'address': 'Can Tho',
    });

    // ===== PET =====
    await db.insert('pets', {
      'owner_id': 3,
      'name': 'Milo',
      'type': 'Dog',
      'breed': 'Poodle',
      'age': 2,
      'image': '',
    });

    // ===== MEDICAL =====
    await db.insert('medical_records', {
      'pet_id': 1,
      'diagnosis': 'Cảm nhẹ',
      'treatment': 'Uống thuốc',
      'date': DateTime.now().toString(),
    });

    // ===== VACCINE =====
    await db.insert('vaccines', {
      'pet_id': 1,
      'vaccine_name': 'Dại',
      'date': DateTime.now().toString(),
      'next_due_date': DateTime.now().add(const Duration(days: 365)).toString(),
    });

    // ===== SERVICE =====
    await db.insert('services', {
      'pet_id': 1,
      'service_name': 'Tắm',
      'price': 50000,
      'date': DateTime.now().toString(),
      'note': 'Tắm sạch',
    });

    debugPrint("🟢 Seed done");
  }
}
