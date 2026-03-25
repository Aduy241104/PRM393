import '../models/user.dart'; // Giả sử file model là User.dart
import 'db.dart';

class AuthService {
  // Logic đăng nhập
  Future<User?> login(String username, String password) async {
    final dbClient = await Db.instance.db;
    final res = await dbClient.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );

    if (res.isNotEmpty) {
      return User.fromMap(res.first);
    }
    return null;
  }

  // Logic đăng ký (nếu sau này bạn cần)
  // Thêm vào class AuthService
  Future<int> register(User user) async {
    final dbClient = await Db.instance.db;

    // Kiểm tra xem username đã tồn tại chưa
    final List<Map<String, dynamic>> existingUser = await dbClient.query(
      'users',
      where: 'username = ?',
      whereArgs: [user.username],
    );

    if (existingUser.isNotEmpty) {
      return -1; // Mã lỗi tự quy định cho việc trùng username
    }

    // Chèn user mới vào table 'users'
    return await dbClient.insert('users', user.toMap());
  }


  Future<User?> getUserById(int id) async {
    final dbClient = await Db.instance.db;
    final res = await dbClient.query('users', where: 'id = ?', whereArgs: [id]);
    if (res.isNotEmpty) return User.fromMap(res.first);
    return null;
  }

  Future<int> updateUser(
    int id,
    String username,
    String phone,
    String address,
  ) async {
    final dbClient = await Db.instance.db;
    return await dbClient.update(
      'users',
      {'username': username, 'phone': phone, 'address': address},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Thêm vào class AuthService
  Future<int> changePassword(
    int userId,
    String oldPassword,
    String newPassword,
  ) async {
    final dbClient = await Db.instance.db;

    // 1. Kiểm tra mật khẩu cũ có khớp với database không
    final List<Map<String, dynamic>> user = await dbClient.query(
      'users',
      where: 'id = ? AND password = ?',
      whereArgs: [userId, oldPassword],
    );

    if (user.isEmpty) {
      return -1; // Sai mật khẩu cũ
    }

    // 2. Cập nhật mật khẩu mới
    return await dbClient.update(
      'users',
      {'password': newPassword},
      where: 'id = ?',
      whereArgs: [userId],
    );
  }
}
