import 'package:flutter/material.dart';
import '../../database/service_booking_service.dart';
import '../../models/service.dart';
import 'add_service_list_page.dart';
import 'service_detail_screen.dart'; // 👈 NEW

class ServiceListScreen extends StatefulWidget {
  final int petId;
  const ServiceListScreen({super.key, required this.petId});

  @override
  State<ServiceListScreen> createState() => _ServiceListScreenState();
}

class _ServiceListScreenState extends State<ServiceListScreen> {
  List<Service> services = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadServices();
  }

  Future<void> _loadServices() async {
    try {
      setState(() => isLoading = true);

      final data = await ServiceBookingService.instance.getServicesByPet(
        widget.petId,
      );

      setState(() => services = data);
    } catch (e) {
      _showMessage("Không tải được dữ liệu");
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  /// 🔥 DELETE CÓ CONFIRM
  Future<void> _deleteService(int id) async {
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

    try {
      await ServiceBookingService.instance.deleteService(id);
      _loadServices();
      _showMessage("Xóa thành công");
    } catch (e) {
      _showMessage("Xóa thất bại");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Service Bookings"),
        backgroundColor: Colors.orangeAccent,
      ),

      /// 🔥 BODY
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : services.isEmpty
          ? const Center(
              child: Text(
                "Chưa có dịch vụ nào!",
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: services.length,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (context, index) {
                final s = services[index];

                return Card(
                  elevation: 2,
                  child: ListTile(
                    leading: const Icon(
                      Icons.medical_services,
                      color: Colors.orange,
                    ),

                    title: Text(
                      s.serviceName,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),

                    subtitle: Text(
                      "${s.date} • ${s.price.toStringAsFixed(0)} VND",
                    ),

                    /// 🔥 CLICK → VIEW DETAIL (NEW)
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ServiceDetailScreen(service: s),
                        ),
                      );

                      if (result == true) _loadServices();
                    },

                    /// 🔥 DELETE
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteService(s.id!),
                    ),
                  ),
                );
              },
            ),

      /// 🔥 ADD BUTTON
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AddServiceScreen(petId: widget.petId),
            ),
          );

          if (result == true) _loadServices();
        },
        backgroundColor: Colors.orange,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          "Thêm dịch vụ",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
