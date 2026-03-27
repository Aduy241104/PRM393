import 'package:flutter/material.dart';
import '../../models/service.dart';
import '../../database/service_booking_service.dart';
import 'edit_service_list_page.dart';

class ServiceDetailScreen extends StatelessWidget {
  final Service service;

  const ServiceDetailScreen({super.key, required this.service});

  Future<void> _delete(BuildContext context) async {
    final confirm = await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Xác nhận"),
        content: const Text("Bạn có chắc muốn xóa dịch vụ này?"),
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

    if (confirm != true) return;

    await ServiceBookingService.instance.deleteService(service.id!);

    Navigator.pop(context, true); // trả về list
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Đã xóa dịch vụ")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chi tiết dịch vụ"),
        backgroundColor: Colors.orangeAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 3,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// TITLE
                Text(
                  service.serviceName,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 20),

                /// DATE
                Row(
                  children: [
                    const Icon(Icons.calendar_today, color: Colors.orange),
                    const SizedBox(width: 10),
                    Text(service.date),
                  ],
                ),

                const SizedBox(height: 10),

                /// PRICE
                Row(
                  children: [
                    const Icon(Icons.attach_money, color: Colors.orange),
                    const SizedBox(width: 10),
                    Text("${service.price} VND"),
                  ],
                ),

                const SizedBox(height: 10),

                /// NOTE
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.note, color: Colors.orange),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        service.note.isEmpty
                            ? "Không có ghi chú"
                            : service.note,
                      ),
                    ),
                  ],
                ),

                const Spacer(),

                /// BUTTONS
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  EditServiceScreen(service: service),
                            ),
                          );
                          if (result == true) {
                            Navigator.pop(context, true);
                          }
                        },
                        icon: const Icon(Icons.edit),
                        label: const Text("Chỉnh sửa"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _delete(context),
                        icon: const Icon(Icons.delete),
                        label: const Text("Xóa"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
