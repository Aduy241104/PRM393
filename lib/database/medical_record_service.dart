import '../models/medicalRecord.dart';
import 'db.dart';

class MedicalRecordService {
  Future<List<MedicalRecord>> getRecordsByPet(int petId) async {
    final dbClient = await Db.instance.db;

    final res = await dbClient.query(
      'medical_records',
      where: 'pet_id = ?',
      whereArgs: [petId],
      orderBy: 'id DESC',
    );

    return res.map((e) => MedicalRecord.fromMap(e)).toList();
  }

  Future<MedicalRecord?> getRecordById(int id) async {
    final dbClient = await Db.instance.db;

    final res = await dbClient.query(
      'medical_records',
      where: 'id = ?',
      whereArgs: [id],
    );

    return res.isNotEmpty ? MedicalRecord.fromMap(res.first) : null;
  }

  Future<int> insertRecord(MedicalRecord record) async {
    final dbClient = await Db.instance.db;

    final map = record.toMap();
    map.remove('id');

    return await dbClient.insert('medical_records', map);
  }

  Future<int> updateRecord(MedicalRecord record) async {
    final dbClient = await Db.instance.db;

    return await dbClient.update(
      'medical_records',
      {
        'diagnosis': record.diagnosis,
        'treatment': record.treatment,
        'date': record.date,
      },
      where: 'id = ?',
      whereArgs: [record.id],
    );
  }

  Future<int> deleteRecord(int id) async {
    final dbClient = await Db.instance.db;

    return await dbClient.delete(
      'medical_records',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
