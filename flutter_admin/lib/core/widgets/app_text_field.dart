import 'package:flutter/material.dart';

class AppTextField extends StatefulWidget {
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
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late bool hide = widget.obscure;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      obscureText: hide,
      onSubmitted: widget.onSubmit,
      cursorWidth: 1.5,
      decoration: InputDecoration(
        labelText: widget.label,
        border: const OutlineInputBorder(),
        suffixIcon: widget.obscure
            ? IconButton(
                splashRadius: 20,
                onPressed: () => setState(() => hide = !hide),
                icon: Icon(hide ? Icons.visibility_off : Icons.visibility),
              )
            : null,
      ),
    );
  }
}
