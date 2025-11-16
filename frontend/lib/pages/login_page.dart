import 'package:flutter/material.dart';
import 'package:idocs/providers/auth_provider.dart';
import 'package:idocs/services/api_service.dart';
import 'package:idocs/utils.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool obscureText = true;

  @override
  Widget build(BuildContext context) {
    final authProvider = context.read<AuthProvider>();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Container(
          width: 400,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.all(40),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 10,
            children: [
              const Text(
                "iDocs",
                style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
              ),
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Email',
                ),
              ),
              TextField(
                controller: passwordController,
                keyboardType: TextInputType.visiblePassword,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                  suffixIcon: GestureDetector(
                    onTap: () => setState(() {
                      obscureText = !obscureText;
                    }),
                    child: Icon(
                      obscureText ? Icons.visibility : Icons.visibility_off,
                    ),
                  ),
                ),
                obscureText: obscureText,
              ),
              FilledButton(
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.all(20),
                ),
                onPressed: () async {
                  if (emailController.text.isNotEmpty &&
                      passwordController.text.isNotEmpty) {
                    try {
                      final result = await ApiService.login(
                        emailController.text.trim(),
                        passwordController.text.trim(),
                      );
                      
                      if (result['success'] && result['token'] != null) {
                        await authProvider.login(result['token']);
                      }
                      
                      showSnackBar(result['message'], context);
                    } on Exception catch (e) {
                      debugPrint(e.toString());
                    }
                  }
                },
                child: const Text("Login"),
              ),
              FilledButton.tonal(
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.all(20),
                ),
                onPressed: () async {
                  if (emailController.text.isNotEmpty &&
                      passwordController.text.isNotEmpty) {
                    try {
                      final result = await ApiService.register(
                        emailController.text.trim(),
                        passwordController.text.trim(),
                      );
                      
                      if (result['success'] && result['token'] != null) {
                        await authProvider.login(result['token']);
                      }
                      
                      showSnackBar(result['message'], context);
                    } on Exception catch (e) {
                      debugPrint(e.toString());
                    }
                  }
                },
                child: const Text("Register"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
