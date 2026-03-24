import 'package:flutter/material.dart';
import '../models/pet.dart';
import '../database/pet_service.dart';
import 'edit_pet_page.dart';

class PetDetailPage extends StatelessWidget {
  final Pet pet;

  const PetDetailPage({super.key, required this.pet});

  @override
  Widget build(BuildContext context) {
    final service = PetService();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Hồ sơ thú cưng"),
        backgroundColor: Colors.orangeAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔥 AVATAR (ĐÃ FIX)
            Center(
              child: pet.image.isNotEmpty
                  ? CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(pet.image),
                    )
                  : CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.orange.shade100,
                      child: const Icon(
                        Icons.pets,
                        size: 50,
                        color: Colors.orange,
                      ),
                    ),
            ),

            const SizedBox(height: 20),

            Text("Tên: ${pet.name}", style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 10),

            Text("Loại: ${pet.type}", style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 10),

            Text("Giống: ${pet.breed}", style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 10),

            Text("Tuổi: ${pet.age}", style: const TextStyle(fontSize: 18)),

            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 20),

            Row(
              children: [
                // DELETE
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      final confirm = await showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text("Xác nhận"),
                          content: const Text("Bạn có chắc muốn xóa?"),
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
                        await service.deletePet(pet.id!);
                        Navigator.pop(context, true);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orangeAccent,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text("Delete"),
                  ),
                ),

                const SizedBox(width: 10),

                // EDIT
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => EditPetPage(pet: pet),
                        ),
                      );
                      Navigator.pop(context, true);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orangeAccent,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text("Edit"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
