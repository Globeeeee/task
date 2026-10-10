import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.loading = false,
    this.outlined = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool loading;
  final bool outlined;

  @override
  Widget build(BuildContext context) {
    final child = loading
        ? SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: outlined
                  ? Theme.of(context).colorScheme.primary
                  : Colors.white,
            ),
          )
        : Text(label);

    if (outlined) {
      return SizedBox(
        height: 46,
        child: OutlinedButton(
          onPressed: loading ? null : onPressed,
          child: child,
        ),
      );
    }

    return SizedBox(
      height: 46,
      child: FilledButton(
        onPressed: loading ? null : onPressed,
        child: child,
      ),
    );
  }
}
