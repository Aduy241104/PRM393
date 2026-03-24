import 'package:flutter/material.dart';

import '../database/vaccine_service.dart';
import '../models/pet.dart';
import '../models/vaccine.dart';

class VaccineManagementPage extends StatefulWidget {
  const VaccineManagementPage({super.key, required this.userId});

  final int? userId;

  @override
  State<VaccineManagementPage> createState() => _VaccineManagementPageState();
}

class _VaccineManagementPageState extends State<VaccineManagementPage> {
  final VaccineService _vaccineService = VaccineService.instance;

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
      _pets = pets;
      _vaccines = vaccines;
    });
  }

  Future<void> _deleteVaccine(int vaccineId) async {
    await _vaccineService.deleteVaccine(vaccineId);
    await _loadData();
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
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Add vaccine',
            onPressed: () async {
              final added = await Navigator.push<bool>(
                context,
                MaterialPageRoute(
                  builder: (context) => VaccineAddPage(userId: widget.userId),
                ),
              );

              if (added == true) {
                await _loadData();
              }
            },
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
                                      : () async {
                                          final updated =
                                              await Navigator.push<bool>(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      VaccineEditPage(
                                                        userId: widget.userId,
                                                        vaccine: vaccine,
                                                      ),
                                                ),
                                              );
                                          if (updated == true) {
                                            await _loadData();
                                          }
                                        },
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

class VaccineAddPage extends StatefulWidget {
  const VaccineAddPage({super.key, required this.userId});

  final int? userId;

  @override
  State<VaccineAddPage> createState() => _VaccineAddPageState();
}

class _VaccineAddPageState extends State<VaccineAddPage> {
  final VaccineService _vaccineService = VaccineService.instance;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _nextDueController = TextEditingController();

  List<Pet> _pets = [];

  Pet? _selectedPet;

  @override
  void initState() {
    super.initState();
    _loadPetsByLoggedInOwner();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dateController.dispose();
    _nextDueController.dispose();
    super.dispose();
  }

  Future<void> _loadPetsByLoggedInOwner() async {
    if (widget.userId == null) {
      if (!mounted) return;
      setState(() {
        _pets = [];
        _selectedPet = null;
      });
      return;
    }

    final owner = await _vaccineService.getOwnerByUserId(widget.userId!);
    if (owner?.id == null) {
      if (!mounted) return;
      setState(() {
        _pets = [];
        _selectedPet = null;
      });
      return;
    }

    final pets = await _vaccineService.getPetsByOwner(owner!.id!);
    if (!mounted) return;

    setState(() {
      _pets = pets;
      _selectedPet = pets.isNotEmpty ? pets.first : null;
    });
  }

