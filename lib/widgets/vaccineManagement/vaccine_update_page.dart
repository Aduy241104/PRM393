import 'package:flutter/material.dart';

import '../../models/vaccine.dart';
import 'vaccine_form_page.dart';

class VaccineUpdatePage extends StatelessWidget {
  const VaccineUpdatePage({
    super.key,
    required this.userId,
    required this.vaccine,
  });

  final int? userId;
  final Vaccine vaccine;

  @override
  Widget build(BuildContext context) {
    return VaccineFormPage(userId: userId, vaccine: vaccine);
  }
}
