import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:project/authProvider.dart';
import 'package:project/database/auth_service.dart';
import 'package:project/models/user.dart';
import 'package:project/widgets/change_password_page.dart';
import 'edit_profile_page.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  final AuthService _authService = AuthService();
  late Future<User?> _userFuture; // Biến lưu giữ Future của User

  @override
  void initState() {
    super.initState();
    // Khởi tạo Future ngay khi load trang
    _initUserFetch();
  }


  // Hàm khởi tạo/làm mới việc lấy dữ liệu từ DB
  void _initUserFetch() {
    final userId = context.read<AuthProvider>().user?.id;
    _userFuture = _authService.getUserById(userId ?? 0);
  }

  // Hàm làm mới giao diện (gọi sau khi Edit xong)
  void _refreshData() {
    setState(() {
      _initUserFetch(); // Gán lại Future mới để FutureBuilder chạy lại
    });
  }

  void _goToEditPage(User user) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditProfilePage(user: user)),
    ).then((_) => _refreshData());
  }

  void _goToChangePasswordPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ChangePasswordPage()),
    ).then((_) => _refreshData());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Hồ sơ cá nhân"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.orangeAccent,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<User?>(
        future: _userFuture, // Sử dụng biến Future đã tách riêng
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text("Lỗi tải dữ liệu người dùng"));
          }

          final user = snapshot.data!;

          return SingleChildScrollView(
            child: Column(
              children: [
                _buildHeader(user.username),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      _buildInfoItem(Icons.email, "Email", user.email),
                      _buildInfoItem(Icons.phone, "Số điện thoại", user.phone),
                      _buildInfoItem(
                        Icons.location_on,
                        "Địa chỉ",
                        user.address,
                      ),

                      const SizedBox(height: 10),
                      const Divider(),
                      const SizedBox(height: 10),

                      _buildActionItem(
                        Icons.edit,
                        "Chỉnh sửa hồ sơ",
                        () => _goToEditPage(user),
                      ),
                      _buildActionItem(
                        Icons.vpn_key,
                        "Thay đổi mật khẩu",
                        _goToChangePasswordPage,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(String username) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.orangeAccent,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
      ),
      padding: const EdgeInsets.only(bottom: 30),
      child: Column(
        children: [
          const CircleAvatar(
            radius: 50,
            backgroundColor: Colors.white,
            child: Icon(Icons.person, size: 65, color: Colors.orangeAccent),
          ),
          const SizedBox(height: 15),
          Text(
            username.toUpperCase(),
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String label, String value) {
    return ListTile(
      leading: Icon(icon, color: Colors.orangeAccent),
      title: Text(
        label,
        style: const TextStyle(fontSize: 12, color: Colors.grey),
      ),
      subtitle: Text(
        value,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildActionItem(IconData icon, String title, VoidCallback onTap) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        leading: Icon(icon, color: Colors.orangeAccent),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