  Future<void> _addVaccine() async {
    if (_selectedPet?.id == null) return;

    final vaccineName = _nameController.text.trim();
    if (vaccineName.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Nhap ten vaccine')));
      return;
    }

    final today = DateTime.now().toIso8601String().split('T').first;
    final date = _dateController.text.trim().isEmpty
        ? today
        : _dateController.text.trim();
    final nextDueDate = _nextDueController.text.trim().isEmpty
        ? DateTime.now()
              .add(const Duration(days: 365))
              .toIso8601String()
              .split('T')
              .first
        : _nextDueController.text.trim();

    await _vaccineService.addVaccine(
      petId: _selectedPet!.id!,
      vaccineName: vaccineName,
      date: date,
      nextDueDate: nextDueDate,
    );

    if (!mounted) return;
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Vaccine'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Text(
              widget.userId == null
                  ? 'Khong xac dinh duoc tai khoan dang nhap'
                  : 'Chi hien thi pet cua tai khoan hien tai',
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<Pet>(
              value: _selectedPet,
              decoration: const InputDecoration(
                labelText: 'Pet',
                border: OutlineInputBorder(),
              ),
              items: _pets
                  .map(
                    (pet) => DropdownMenuItem<Pet>(
                      value: pet,
                      child: Text('${pet.name} (${pet.type})'),
                    ),
                  )
                  .toList(),
              onChanged: (pet) {
                setState(() {
                  _selectedPet = pet;
                });
              },
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Vaccine name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _dateController,
              decoration: const InputDecoration(
                labelText: 'Date (YYYY-MM-DD)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _nextDueController,
              decoration: const InputDecoration(
                labelText: 'Next due (YYYY-MM-DD)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _addVaccine,
                child: const Text('Save vaccine'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class VaccineEditPage extends StatefulWidget {
  const VaccineEditPage({
    super.key,
    required this.userId,
    required this.vaccine,
  });

  final int? userId;
  final Vaccine vaccine;

  @override
  State<VaccineEditPage> createState() => _VaccineEditPageState();
}

class _VaccineEditPageState extends State<VaccineEditPage> {
  final VaccineService _vaccineService = VaccineService.instance;

  late final TextEditingController _nameController;
  late final TextEditingController _dateController;
  late final TextEditingController _nextDueController;

  List<Pet> _pets = [];
  Pet? _selectedPet;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.vaccine.vaccineName);
    _dateController = TextEditingController(text: widget.vaccine.date);
    _nextDueController = TextEditingController(
      text: widget.vaccine.nextDueDate,
    );
    _loadPetsByLoggedInOwner();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dateController.dispose();
    _nextDueController.dispose();
    super.dispose();
  }

  Future<void> _loadPetsByLoggedInOwner() async {
    if (widget.userId == null) {
      if (!mounted) return;
      setState(() {
        _pets = [];
        _selectedPet = null;
      });
      return;
    }

    final owner = await _vaccineService.getOwnerByUserId(widget.userId!);
    if (owner?.id == null) {
      if (!mounted) return;
      setState(() {
        _pets = [];
        _selectedPet = null;
      });
      return;
    }

    final pets = await _vaccineService.getPetsByOwner(owner!.id!);
    if (!mounted) return;

    Pet? selectedPet;
    for (final pet in pets) {
      if (pet.id == widget.vaccine.petId) {
        selectedPet = pet;
        break;
      }
    }
    selectedPet ??= pets.isNotEmpty ? pets.first : null;

    setState(() {
      _pets = pets;
      _selectedPet = selectedPet;
    });
  }

  Future<void> _updateVaccine() async {
    if (widget.vaccine.id == null || _selectedPet?.id == null) return;

    final vaccineName = _nameController.text.trim();
    if (vaccineName.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Nhap ten vaccine')));
      return;
    }

    final today = DateTime.now().toIso8601String().split('T').first;
    final date = _dateController.text.trim().isEmpty
        ? today
        : _dateController.text.trim();
    final nextDueDate = _nextDueController.text.trim().isEmpty
        ? DateTime.now()
              .add(const Duration(days: 365))
              .toIso8601String()
              .split('T')
              .first
        : _nextDueController.text.trim();

    await _vaccineService.updateVaccine(
      vaccineId: widget.vaccine.id!,
      petId: _selectedPet!.id!,
      vaccineName: vaccineName,
      date: date,
      nextDueDate: nextDueDate,
    );

    if (!mounted) return;
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Vaccine'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            DropdownButtonFormField<Pet>(
              value: _selectedPet,
              decoration: const InputDecoration(
                labelText: 'Pet',
                border: OutlineInputBorder(),
              ),
              items: _pets
                  .map(
                    (pet) => DropdownMenuItem<Pet>(
                      value: pet,
                      child: Text('${pet.name} (${pet.type})'),
                    ),
                  )
                  .toList(),
              onChanged: (pet) {
                setState(() {
                  _selectedPet = pet;
                });
              },
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Vaccine name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _dateController,
              decoration: const InputDecoration(
                labelText: 'Date (YYYY-MM-DD)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _nextDueController,
              decoration: const InputDecoration(
                labelText: 'Next due (YYYY-MM-DD)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _updateVaccine,
                child: const Text('Update vaccine'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
