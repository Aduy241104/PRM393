import 'package:flutter/material.dart';
import '../models/owner.dart';
import '../widgets/edit_owner_page.dart';

class OwnerItem extends StatelessWidget {
  final Owner owner;
  final VoidCallback onDelete;
  final Function(Owner updatedOwner) onUpdate;
  final VoidCallback? onTap;

  const OwnerItem({
    super.key,
    required this.owner,
    required this.onDelete,
    required this.onUpdate,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
      elevation: 3,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon người và thông tin
              const Icon(Icons.person, color: Colors.orange, size: 36),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      owner.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.phone, size: 16, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(owner.phone),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(Icons.email, size: 16, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(owner.email),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(Icons.location_on, size: 16, color: Colors.grey),
                        const SizedBox(width: 4),
                        Expanded(child: Text(owner.address)),
                      ],
                    ),
                  ],
                ),
              ),
              // Column chứa icon edit và delete
              Column(
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    tooltip: "Chỉnh sửa",
                    onPressed: () async {
                      final updatedOwner = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => EditOwnerPage(owner: owner),
                        ),
                      );
                      if (updatedOwner != null) {
                        onUpdate(updatedOwner);
                      }
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    tooltip: "Xóa",
                    onPressed: onDelete,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}