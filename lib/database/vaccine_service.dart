import '../models/owner.dart';
import '../models/pet.dart';
import '../models/vaccine.dart';
import 'db.dart';

class VaccineService {
  VaccineService._();

  static final VaccineService instance = VaccineService._();

  Future<List<Owner>> getOwners() async {
    final db = await Db.instance.db;
    final maps = await db.query('owners', orderBy: 'id DESC');
    return maps.map((e) => Owner.fromMap(e)).toList();
  }

  Future<Owner?> getOwnerByUserId(int userId) async {
    final db = await Db.instance.db;
    final maps = await db.query(
      'owners',
      where: 'user_id = ?',
      whereArgs: [userId],
      limit: 1,
    );
    if (maps.isEmpty) return null;
    return Owner.fromMap(maps.first);
  }

  Future<List<Pet>> getPetsByOwner(int ownerId) async {
    final db = await Db.instance.db;
    final maps = await db.query(
      'pets',
      where: 'owner_id = ?',
      whereArgs: [ownerId],
      orderBy: 'id DESC',
    );
    return maps.map((e) => Pet.fromMap(e)).toList();
  }

  Future<List<Pet>> getAllPets() async {
    final db = await Db.instance.db;
    final maps = await db.query('pets', orderBy: 'id DESC');
    return maps.map((e) => Pet.fromMap(e)).toList();
  }

  Future<List<Vaccine>> getVaccinesByPet(int petId) async {
    final db = await Db.instance.db;
    final maps = await db.query(
      'vaccines',
      where: 'pet_id = ?',
      whereArgs: [petId],
      orderBy: 'id DESC',
    );
    return maps.map((e) => Vaccine.fromMap(e)).toList();
  }

  Future<List<Vaccine>> getAllVaccines() async {
    final db = await Db.instance.db;
    final maps = await db.query('vaccines', orderBy: 'id DESC');
    return maps.map((e) => Vaccine.fromMap(e)).toList();
  }

  Future<List<Vaccine>> getVaccinesByPetIds(List<int> petIds) async {
    if (petIds.isEmpty) return [];

    final db = await Db.instance.db;
    final placeholders = List.filled(petIds.length, '?').join(',');
    final maps = await db.query(
      'vaccines',
      where: 'pet_id IN ($placeholders)',
      whereArgs: petIds,
      orderBy: 'id DESC',
    );
    return maps.map((e) => Vaccine.fromMap(e)).toList();
  }

  Future<void> addVaccine({
    required int petId,
    required String vaccineName,
    required String date,
    required String nextDueDate,
  }) async {
    final db = await Db.instance.db;
    await db.insert('vaccines', {
      'pet_id': petId,
      'vaccine_name': vaccineName,
      'date': date,
      'next_due_date': nextDueDate,
    });
  }

  Future<void> updateVaccine({
    required int vaccineId,
    required int petId,
    required String vaccineName,
    required String date,
    required String nextDueDate,
  }) async {
    final db = await Db.instance.db;
    await db.update(
      'vaccines',
      {
        'pet_id': petId,
        'vaccine_name': vaccineName,
        'date': date,
        'next_due_date': nextDueDate,
      },
      where: 'id = ?',
      whereArgs: [vaccineId],
    );
  }

  Future<void> deleteVaccine(int vaccineId) async {
    final db = await Db.instance.db;
    await db.delete('vaccines', where: 'id = ?', whereArgs: [vaccineId]);
  }
}
