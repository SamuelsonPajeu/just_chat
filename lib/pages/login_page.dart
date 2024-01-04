import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'images/whatsapp2-logo.png',
              width: 100,
              height: 100,
            ),
            const SizedBox(
              height: 15,
            ),
            Text("WHATSAPP 2 CLOSED BETA"),
          ],
        ),
      ),
    );
  }
}
