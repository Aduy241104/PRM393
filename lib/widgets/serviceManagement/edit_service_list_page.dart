import 'package:flutter/material.dart';
import '../../database/service_booking_service.dart';
import '../../models/service.dart';

class EditServiceScreen extends StatefulWidget {
  final Service service;
  const EditServiceScreen({super.key, required this.service});

  @override
  State<EditServiceScreen> createState() => _EditServiceScreenState();
}

class _EditServiceScreenState extends State<EditServiceScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _serviceNameController;
  late TextEditingController _priceController;
  late TextEditingController _dateController;
  late TextEditingController _noteController;

  @override
  void initState() {
    super.initState();
    _serviceNameController = TextEditingController(
      text: widget.service.serviceName,
    );
    _priceController = TextEditingController(
      text: widget.service.price.toString(),
    );
    _dateController = TextEditingController(text: widget.service.date);
    _noteController = TextEditingController(text: widget.service.note);
  }

  @override
  void dispose() {
    _serviceNameController.dispose();
    _priceController.dispose();
    _dateController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _updateService() async {
    if (_formKey.currentState!.validate()) {
      final updated = Service(
        id: widget.service.id,
        petId: widget.service.petId,
        serviceName: _serviceNameController.text.trim(),
        price: double.parse(_priceController.text),
        date: _dateController.text,
        note: _noteController.text.trim(),
      );
      await ServiceBookingService.instance.updateService(updated);
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Chỉnh sửa dịch vụ")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _serviceNameController,
                decoration: const InputDecoration(
                  labelText: "Tên dịch vụ",
                  prefixIcon: Icon(Icons.medical_services),
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value == null || value.trim().isEmpty
                    ? "Nhập tên dịch vụ"
                    : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(
                  labelText: "Giá",
                  prefixIcon: Icon(Icons.attach_money),
                  border: OutlineInputBorder(),
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
                decoration: const InputDecoration(
                  labelText: "Ngày",
                  prefixIcon: Icon(Icons.calendar_today),
                  border: OutlineInputBorder(),
                ),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate:
                        DateTime.tryParse(_dateController.text) ??
                        DateTime.now(),
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
                decoration: const InputDecoration(
                  labelText: "Ghi chú",
                  prefixIcon: Icon(Icons.note),
                  border: OutlineInputBorder(),
                ),
                maxLength: 200,
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _updateService,
                icon: const Icon(Icons.save),
                label: const Text("Cập nhật"),
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
