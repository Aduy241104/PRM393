import 'package:flutter/material.dart';

import '../../models/vaccine.dart';

class VaccineDetailPage extends StatelessWidget {
  const VaccineDetailPage({
    super.key,
    required this.vaccine,
    required this.petName,
    required this.ownerName,
  });

  final Vaccine vaccine;
  final String petName;
  final String ownerName;

  String _formatDateTime(String dateStr) {
    try {
      // Remove milliseconds and keep only: YYYY-MM-DD HH:mm:ss
      if (dateStr.contains('.')) {
        dateStr = dateStr.split('.').first;
      }
      return dateStr;
    } catch (_) {
      return dateStr;
    }
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi tiết vaccine'),
        backgroundColor: Colors.orange,
      ),
      backgroundColor: Colors.orange[50],
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Thông tin vaccine',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.orange[800],
                            ),
                      ),
                      const SizedBox(height: 16),
                      const Divider(),
                      _infoRow('ID', '${vaccine.id ?? '-'}'),
                      const Divider(height: 1),
                      _infoRow('Tên vaccine', vaccine.vaccineName),
                      const Divider(height: 1),
                      _infoRow('Chủ nuôi', ownerName),
                      const Divider(height: 1),
                      _infoRow('Thú cưng', petName),
                      const Divider(height: 1),
                      _infoRow('Ngày tiêm', _formatDateTime(vaccine.date)),
                      const Divider(height: 1),
                      _infoRow('Lần tiêm kế', _formatDateTime(vaccine.nextDueDate)),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
