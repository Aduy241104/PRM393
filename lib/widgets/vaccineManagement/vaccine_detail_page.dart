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

  Widget _infoTile(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black54,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
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
        title: const Text('Vaccine Detail'),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.5,
                children: [
                  _infoTile('ID', '${vaccine.id ?? '-'}'),
                  _infoTile('Vaccine name', vaccine.vaccineName),
                  _infoTile('Owner', ownerName),
                  _infoTile('Pet', petName),
                  _infoTile('Date', vaccine.date),
                  _infoTile('Next due', vaccine.nextDueDate),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
