import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    required this.controller,
    required this.label,
    this.obscure = false,
    this.onSubmit,
  });

  final TextEditingController controller;
  final String label;
  final bool obscure;
  final ValueChanged<String>? onSubmit;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      onSubmitted: onSubmit,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    );
  }
}
