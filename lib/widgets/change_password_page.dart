import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:project/authProvider.dart';
import 'package:project/database/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _oldPassC = TextEditingController();
  final _newPassC = TextEditingController();
  final _confirmPassC = TextEditingController();
  final _authService = AuthService();

  void _handleChangePassword() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId'); 
    if (_oldPassC.text.isEmpty ||
        _newPassC.text.isEmpty ||
        _confirmPassC.text.isEmpty) {
      _showMsg("Vui lòng nhập đầy đủ thông tin");
      return;
    }

    if (_newPassC.text != _confirmPassC.text) {
      _showMsg("Mật khẩu mới không trùng khớp");
      return;
    }

    if (_newPassC.text.length < 6) {
      _showMsg("Mật khẩu mới phải có ít nhất 6 ký tự");
      return;
    }

    int result = await _authService.changePassword(
      userId ?? 0,
      _oldPassC.text,
      _newPassC.text,
    );

    if (result == -1) {
      _showMsg("Mật khẩu cũ không chính xác");
    } else if (result > 0) {
      _showMsg("Đổi mật khẩu thành công!");
      if (!mounted) return;
      Navigator.pop(context);
    }
  }

  void _showMsg(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Đổi mật khẩu")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: _oldPassC,
              decoration: const InputDecoration(
                labelText: "Mật khẩu hiện tại",
                prefixIcon: Icon(Icons.lock_outline),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _newPassC,
              decoration: const InputDecoration(
                labelText: "Mật khẩu mới",
                prefixIcon: Icon(Icons.lock_reset),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _confirmPassC,
              decoration: const InputDecoration(
                labelText: "Xác nhận mật khẩu mới",
                prefixIcon: Icon(Icons.check_circle_outline),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _handleChangePassword,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orangeAccent,
                ),
                child: const Text(
                  "XÁC NHẬN ĐỔI",
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
