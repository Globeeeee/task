import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/utils/error_message.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/error_text.dart';
import '../../../routes/app_router.dart';
import '../services/auth_service.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final email = TextEditingController();
  final pass = TextEditingController();

  bool loading = false;
  String error = '';

  @override
  void dispose() {
    email.dispose();
    pass.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    setState(() {
      loading = true;
      error = '';
    });

    try {
      await context.read<AuthService>().login(email.text.trim(), pass.text);
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, Routes.home);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        error = cleanErr(e);
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32),
          child: SizedBox(
            width: 420,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Admin Panel',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                const Text(
                  'login to manage stuff',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 30),
                AppTextField(controller: email, label: 'Email'),
                const SizedBox(height: 12),
                AppTextField(
                  controller: pass,
                  label: 'Password',
                  obscure: true,
                  onSubmit: (_) => _login(),
                ),
                if (error.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  ErrorText(error),
                ],
                const SizedBox(height: 20),
                AppButton(label: 'Login', loading: loading, onPressed: _login),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
