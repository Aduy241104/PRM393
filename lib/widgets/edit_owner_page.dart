import 'package:flutter/material.dart';
import '../models/owner.dart';
import '../database/owner_service.dart';

class EditOwnerPage extends StatefulWidget {
  final Owner owner;

  const EditOwnerPage({super.key, required this.owner});

  @override
  State<EditOwnerPage> createState() => _EditOwnerPageState();
}

class _EditOwnerPageState extends State<EditOwnerPage> {
  final service = OwnerService();

  late TextEditingController _nameC;
  late TextEditingController _phoneC;
  late TextEditingController _emailC;
  late TextEditingController _addressC;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameC = TextEditingController(text: widget.owner.name);
    _phoneC = TextEditingController(text: widget.owner.phone);
    _emailC = TextEditingController(text: widget.owner.email);
    _addressC = TextEditingController(text: widget.owner.address);
  }

  Future<void> _updateOwner() async {
    if (!_formKey.currentState!.validate()) return;

    final updated = Owner(
      id: widget.owner.id,
      userId: widget.owner.userId,
      name: _nameC.text.trim(),
      phone: _phoneC.text.trim(),
      email: _emailC.text.trim(),
      address: _addressC.text.trim(),
    );

    await service.update(updated);
    Navigator.pop(context, updated);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chỉnh sửa Chủ Sở Hữu"),
        backgroundColor: Colors.orangeAccent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTextField(Icons.person, "Tên Chủ Sở Hữu", _nameC),
              const SizedBox(height: 10),
              _buildTextField(Icons.phone, "Số Điện Thoại", _phoneC),
              const SizedBox(height: 10),
              _buildTextField(Icons.email, "Email", _emailC, isEmail: true),
              const SizedBox(height: 10),
              _buildTextField(Icons.location_on, "Địa Chỉ", _addressC),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _updateOwner,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orangeAccent,
                  ),
                  child: const Text(
                    "LƯU THÔNG TIN",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      IconData icon, String label, TextEditingController controller,
      {bool isEmail = false}) {
    return TextFormField(
      controller: controller,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return '$label không được để trống';
        }
        if (isEmail && !value.contains('@')) {
          return 'Email không hợp lệ';
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.orangeAccent),
        // không bo tròn, dùng viền mặc định
        border: const UnderlineInputBorder(),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
      ),
    );
  }
}