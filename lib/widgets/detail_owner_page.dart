import 'package:flutter/material.dart';
import '../models/owner.dart';
import 'edit_owner_page.dart';
import 'pet_list_page.dart';

class OwnerDetailPage extends StatelessWidget {
  final Owner owner;
  final Function(Owner updatedOwner)? onUpdate; // callback nếu update

  const OwnerDetailPage({super.key, required this.owner, this.onUpdate});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Hồ sơ Chủ Sở Hữu"),
        centerTitle: true,
        backgroundColor: Colors.orangeAccent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.edit,
              color: Colors.white, // đổi màu icon thành trắng
            ),
            tooltip: "Chỉnh sửa",
            onPressed: () async {
              final updatedOwner = await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => EditOwnerPage(owner: owner)),
              );
              if (updatedOwner != null && onUpdate != null) {
                onUpdate!(updatedOwner);
                Navigator.pop(context, updatedOwner); // trả kết quả về HomePage
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header màu cam với avatar
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.orangeAccent,
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(30),
                ),
              ),
              padding: const EdgeInsets.only(bottom: 30, top: 20),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.person,
                      size: 65,
                      color: Colors.orangeAccent,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    owner.name.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
            ),
            // Thông tin chi tiết
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  _buildInfoItem(
                    Icons.phone_rounded,
                    "Số điện thoại",
                    owner.phone,
                  ),
                  _buildInfoItem(Icons.email_rounded, "Email", owner.email),
                  _buildInfoItem(
                    Icons.location_on_rounded,
                    "Địa chỉ",
                    owner.address,
                  ),

                  // 👇 THÊM Ở ĐÂY
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                           builder: (_) => PetListPage(ownerId: owner.id!),
                        ),
                      );
                    },
                    child: _buildInfoItem(
                      Icons.pets,
                      "Thú cưng",
                      "Xem danh sách thú cưng",
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.orange[50],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: Colors.orangeAccent),
        ),
        title: Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            color: Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
