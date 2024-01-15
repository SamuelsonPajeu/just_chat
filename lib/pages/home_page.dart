import 'package:flutter/material.dart';
import 'package:just_chat/components/my_drawer.dart';
import 'package:just_chat/components/user_tile.dart';
import 'package:just_chat/pages/chat_page.dart';
import 'package:just_chat/services/auth/auth_service.dart';
import 'package:just_chat/services/chat/chat_service.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final ChatService chatService = ChatService();
  final AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Usuários"),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey,
        elevation: 0,
      ),
      drawer: MyDrawer(),
      body: Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: buildUserList(),
      ),
    );
  }

  Widget buildUserList() {
    return StreamBuilder(
      stream: chatService.getUserStream(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text("Error");
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Carregando...");
        }

        return ListView(
          children: snapshot.data!
              .map<Widget>((e) => buildUserListItem(e, context))
              .toList(),
        );
      },
    );
  }

  Widget buildUserListItem(
      Map<String, dynamic> userData, BuildContext context) {
    if (userData["email"] != authService.getCurrentUser()!.email) {
      return UserTile(
        text: userData["email"],
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatPage(
                  receiverEmail: userData["email"],
                  receiverID: userData["uid"],
                ),
              ));
        },
      );
    } else {
      return Container();
    }
  }
}
