import 'package:flutter/material.dart';
import '../database/medical_record_service.dart';
import '../models/medicalRecord.dart';
import '../models/pet.dart';
import 'add_medical_record_page.dart';
import 'edit_medical_record_page.dart';
import 'medical_record_detail_page.dart';

class MedicalRecordListPage extends StatefulWidget {
  final Pet pet;

  const MedicalRecordListPage({super.key, required this.pet});

  @override
  State<MedicalRecordListPage> createState() => _MedicalRecordListPageState();
}

class _MedicalRecordListPageState extends State<MedicalRecordListPage> {
  final _service = MedicalRecordService();
  List<MedicalRecord> _records = [];

  @override
  void initState() {
    super.initState();
    _loadRecords();
  }

  Future<void> _loadRecords() async {
    _records = await _service.getRecordsByPet(widget.pet.id!);
    setState(() {});
  }

  Future<void> _deleteRecord(int id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Xác nhận"),
        content: const Text("Bạn có chắc muốn xóa hồ sơ khám này không?"),
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

    if (confirm == true) {
      await _service.deleteRecord(id);
      await _loadRecords();
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Đã xóa hồ sơ khám")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hồ sơ khám - ${widget.pet.name}"),
        backgroundColor: Colors.orangeAccent,
      ),
      body: _records.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.medical_information_outlined,
                    size: 72,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "Chưa có hồ sơ khám",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    "Bấm + để thêm hồ sơ mới",
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: _records.length,
              itemBuilder: (context, index) {
                final record = _records[index];
                return Card(
                  child: ListTile(
                    onTap: () async {
                      final result = await Navigator.push<bool>(
                        context,
                        MaterialPageRoute(
                          builder: (_) => MedicalRecordDetailPage(
                            petName: widget.pet.name,
                            record: record,
                          ),
                        ),
                      );
                      if (result == true) {
                        _loadRecords();
                      }
                    },
                    title: Text(
                      record.diagnosis.isEmpty
                          ? "(Chưa có chẩn đoán)"
                          : record.diagnosis,
                    ),
                    subtitle: Text(_formatDateTimeNoSeconds(record.date)),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => EditMedicalRecordPage(
                                  record: record,
                                ),
                              ),
                            );
                            _loadRecords();
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteRecord(record.id!),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        child: const Icon(Icons.add),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AddMedicalRecordPage(petId: widget.pet.id!),
            ),
          );
          _loadRecords();
        },
      ),
    );
  }
}

String _formatDateTimeNoSeconds(String input) {
  try {
    final dt = DateTime.parse(input);
    final y = dt.year.toString().padLeft(4, '0');
    final m = dt.month.toString().padLeft(2, '0');
    final d = dt.day.toString().padLeft(2, '0');
    final hh = dt.hour.toString().padLeft(2, '0');
    final mm = dt.minute.toString().padLeft(2, '0');
    return '$y-$m-$d $hh:$mm';
  } catch (_) {
    return input.length >= 16 ? input.substring(0, 16) : input;
  }
}
