import 'package:flutter/material.dart';

import '../../database/vaccine_service.dart';
import '../../models/owner.dart';
import '../../models/pet.dart';
import '../../models/vaccine.dart';
import 'vaccine_create_page.dart';
import 'vaccine_detail_page.dart';
import 'vaccine_update_page.dart';

class VaccineManagementPage extends StatefulWidget {
  const VaccineManagementPage({super.key, required this.userId});

  final int? userId;

  @override
  State<VaccineManagementPage> createState() => _VaccineManagementPageState();
}

class _VaccineManagementPageState extends State<VaccineManagementPage> {
  final VaccineService _vaccineService = VaccineService.instance;

  Owner? _owner;
  List<Pet> _pets = [];
  List<Vaccine> _vaccines = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    if (widget.userId == null) {
      if (!mounted) return;
      setState(() {
        _pets = [];
        _vaccines = [];
      });
      return;
    }

    final owner = await _vaccineService.getOwnerByUserId(widget.userId!);
    if (owner?.id == null) {
      if (!mounted) return;
      setState(() {
        _owner = null;
        _pets = [];
        _vaccines = [];
      });
      return;
    }

    final pets = await _vaccineService.getPetsByOwner(owner!.id!);
    final petIds = pets
        .where((pet) => pet.id != null)
        .map((pet) => pet.id!)
        .toList();
    final vaccines = await _vaccineService.getVaccinesByPetIds(petIds);
    if (!mounted) return;

    setState(() {
      _owner = owner;
      _pets = pets;
      _vaccines = vaccines;
    });
  }

  Future<void> _deleteVaccine(int vaccineId) async {
    await _vaccineService.deleteVaccine(vaccineId);
    await _loadData();
  }

  Future<void> _openCreate() async {
    final changed = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => VaccineCreatePage(userId: widget.userId),
      ),
    );

    if (changed == true) {
      await _loadData();
    }
  }

  Future<void> _openUpdate(Vaccine vaccine) async {
    final changed = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) =>
            VaccineUpdatePage(userId: widget.userId, vaccine: vaccine),
      ),
    );

    if (changed == true) {
      await _loadData();
    }
  }

  Future<void> _openDetail(Vaccine vaccine) async {
    await Navigator.push<void>(
      context,
      MaterialPageRoute(
        builder: (context) => VaccineDetailPage(
          vaccine: vaccine,
          petName: _getPetName(vaccine.petId),
          ownerName: _owner?.name ?? '-',
        ),
      ),
    );
  }

  Future<void> _confirmDeleteVaccine(Vaccine vaccine) async {
    if (vaccine.id == null) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Xac nhan xoa'),
          content: Text(
            'Ban co chac muon xoa vaccine "${vaccine.vaccineName}"?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Huy'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Xoa'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      await _deleteVaccine(vaccine.id!);
    }
  }

  String _getPetName(int petId) {
    for (final pet in _pets) {
      if (pet.id == petId) {
        return pet.name;
      }
    }
    return 'Pet #$petId';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vaccine List'),
        backgroundColor: Colors.orangeAccent,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Add vaccine',
            onPressed: _openCreate,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.userId == null
                  ? 'Khong xac dinh duoc tai khoan dang nhap'
                  : 'Vaccine cua tai khoan hien tai',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            const Text(
              'Vaccine list',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: _vaccines.isEmpty
                  ? const Center(child: Text('No vaccine data'))
                  : ListView.builder(
                      itemCount: _vaccines.length,
                      itemBuilder: (context, index) {
                        final vaccine = _vaccines[index];
                        return Card(
                          child: ListTile(
                            onTap: () => _openDetail(vaccine),
                            title: Text(vaccine.vaccineName),
                            subtitle: Text(
                              'Pet: ${_getPetName(vaccine.petId)}\nDate: ${vaccine.date}\nNext due: ${vaccine.nextDueDate}',
                            ),
                            isThreeLine: true,
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.edit,
                                    color: Colors.blue,
                                  ),
                                  onPressed: vaccine.id == null
                                      ? null
                                      : () => _openUpdate(vaccine),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed: vaccine.id == null
                                      ? null
                                      : () => _confirmDeleteVaccine(vaccine),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
