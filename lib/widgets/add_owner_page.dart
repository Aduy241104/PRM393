import 'package:flutter/material.dart';
import '../models/owner.dart';
import '../database/owner_service.dart';

class AddOwnerPage extends StatefulWidget {
  final int userId;

  const AddOwnerPage({super.key, required this.userId});

  @override
  State<AddOwnerPage> createState() => _AddOwnerPageState();
}

class _AddOwnerPageState extends State<AddOwnerPage> {
  final service = OwnerService();

  late TextEditingController _nameC;
  late TextEditingController _phoneC;
  late TextEditingController _emailC;
  late TextEditingController _addressC;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameC = TextEditingController();
    _phoneC = TextEditingController();
    _emailC = TextEditingController();
    _addressC = TextEditingController();
  }

  Future<void> _saveOwner() async {
    if (!_formKey.currentState!.validate()) return;

    final owner = Owner(
      userId: widget.userId,
      name: _nameC.text.trim(),
      phone: _phoneC.text.trim(),
      email: _emailC.text.trim(),
      address: _addressC.text.trim(),
    );

    await service.insert(owner);
    Navigator.pop(context, owner);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Thêm Chủ Sở Hữu"),
        backgroundColor: Colors.orangeAccent,
        centerTitle: true,
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
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _saveOwner,
                      icon: const Icon(Icons.add, color: Colors.white),
                      label: const Text(
                        "Lưu",
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orangeAccent,
                        minimumSize: const Size(double.infinity, 50),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.cancel, color: Colors.white),
                      label: const Text(
                        "Hủy",
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                        minimumSize: const Size(double.infinity, 50),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
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
        border: const UnderlineInputBorder(), // viền mặc định, không bo tròn
        contentPadding:
            const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
      ),
    );
  }
}