import 'package:flutter/material.dart';

import '../../database/vaccine_service.dart';
import '../../models/pet.dart';
import '../../models/vaccine.dart';

class VaccineFormPage extends StatefulWidget {
  const VaccineFormPage({super.key, required this.userId, this.vaccine});

  final int? userId;
  final Vaccine? vaccine;

  @override
  State<VaccineFormPage> createState() => _VaccineFormPageState();
}

class _VaccineFormPageState extends State<VaccineFormPage> {
  final VaccineService _vaccineService = VaccineService.instance;

  late final TextEditingController _nameController;
  late final TextEditingController _dateController;
  late final TextEditingController _nextDueController;

  List<Pet> _pets = [];
  Pet? _selectedPet;

  bool get _isEdit => widget.vaccine != null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.vaccine?.vaccineName ?? '',
    );
    _dateController = TextEditingController(text: widget.vaccine?.date ?? '');
    _nextDueController = TextEditingController(
      text: widget.vaccine?.nextDueDate ?? '',
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
    if (_isEdit) {
      final editingPetId = widget.vaccine!.petId;
      for (final pet in pets) {
        if (pet.id == editingPetId) {
          selectedPet = pet;
          break;
        }
      }
    }
    selectedPet ??= pets.isNotEmpty ? pets.first : null;

    setState(() {
      _pets = pets;
      _selectedPet = selectedPet;
    });
  }

  String _normalizeDate(String value, String fallback) {
    final trimmed = value.trim();
    return trimmed.isEmpty ? fallback : trimmed;
  }

  DateTime? _tryParseDate(String value) {
    final parsed = DateTime.tryParse(value.trim());
    if (parsed == null) return null;
    return DateTime(parsed.year, parsed.month, parsed.day);
  }

  Future<void> _saveVaccine() async {
    if (_selectedPet?.id == null) return;

    final vaccineName = _nameController.text.trim();
    if (vaccineName.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Nhap ten vaccine')));
      return;
    }

    final today = DateTime.now().toIso8601String().split('T').first;
    final defaultNextDue = DateTime.now()
        .add(const Duration(days: 365))
        .toIso8601String()
        .split('T')
        .first;
    final date = _normalizeDate(_dateController.text, today);
    final nextDueDate = _normalizeDate(_nextDueController.text, defaultNextDue);

    final dateValue = _tryParseDate(date);
    final nextDueValue = _tryParseDate(nextDueDate);
    if (dateValue == null || nextDueValue == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ngay khong hop le (YYYY-MM-DD)')),
      );
      return;
    }

    final now = DateTime.now();
    final todayOnly = DateTime(now.year, now.month, now.day);

    if (dateValue.isAfter(todayOnly)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Date khong duoc la ngay trong tuong lai'),
        ),
      );
      return;
    }

    if (!nextDueValue.isAfter(dateValue)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Next due date phai la ngay sau date')),
      );
      return;
    }

    if (_isEdit && widget.vaccine?.id != null) {
      await _vaccineService.updateVaccine(
        vaccineId: widget.vaccine!.id!,
        petId: _selectedPet!.id!,
        vaccineName: vaccineName,
        date: date,
        nextDueDate: nextDueDate,
      );
    } else {
      await _vaccineService.addVaccine(
        petId: _selectedPet!.id!,
        vaccineName: vaccineName,
        date: date,
        nextDueDate: nextDueDate,
      );
    }

    if (!mounted) return;
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEdit ? 'Edit Vaccine' : 'Add Vaccine'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            if (!_isEdit)
              Text(
                widget.userId == null
                    ? 'Khong xac dinh duoc tai khoan dang nhap'
                    : 'Chi hien thi pet cua tai khoan hien tai',
              ),
            if (!_isEdit) const SizedBox(height: 12),
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
                onPressed: _saveVaccine,
                child: Text(_isEdit ? 'Update vaccine' : 'Save vaccine'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
