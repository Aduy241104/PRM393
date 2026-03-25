import '../models/service.dart';
import 'db.dart';

class ServiceBookingService {
  ServiceBookingService._();
  static final ServiceBookingService instance = ServiceBookingService._();

  Future<List<Service>> getServicesByPet(int petId) async {
    final db = await Db.instance.db;
    final maps = await db.query(
      'services',
      where: 'pet_id = ?',
      whereArgs: [petId],
      orderBy: 'date DESC',
    );
    return maps.map((e) => Service.fromMap(e)).toList();
  }

  Future<List<Service>> getAllServices() async {
    final db = await Db.instance.db;
    final maps = await db.query('services', orderBy: 'date DESC');
    return maps.map((e) => Service.fromMap(e)).toList();
  }

  Future<void> addService(Service service) async {
    final db = await Db.instance.db;
    await db.insert('services', service.toMap());
  }

  Future<void> updateService(Service service) async {
    final db = await Db.instance.db;
    await db.update(
      'services',
      service.toMap(),
      where: 'id = ?',
      whereArgs: [service.id],
    );
  }

  Future<void> deleteService(int id) async {
    final db = await Db.instance.db;
    await db.delete('services', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Service>> getServicesByPetIds(List<int> petIds) async {
    if (petIds.isEmpty) return [];
    final db = await Db.instance.db;
    final placeholders = List.filled(petIds.length, '?').join(',');
    final maps = await db.query(
      'services',
      where: 'pet_id IN ($placeholders)',
      whereArgs: petIds,
      orderBy: 'date DESC',
    );
    return maps.map((e) => Service.fromMap(e)).toList();
  }
}
