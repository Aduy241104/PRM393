import 'package:flutter/material.dart';
import 'package:project/widgets/pet_list_page.dart';
import 'package:provider/provider.dart';
import 'package:project/authProvider.dart';
import '../widgets/add_owner_page.dart';
import 'user_profile_page.dart';
import '../models/owner.dart';
import '../database/owner_service.dart';
import '../widgets/owner_item.dart';
import '../widgets/detail_owner_page.dart'; // trang Detail mới

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final OwnerService service = OwnerService();
  List<Owner> owners = [];

  @override
  void initState() {
    super.initState();
    loadOwners();
  }

  Future<void> loadOwners() async {
    final auth = context.read<AuthProvider>();
    final userId = auth.user?.id;
    if (userId != null) {
      final data = await service.getByUser(userId);
      setState(() => owners = data);
    }
  }

  void goToAddOwner() {
    final auth = context.read<AuthProvider>();
    final userId = auth.user?.id;
    if (userId != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => AddOwnerPage(userId: userId),
        ),
      ).then((_) => loadOwners());
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("User chưa có ID!")),
      );
    }
  }

  void deleteOwner(int id) async {
    await service.delete(id);
    loadOwners();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Xóa chủ sở hữu thành công")),
    );
  }

  void confirmDeleteOwner(int id) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text("Xác nhận xóa"),
      content: const Text("Bạn có chắc muốn xóa chủ sở hữu này không?"),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Hủy"),
        ),
        ElevatedButton(
          // Không set màu nữa, dùng mặc định
          onPressed: () {
            Navigator.pop(context);
            deleteOwner(id);
          },
          child: const Text("Xóa"),
        ),
      ],
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Pet App Home"),
        backgroundColor: Colors.orangeAccent,
        actions: [
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
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Đăng xuất',
            onPressed: () => auth.logout(),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: goToAddOwner,
        backgroundColor: Colors.orange,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          "Thêm Chủ Sở Hữu",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: owners.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.pets, size: 80, color: Colors.orange),
                  const SizedBox(height: 20),
                  Text(
                    "Chào mừng, ${auth.user?.username ?? 'User'}!",
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  const Text("Chúc bạn một ngày tuyệt vời bên thú cưng!"),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: owners.length,
              itemBuilder: (context, index) {
                final owner = owners[index];
                return OwnerItem(
                  owner: owner,
                  onDelete: () => confirmDeleteOwner(owner.id!),
                  onUpdate: (updatedOwner) {
                    setState(() {
                      final idx = owners.indexWhere((o) => o.id == updatedOwner.id);
                      if (idx != -1) owners[idx] = updatedOwner;
                    });
                  },
                 onTap: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => OwnerDetailPage(owner: owner),
                      ),
                    );
                    if (result != null && result is Owner) {
                      // nếu Detail page trả về owner đã update
                      setState(() {
                        final idx = owners.indexWhere((o) => o.id == result.id);
                        if (idx != -1) owners[idx] = result;
                      });
                    }
                  },
                );
              },
            ),
    );
  }
}