import 'package:flutter/material.dart';
import '../database/medical_record_service.dart';
import '../models/medicalRecord.dart';

class EditMedicalRecordPage extends StatefulWidget {
  final MedicalRecord record;

  const EditMedicalRecordPage({super.key, required this.record});

  @override
  State<EditMedicalRecordPage> createState() => _EditMedicalRecordPageState();
}

class _EditMedicalRecordPageState extends State<EditMedicalRecordPage> {
  final _service = MedicalRecordService();
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _diagnosisCtrl;
  late TextEditingController _treatmentCtrl;
  late TextEditingController _dateCtrl;

  @override
  void initState() {
    super.initState();
    _diagnosisCtrl = TextEditingController(text: widget.record.diagnosis);
    _treatmentCtrl = TextEditingController(text: widget.record.treatment);
    _dateCtrl = TextEditingController(
      text: _formatDateTimeNoSeconds(widget.record.date),
    );
  }

  @override
  void dispose() {
    _diagnosisCtrl.dispose();
    _treatmentCtrl.dispose();
    _dateCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDateTime() async {
    final now = DateTime.now();
    final current = _tryParseDateTime(_dateCtrl.text) ?? now;

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: current,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate == null) return;

    if (!mounted) return;
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: current.hour, minute: current.minute),
    );
    if (pickedTime == null) return;

    final selected = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
    );

    setState(() {
      _dateCtrl.text = _formatDateTimeNoSeconds(selected.toString());
    });
  }

  String? _requiredValidator(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return "Không được để trống $fieldName";
    }
    return null;
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    await _service.updateRecord(
      MedicalRecord(
        id: widget.record.id,
        petId: widget.record.petId,
        diagnosis: _diagnosisCtrl.text.trim(),
        treatment: _treatmentCtrl.text.trim(),
        date: _formatDateTimeNoSeconds(_dateCtrl.text.trim()),
      ),
    );

    if (!mounted) return;
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sửa hồ sơ khám"),
        backgroundColor: Colors.orangeAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _diagnosisCtrl,
                decoration: const InputDecoration(labelText: "Chẩn đoán"),
                validator: (value) => _requiredValidator(value, "chẩn đoán"),
              ),
              TextFormField(
                controller: _treatmentCtrl,
                decoration: const InputDecoration(labelText: "Điều trị"),
                validator: (value) => _requiredValidator(value, "điều trị"),
              ),
              TextFormField(
                controller: _dateCtrl,
                readOnly: true,
                onTap: _pickDateTime,
                decoration: InputDecoration(
                  labelText: "Ngày khám",
                  suffixIcon: IconButton(
                    onPressed: _pickDateTime,
                    icon: const Icon(Icons.access_time),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orangeAccent,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text("Hủy"),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _save,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orangeAccent,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text("Cập nhật"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
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

DateTime? _tryParseDateTime(String input) {
  try {
    return DateTime.parse(input);
  } catch (_) {
    return null;
  }
}
