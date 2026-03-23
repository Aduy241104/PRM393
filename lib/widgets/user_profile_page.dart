import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:project/authProvider.dart';
import 'package:project/database/auth_service.dart';
import 'package:project/models/user.dart';
import 'edit_profile_page.dart'; // Import trang edit của bạn

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  final AuthService authService = AuthService();

  // Hàm này giúp FutureBuilder thực thi lại
  void _refreshData() {
    setState(() {});
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
        actions: [
          // NÚT QUA TRANG EDIT
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // Lấy dữ liệu hiện tại để truyền sang trang Edit
              authService.getUserById(userId ?? 0).then((user) {
                if (user != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditProfilePage(user: user),
                    ),
                  ).then((_) {
                    // KHI QUAY LẠI TỪ TRANG EDIT, LOAD LẠI DATA
                    _refreshData();
                  });
                }
              });
            },
          ),
        ],
      ),
      body: FutureBuilder<User?>(
        // Future này sẽ chạy lại mỗi khi _refreshData (setState) được gọi
        future: authService.getUserById(userId ?? 0),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text("Không tìm thấy dữ liệu"));
          }

          final user = snapshot.data!;
          return SingleChildScrollView(
            child: Column(
              children: [
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
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      _buildInfoItem(Icons.email_rounded, "Email", user.email),
                      _buildInfoItem(
                        Icons.phone_rounded,
                        "Số điện thoại",
                        user.phone,
                      ),
                      _buildInfoItem(
                        Icons.location_on_rounded,
                        "Địa chỉ",
                        user.address,
                      ),
                      _buildInfoItem(
                        Icons.calendar_today_rounded,
                        "Ngày tham gia",
                        user.createdAt.split(' ')[0],
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

  Widget _buildInfoItem(IconData icon, String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.orange[50],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: Colors.orangeAccent),
        ),
        title: Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            color: Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
