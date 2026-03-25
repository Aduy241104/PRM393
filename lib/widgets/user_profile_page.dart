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
  final AuthService authService = AuthService();

  // Hàm điều hướng và tự động refresh khi quay lại
  void _navigateTo(Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    ).then((_) => setState(() {})); // Gọi setState để FutureBuilder chạy lại
  }

  @override
  Widget build(BuildContext context) {
    final userId = context.read<AuthProvider>().user?.id;

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
        future: authService.getUserById(userId ?? 0),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData)
            return const Center(child: Text("Lỗi tải dữ liệu"));

          final user = snapshot.data!;
          return SingleChildScrollView(
            child: Column(
              children: [
                // Header Profile
                Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.orangeAccent,
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(30),
                    ),
                  ),
                  padding: const EdgeInsets.only(bottom: 30),
                  child: Column(
                    children: [
                      const CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.person,
                          size: 65,
                          color: Colors.orangeAccent,
                        ),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        user.username.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),

                // Danh sách thông tin
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

                      // Nút Sửa hồ sơ
                      _buildActionItem(
                        Icons.edit,
                        "Chỉnh sửa hồ sơ",
                        () => _navigateTo(EditProfilePage(user: user)),
                      ),

                      // Nút Đổi mật khẩu
                      _buildActionItem(
                        Icons.vpn_key,
                        "Thay đổi mật khẩu",
                        () => _navigateTo(const ChangePasswordPage()),
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

  // Widget hiển thị thông tin (Dạng tĩnh)
  Widget _buildInfoItem(IconData icon, String label, String value) {
    return ListTile(
      leading: Icon(icon, color: Colors.orangeAccent),
      title: Text(
        label,
        style: const TextStyle(fontSize: 12, color: Colors.grey),
      ),
      subtitle: Text(
        value,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }

  // Widget nút chức năng (Dạng bấm được)
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
