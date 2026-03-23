class MedicalRecord {
  final int? id;
  final int petId;
  final String diagnosis;
  final String treatment;
  final String date;

  MedicalRecord({
    this.id,
    required this.petId,
    required this.diagnosis,
    required this.treatment,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'pet_id': petId,
      'diagnosis': diagnosis,
      'treatment': treatment,
      'date': date,
    };
  }

  factory MedicalRecord.fromMap(Map<String, dynamic> map) {
    return MedicalRecord(
      id: map['id'],
      petId: map['pet_id'],
      diagnosis: map['diagnosis'],
      treatment: map['treatment'],
      date: map['date'],
    );
  }
}
