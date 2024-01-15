import 'package:flutter/material.dart';
import 'package:just_chat/services/auth/auth_service.dart';
import 'package:just_chat/components/my_button.dart';
import 'package:just_chat/components/my_textfield.dart';

class RegisterPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final void Function()? onTap;

  RegisterPage({
    super.key,
    this.onTap,
  });

  void register(BuildContext context) {
    final authService = AuthService();

    if (_passwordController.text == _confirmPasswordController.text) {
      try {
        authService.signUpWithEmailPassword(
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
    } else {
      showDialog(
        context: context,
        builder: (context) => const AlertDialog(
          title: Text("As senhas não coincidem"),
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
            Text(
              "Criar uma nova conta",
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),

            // email TextField

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

            const SizedBox(height: 10),

            MyTextField(
              hintText: "Confirmar senha",
              controller: _confirmPasswordController,
              obscureText: true,
            ),

            const SizedBox(height: 25),
            // login Button
            MyButton(
              text: "Registrar",
              onTap: () => register(context),
            ),
            const SizedBox(height: 10),

            GestureDetector(
              onTap: onTap,
              child: Text(
                "Voltar",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.outline,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
