import 'package:flutter/material.dart';
import '../../database/service_booking_service.dart';
import '../../models/service.dart';

class AddServiceScreen extends StatefulWidget {
  final int petId;
  const AddServiceScreen({super.key, required this.petId});

  @override
  State<AddServiceScreen> createState() => _AddServiceScreenState();
}

class _AddServiceScreenState extends State<AddServiceScreen> {
  final _formKey = GlobalKey<FormState>();
  final _serviceNameController = TextEditingController();
  final _priceController = TextEditingController();
  final _dateController = TextEditingController();
  final _noteController = TextEditingController();

  Future<void> _saveService() async {
    if (_formKey.currentState!.validate()) {
      final service = Service(
        petId: widget.petId,
        serviceName: _serviceNameController.text.trim(),
        price: double.parse(_priceController.text),
        date: _dateController.text,
        note: _noteController.text.trim(),
      );
      await ServiceBookingService.instance.addService(service);
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Thêm dịch vụ")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _serviceNameController,
                decoration: InputDecoration(
                  labelText: "Tên dịch vụ",
                  prefixIcon: const Icon(Icons.medical_services),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                validator: (value) => value == null || value.trim().isEmpty
                    ? "Nhập tên dịch vụ"
                    : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _priceController,
                decoration: InputDecoration(
                  labelText: "Giá",
                  prefixIcon: const Icon(Icons.attach_money),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) return "Nhập giá";
                  final price = double.tryParse(value);
                  if (price == null || price <= 0) return "Giá phải > 0";
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _dateController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: "Ngày",
                  prefixIcon: const Icon(Icons.calendar_today),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2035),
                  );
                  if (picked != null) {
                    _dateController.text = picked
                        .toIso8601String()
                        .split('T')
                        .first;
                  }
                },
                validator: (value) =>
                    value == null || value.isEmpty ? "Chọn ngày" : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _noteController,
                decoration: InputDecoration(
                  labelText: "Ghi chú",
                  prefixIcon: const Icon(Icons.note),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                maxLength: 200,
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _saveService,
                icon: const Icon(Icons.save),
                label: const Text("Lưu dịch vụ"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
