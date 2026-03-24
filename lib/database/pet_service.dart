import '../models/pet.dart';
import 'db.dart';

class PetService {

  Future<List<Pet>> getPetsByOwner(int ownerId) async {
    final dbClient = await Db.instance.db;

    final res = await dbClient.query(
      'pets',
      where: 'owner_id = ?',
      whereArgs: [ownerId],
      orderBy: 'id DESC',
    );

    return res.map((e) => Pet.fromMap(e)).toList();
  }

  Future<Pet?> getPetById(int id) async {
    final dbClient = await Db.instance.db;

    final res = await dbClient.query(
      'pets',
      where: 'id = ?',
      whereArgs: [id],
    );

    return res.isNotEmpty ? Pet.fromMap(res.first) : null;
  }

  Future<int> insertPet(Pet pet) async {
    final dbClient = await Db.instance.db;

    final map = pet.toMap();
    map.remove('id');

    return await dbClient.insert('pets', map);
  }

  Future<int> updatePet(
    int id,
    String name,
    String type,
    String breed,
    int age,
    String image,
  ) async {
    final dbClient = await Db.instance.db;

    return await dbClient.update(
      'pets',
      {
        'name': name,
        'type': type,
        'breed': breed,
        'age': age,
        'image': image,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deletePet(int id) async {
    final dbClient = await Db.instance.db;

    return await dbClient.delete(
      'pets',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}