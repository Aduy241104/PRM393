class Service {
  final int? id;
  final int petId;
  final String serviceName;
  final double price;
  final String date;
  final String note;

  Service({
    this.id,
    required this.petId,
    required this.serviceName,
    required this.price,
    required this.date,
    required this.note,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'pet_id': petId,
      'service_name': serviceName,
      'price': price,
      'date': date,
      'note': note,
    };
  }

  factory Service.fromMap(Map<String, dynamic> map) {
    return Service(
      id: map['id'],
      petId: map['pet_id'],
      serviceName: map['service_name'],
      price: map['price'] * 1.0, // đảm bảo double
      date: map['date'],
      note: map['note'] ?? '',
    );
  }
}
