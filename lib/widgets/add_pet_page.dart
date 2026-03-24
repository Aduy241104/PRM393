import 'package:flutter/material.dart';
import '../models/pet.dart';
import '../database/pet_service.dart';

class AddPetPage extends StatefulWidget {
  final int ownerId;

  const AddPetPage({super.key, required this.ownerId});

  @override
  State<AddPetPage> createState() => _AddPetPageState();
}

class _AddPetPageState extends State<AddPetPage> {
  final service = PetService();

  final nameCtrl = TextEditingController();
  final typeCtrl = TextEditingController();
  final breedCtrl = TextEditingController();
  final ageCtrl = TextEditingController();
  final imageCtrl = TextEditingController(); // 🔥 thêm

  void save() async {
    await service.insertPet(
      Pet(
        ownerId: widget.ownerId,
        name: nameCtrl.text,
        type: typeCtrl.text,
        breed: breedCtrl.text,
        age: int.tryParse(ageCtrl.text) ?? 0,
        image: imageCtrl.text, // 🔥 thêm
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Thêm thú cưng"),
        backgroundColor: Colors.orangeAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: "Tên")),
            TextField(controller: typeCtrl, decoration: const InputDecoration(labelText: "Loại")),
            TextField(controller: breedCtrl, decoration: const InputDecoration(labelText: "Giống")),
            TextField(
              controller: ageCtrl,
              decoration: const InputDecoration(labelText: "Tuổi"),
              keyboardType: TextInputType.number,
            ),

            // 🔥 THÊM IMAGE URL
            TextField(
              controller: imageCtrl,
              decoration: const InputDecoration(labelText: "Image URL"),
            ),

            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orangeAccent,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text("Hủy"),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: save,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orangeAccent,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text("Thêm thú cưng"),
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