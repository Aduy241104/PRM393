import 'package:flutter/material.dart';
import '../models/pet.dart';
import '../database/pet_service.dart';

class EditPetPage extends StatefulWidget {
  final Pet pet;

  const EditPetPage({super.key, required this.pet});

  @override
  State<EditPetPage> createState() => _EditPetPageState();
}

class _EditPetPageState extends State<EditPetPage> {
  final service = PetService();

  late TextEditingController nameCtrl;
  late TextEditingController typeCtrl;
  late TextEditingController breedCtrl;
  late TextEditingController ageCtrl;
  late TextEditingController imageCtrl; // 🔥 thêm

  @override
  void initState() {
    super.initState();

    nameCtrl = TextEditingController(text: widget.pet.name);
    typeCtrl = TextEditingController(text: widget.pet.type);
    breedCtrl = TextEditingController(text: widget.pet.breed);
    ageCtrl = TextEditingController(text: widget.pet.age.toString());
    imageCtrl = TextEditingController(text: widget.pet.image); // 🔥 thêm
  }

  void updatePet() async {
    await service.updatePet(
      widget.pet.id!,
      nameCtrl.text,
      typeCtrl.text,
      breedCtrl.text,
      int.tryParse(ageCtrl.text) ?? 0,
      imageCtrl.text, // 🔥 thêm
    );

    Navigator.pop(context);
  }

  void deletePet() async {
    await service.deletePet(widget.pet.id!);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chỉnh sửa thông tin thú cưng"),
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
                    onPressed: deletePet,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orangeAccent,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text("Delete"),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: updatePet,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orangeAccent,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text("Update"),
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