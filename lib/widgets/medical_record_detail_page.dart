import 'package:flutter/material.dart';
import '../database/medical_record_service.dart';
import '../models/medicalRecord.dart';
import 'edit_medical_record_page.dart';

class MedicalRecordDetailPage extends StatelessWidget {
  final String petName;
  final MedicalRecord record;

  const MedicalRecordDetailPage({
    super.key,
    required this.petName,
    required this.record,
  });

  @override
  Widget build(BuildContext context) {
    final service = MedicalRecordService();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Chi tiết hồ sơ khám"),
        backgroundColor: Colors.orangeAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Thú cưng: $petName", style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 12),
            Text(
              "Chẩn đoán: ${record.diagnosis}",
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 12),
            Text(
              "Điều trị: ${record.treatment}",
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 12),
            Text(
              "Ngày khám: ${_formatDateTimeNoSeconds(record.date)}",
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _handleDelete(context, service),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orangeAccent,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text("Xóa"),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _handleEdit(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orangeAccent,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text("Sửa"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleDelete(
    BuildContext context,
    MedicalRecordService service,
  ) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Xác nhận"),
        content: const Text("Bạn có chắc muốn xóa hồ sơ này?"),
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
      await service.deleteRecord(record.id!);
      if (!context.mounted) return;
      Navigator.pop(context, true);
    }
  }

  Future<void> _handleEdit(BuildContext context) async {
    final changed = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => EditMedicalRecordPage(record: record),
      ),
    );
    if (changed == true && context.mounted) {
      Navigator.pop(context, true);
    }
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
