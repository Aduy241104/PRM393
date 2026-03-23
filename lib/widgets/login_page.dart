import 'package:flutter/material.dart';
import 'package:project/widgets/register_page.dart';
import 'package:provider/provider.dart';
import 'package:project/authProvider.dart';

class LoginPage extends StatelessWidget {
  final _userC = TextEditingController();
  final _passC = TextEditingController();

  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "LOGIN",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: _userC,
              decoration: const InputDecoration(labelText: "Username"),
            ),
            TextField(
              controller: _passC,
              decoration: const InputDecoration(labelText: "Password"),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final success = await context.read<AuthProvider>().login(
                  _userC.text,
                  _passC.text,
                );
                if (!success && context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Sai tài khoản!")),
                  );
                }
              },
              child: const Text("Đăng nhập"),
            ),

            // Bên dưới ElevatedButton của LoginPage
            const SizedBox(height: 10),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RegisterPage()),
                );
              },
              child: const Text("Chưa có tài khoản? Đăng ký ngay"),
            ),
          ],
        ),
      ),
    );
  }
}
