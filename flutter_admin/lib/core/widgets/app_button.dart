import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.busy = false,
    this.outlined = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool busy;
  final bool outlined;

  @override
  Widget build(BuildContext context) {
    final child = Text(busy ? 'wait...' : label);

    if (outlined) {
      return OutlinedButton(
        onPressed: busy ? null : onPressed,
        child: child,
      );
    }

    return SizedBox(
      height: 46.h,
      child: FilledButton(
        onPressed: busy ? null : onPressed,
        child: child,
      ),
    );
  }
}
