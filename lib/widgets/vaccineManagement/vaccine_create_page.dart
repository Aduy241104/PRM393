import 'package:flutter/material.dart';

import 'vaccine_form_page.dart';

class VaccineCreatePage extends StatelessWidget {
  const VaccineCreatePage({super.key, required this.userId});

  final int? userId;

  @override
  Widget build(BuildContext context) {
    return VaccineFormPage(userId: userId);
  }
}
