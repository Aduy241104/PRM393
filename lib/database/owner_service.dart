import '../models/owner.dart';
import '../database/db.dart';

class OwnerService {
  final dbProvider = Db.instance;

  // ➕ CREATE
  Future<int> insert(Owner owner) async {
    final db = await dbProvider.db;
    return await db.insert('owners', owner.toMap());
  }

  // 📥 READ ALL theo user
  Future<List<Owner>> getByUser(int userId) async {
    final db = await dbProvider.db;

    final maps = await db.query(
      'owners',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'id DESC',
    );

    return maps.map((e) => Owner.fromMap(e)).toList();
  }

  // 🔍 READ 1
  Future<Owner?> getById(int id) async {
    final db = await dbProvider.db;

    final maps = await db.query(
      'owners',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Owner.fromMap(maps.first);
    }
    return null;
  }

  // ✏️ UPDATE
  Future<int> update(Owner owner) async {
    final db = await dbProvider.db;

    return await db.update(
      'owners',
      owner.toMap(),
      where: 'id = ?',
      whereArgs: [owner.id],
    );
  }

  // ❌ DELETE
  Future<int> delete(int id) async {
    final db = await dbProvider.db;

    return await db.delete(
      'owners',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}