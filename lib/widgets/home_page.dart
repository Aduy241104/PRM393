import 'package:flutter/material.dart';
import 'package:project/widgets/pet_list_page.dart';
import 'package:provider/provider.dart';
import 'package:project/authProvider.dart'; // Kiểm tra lại path project của bạn
import 'user_profile_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Lắng nghe trạng thái từ AuthProvider
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Pet App Home"),
        backgroundColor: Colors.orangeAccent,
        actions: [
          // 1. Nút Xem Profile dời lên đây
          IconButton(
            icon: const Icon(Icons.account_circle),
            tooltip: 'Hồ sơ cá nhân',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const UserProfilePage(),
                ),
              );
            },
          ),
          // 2. Nút Logout nằm cạnh bên
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Đăng xuất',
            onPressed: () => auth.logout(),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.pets, size: 80, color: Colors.orange),
            const SizedBox(height: 20),
            Text(
              "Chào mừng, ${auth.user?.username ?? 'User'}!",
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text("Chúc bạn một ngày tuyệt vời bên thú cưng!"),

            const SizedBox(height: 20),

            ElevatedButton.icon(
              icon: const Icon(Icons.pets),
              label: const Text("Xem danh sách thú cưng"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orangeAccent,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PetListPage(ownerId: 1),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
