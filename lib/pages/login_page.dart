import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:just_chat/auth/auth_service.dart';
import 'package:just_chat/components/my_button.dart';
import 'package:just_chat/components/my_textfield.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final void Function()? onTap;

  LoginPage({
    super.key,
    required this.onTap,
  });

  // login method
  void login(BuildContext context) async {
    final authService = AuthService();

    try {
      await authService.signInWithEmailPassword(
        _emailController.text,
        _passwordController.text,
      );
    } catch (e) {
      if (!context.mounted) return;
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            e.toString(),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo

            Image.asset(
              'images/whatsapp2-logo.png',
              width: 100,
              height: 100,
            ),

            const SizedBox(height: 25),

            // email Textfield
            Text(
              "Whatsapp 2",
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            const SizedBox(height: 25),
            MyTextField(
              hintText: "Email",
              controller: _emailController,
            ),

            const SizedBox(height: 10),

            // password Textfield
            MyTextField(
              hintText: "Senha",
              controller: _passwordController,
              obscureText: true,
            ),

            const SizedBox(height: 25),
            // login Button
            MyButton(
              text: "Entrar",
              onTap: () => login(context),
            ),
            const SizedBox(height: 10),
            // register page
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Usuário novo? ",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
                GestureDetector(
                  onTap: onTap,
                  child: Text(
                    "Criar conta",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.outline,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
