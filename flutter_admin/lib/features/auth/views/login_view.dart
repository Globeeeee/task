import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../core/utils/error_message.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/error_text.dart';
import '../../../core/widgets/page_body.dart';
import '../../../routes/app_router.dart';
import '../services/auth_service.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final email = TextEditingController(text: 'admin@gmail.com');
  final pass = TextEditingController(text: 'Admin@123');

  bool busy = false;
  String err = '';

  @override
  void dispose() {
    email.dispose();
    pass.dispose();
    super.dispose();
  }

  Future<void> _go() async {
    setState(() {
      busy = true;
      err = '';
    });

    try {
      await context.read<AuthService>().login(email.text.trim(), pass.text);
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, Routes.bookings);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        err = cleanErr(e);
        busy = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageBody(
        maxWidth: 420,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(32.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Admin Panel',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 28.sp, fontWeight: FontWeight.w700),
              ),
              SizedBox(height: 6.h),
              Text(
                'login to manage bookings',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14.sp, color: Colors.grey[700]),
              ),
              SizedBox(height: 28.h),
              AppTextField(controller: email, label: 'Email'),
              SizedBox(height: 12.h),
              AppTextField(
                controller: pass,
                label: 'Password',
                obscure: true,
                onSubmit: (_) => _go(),
              ),
              if (err.isNotEmpty) ...[
                SizedBox(height: 10.h),
                ErrorText(err),
              ],
              SizedBox(height: 18.h),
              AppButton(label: 'Login', busy: busy, onPressed: _go),
            ],
          ),
        ),
      ),
    );
  }
}
