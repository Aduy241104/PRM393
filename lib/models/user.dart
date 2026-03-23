class User {
  final int? id;
  final String username;
  final String password;
  final String email;
  final String phone;
  final String address;
  final String createdAt;

  User({
    this.id,
    required this.username,
    required this.password,
    required this.email,
    required this.phone,
    required this.address,
    String? createdAt,
  }) : createdAt = createdAt ?? DateTime.now().toString();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'password': password,
      'email': email,
      'phone': phone,
      'address': address,
      'created_at': createdAt,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      username: map['username'],
      password: map['password'],
      email: map['email'],
      phone: map['phone'] ?? '',
      address: map['address'] ?? '',
      createdAt: map['created_at'],
    );
  }
}
