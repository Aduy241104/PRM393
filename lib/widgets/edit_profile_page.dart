import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:project/authProvider.dart';
import 'package:project/database/auth_service.dart';
import 'package:project/models/user.dart';

class EditProfilePage extends StatefulWidget {
  final User user;
  const EditProfilePage({super.key, required this.user});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController _userC;
  late TextEditingController _phoneC;
  late TextEditingController _addressC;

  @override
  void initState() {
    super.initState();
    _userC = TextEditingController(text: widget.user.username);
    _phoneC = TextEditingController(text: widget.user.phone);
    _addressC = TextEditingController(text: widget.user.address);
  }

  void _saveProfile() async {
    if (_userC.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Tên không được để trống")));
      return;
    }

    final authService = AuthService();

    // 1. Cập nhật SQLite
    int result = await authService.updateUser(
      widget.user.id!,
      _userC.text,
      _phoneC.text,
      _addressC.text,
    );

    if (result > 0) {
      // 2. Cập nhật SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('username', _userC.text);
      await prefs.setString('phone', _phoneC.text);
      await prefs.setString('address', _addressC.text);

      // 3. Thông báo cho AuthProvider load lại data
      if (!mounted) return;
      await context.read<AuthProvider>().initAuth();

      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Cập nhật thông tin thành công!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Chỉnh sửa hồ sơ")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Email chỉ xem
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.lock_outline, color: Colors.grey),
              title: const Text(
                "Email (Cố định)",
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              subtitle: Text(
                widget.user.email,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Divider(),
            const SizedBox(height: 10),
            TextField(
              controller: _userC,
              decoration: const InputDecoration(
                labelText: "Tên người dùng",
                prefixIcon: Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _phoneC,
              decoration: const InputDecoration(
                labelText: "Số điện thoại",
                prefixIcon: Icon(Icons.phone),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _addressC,
              decoration: const InputDecoration(
                labelText: "Địa chỉ",
                prefixIcon: Icon(Icons.map),
              ),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _saveProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orangeAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  "LƯU THÔNG TIN",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
