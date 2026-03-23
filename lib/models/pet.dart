class Pet {
  final int? id;
  final int ownerId;
  final String name;
  final String type;
  final String breed;
  final int age;
  final String image;

  Pet({
    this.id,
    required this.ownerId,
    required this.name,
    required this.type,
    required this.breed,
    required this.age,
    required this.image,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'owner_id': ownerId,
      'name': name,
      'type': type,
      'breed': breed,
      'age': age,
      'image': image,
    };
  }

  factory Pet.fromMap(Map<String, dynamic> map) {
    return Pet(
      id: map['id'],
      ownerId: map['owner_id'],
      name: map['name'],
      type: map['type'],
      breed: map['breed'],
      age: map['age'],
      image: map['image'] ?? '',
    );
  }
}
