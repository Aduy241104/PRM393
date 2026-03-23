class Vaccine {
  final int? id;
  final int petId;
  final String vaccineName;
  final String date;
  final String nextDueDate;

  Vaccine({
    this.id,
    required this.petId,
    required this.vaccineName,
    required this.date,
    required this.nextDueDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'pet_id': petId,
      'vaccine_name': vaccineName,
      'date': date,
      'next_due_date': nextDueDate,
    };
  }

  factory Vaccine.fromMap(Map<String, dynamic> map) {
    return Vaccine(
      id: map['id'],
      petId: map['pet_id'],
      vaccineName: map['vaccine_name'],
      date: map['date'],
      nextDueDate: map['next_due_date'],
    );
  }
}
