import 'package:flutter/material.dart';
import '../../database/service_booking_service.dart';
import '../../models/service.dart';
import 'add_service_list_page.dart';
import 'edit_service_list_page.dart';

class ServiceListScreen extends StatefulWidget {
  final int petId;
  const ServiceListScreen({super.key, required this.petId});

  @override
  State<ServiceListScreen> createState() => _ServiceListScreenState();
}

class _ServiceListScreenState extends State<ServiceListScreen> {
  List<Service> services = [];

  @override
  void initState() {
    super.initState();
    _loadServices();
  }

  Future<void> _loadServices() async {
    final data = await ServiceBookingService.instance.getServicesByPet(
      widget.petId,
    );
    setState(() {
      services = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Service Bookings"),
        backgroundColor: Colors.orangeAccent,
      ),
      body: services.isEmpty
          ? const Center(
              child: Text(
                "Chưa có dịch vụ nào!",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
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
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditServiceScreen(service: s),
                        ),
                      );
                      if (result == true) _loadServices();
                    },
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () async {
                        await ServiceBookingService.instance.deleteService(
                          s.id!,
                        );
                        _loadServices();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Xóa dịch vụ thành công"),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddServiceScreen(petId: widget.petId),
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
