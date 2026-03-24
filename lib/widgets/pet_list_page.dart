import 'package:flutter/material.dart';
import '../models/pet.dart';
import '../database/pet_service.dart';
import 'add_pet_page.dart';
import 'edit_pet_page.dart';
import 'pet_detail_page.dart'; // ✅ thêm

class PetListPage extends StatefulWidget {
  final int ownerId;

  const PetListPage({super.key, required this.ownerId});

  @override
  State<PetListPage> createState() => _PetListPageState();
}

class _PetListPageState extends State<PetListPage> {
  final service = PetService();
  List<Pet> pets = [];

  @override
  void initState() {
    super.initState();
    loadPets();
  }

  Future<void> loadPets() async {
    pets = await service.getPetsByOwner(widget.ownerId);
    setState(() {});
  }

  void deletePet(int id) async {
    final confirm = await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Xác nhận"),
        content: const Text("Bạn có chắc muốn xóa thú cưng này không?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Hủy"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Xóa"),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await service.deletePet(id);
      loadPets();

      // 🔥 thông báo nhỏ
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Đã xóa thú cưng")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pet List"),
        backgroundColor: Colors.orangeAccent,
      ),
      body: pets.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.pets, size: 80, color: Colors.grey.shade400),
                  const SizedBox(height: 15),
                  const Text(
                    "Chưa có thú cưng nào",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    "Hãy thêm thú cưng mới 🐶🐱",
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: pets.length,
              itemBuilder: (context, index) {
                final pet = pets[index];

                return Card(
                  child: ListTile(
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PetDetailPage(pet: pet),
                        ),
                      );

                      if (result == true) {
                        loadPets();
                      }
                    },
                    leading: pet.image.isNotEmpty
                        ? CircleAvatar(
                            radius: 25,
                            backgroundImage: NetworkImage(pet.image),
                          )
                        : CircleAvatar(
                            radius: 25,
                            backgroundColor: Colors.orange.shade100,
                            child: const Icon(
                              Icons.pets,
                              color: Colors.orange,
                              size: 28,
                            ),
                          ),
                    title: Text(pet.name),
                    subtitle: Text("${pet.type} - ${pet.breed}"),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => EditPetPage(pet: pet),
                              ),
                            );
                            loadPets();
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => deletePet(pet.id!),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

      // ADD
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        child: const Icon(Icons.add),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AddPetPage(ownerId: widget.ownerId),
            ),
          );
          loadPets();
        },
      ),
    );
  }
}
