import 'package:flutter/material.dart';
import 'package:just_chat/pages/settings_page.dart';
import 'package:just_chat/services/auth/auth_service.dart';

class MyDrawer extends StatelessWidget {
  MyDrawer({super.key});

  final AuthService authService = AuthService();

  void logout() {
    authService.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.background,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Theme(
                data: Theme.of(context).copyWith(
                  dividerTheme:
                      const DividerThemeData(color: Colors.transparent),
                ),
                child: DrawerHeader(
                  child: Center(
                    child: Column(
                      children: [
                        Icon(
                          Icons.person,
                          color: Theme.of(context).colorScheme.inversePrimary,
                          size: 64,
                        ),
                        Text(authService.getCurrentUser()!.email!),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: ListTile(
                  title: const Text("H O M E"),
                  leading: const Icon(Icons.home),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: ListTile(
                    title: const Text("C O N F I G U R A Ç Õ E S"),
                    leading: const Icon(Icons.settings),
                    onTap: () {
                      Navigator.pop(context);

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SettingsPage(),
                        ),
                      );
                    }),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10.0, bottom: 30.0),
            child: ListTile(
              title: const Text("S A I R"),
              leading: const Icon(Icons.logout),
              onTap: logout,
            ),
          )
        ],
      ),
    );
  }
}
