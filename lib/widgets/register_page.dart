import 'package:flutter/material.dart';
import 'package:project/database/auth_service.dart';
import 'package:project/models/user.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _userC = TextEditingController();
  final _passC = TextEditingController();
  final _emailC = TextEditingController();
  final _phoneC = TextEditingController();
  final _addressC = TextEditingController();
  final _authService = AuthService();

  void _handleRegister() async {
    if (_userC.text.isEmpty || _passC.text.isEmpty || _emailC.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Vui lòng nhập các trường bắt buộc (*)")),
      );
      return;
    }

    User newUser = User(
      username: _userC.text,
      password: _passC.text,
      email: _emailC.text,
      phone: _phoneC.text,
      address: _addressC.text,
    );

    int result = await _authService.register(newUser);

    if (result == -1) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Tên đăng nhập đã tồn tại!")),
      );
    } else if (result > 0) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Đăng ký thành công! Hãy đăng nhập.")),
      );
      Navigator.pop(context); // Quay lại trang Login
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Đăng ký tài khoản")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Icon(Icons.app_registration, size: 80, color: Colors.orange),
            TextField(
              controller: _userC,
              decoration: const InputDecoration(labelText: "Username *"),
            ),
            TextField(
              controller: _passC,
              decoration: const InputDecoration(labelText: "Password *"),
              obscureText: true,
            ),
            TextField(
              controller: _emailC,
              decoration: const InputDecoration(labelText: "Email *"),
            ),
            TextField(
              controller: _phoneC,
              decoration: const InputDecoration(labelText: "Số điện thoại"),
            ),
            TextField(
              controller: _addressC,
              decoration: const InputDecoration(labelText: "Địa chỉ"),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _handleRegister,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orangeAccent,
                ),
                child: const Text(
                  "ĐĂNG KÝ",
                  style: TextStyle(
                    color: Colors.white,
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
