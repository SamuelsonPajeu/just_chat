import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:just_chat/components/chat_bubble.dart';
import 'package:just_chat/components/my_textfield.dart';
import 'package:just_chat/services/auth/auth_service.dart';
import 'package:just_chat/services/chat/chat_service.dart';

class ChatPage extends StatefulWidget {
  final String receiverEmail;
  final String receiverID;

  const ChatPage({
    super.key,
    required this.receiverEmail,
    required this.receiverID,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController messageController = TextEditingController();

  final ChatService chatService = ChatService();
  final AuthService authService = AuthService();

  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        Future.delayed(
          const Duration(milliseconds: 800),
          () => scrollDown(),
        );
      }
    });

    Future.delayed(
      const Duration(milliseconds: 500),
      () => scrollDown(),
    );
  }

  @override
  void dispose() {
    focusNode.dispose();
    messageController.dispose();
    super.dispose();
  }

  final ScrollController scrollController = ScrollController();

  void scrollDown() {
    scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 500),
      curve: Curves.fastOutSlowIn,
    );
  }

  void sendMessage() async {
    if (messageController.text.isNotEmpty) {
      await chatService.sendMessage(widget.receiverID, messageController.text);

      messageController.clear();

      scrollDown();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text(widget.receiverEmail),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey,
        elevation: 0,
      ),
      body: Column(children: [
        Expanded(
          child: buildMessageList(),
        ),
        buildUserInput(context),
      ]),
    );
  }

  Widget buildMessageList() {
    String senderID = authService.getCurrentUser()!.uid;

    return StreamBuilder(
        stream: chatService.getMessages(widget.receiverID, senderID),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text('Erro');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView(
            controller: scrollController,
            children:
                snapshot.data!.docs.map((e) => buildMessageItem(e)).toList(),
          );
        });
  }

  Widget buildMessageItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    bool isCurrentUser = data['senderID'] == authService.getCurrentUser()!.uid;
    Alignment alignment =
        isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;

    return Container(
      alignment: alignment,
      child: Column(
        crossAxisAlignment:
            isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          ChatBubble(
            message: data["message"],
            isCurrentUser: isCurrentUser,
          ),
        ],
      ),
    );
  }

  Widget buildUserInput(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 25.0),
      child: Row(
        children: [
          Expanded(
            child: MyTextField(
              focusNode: focusNode,
              controller: messageController,
              hintText: "Digite uma mensagem",
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              shape: BoxShape.circle,
            ),
            margin: const EdgeInsets.only(right: 20.0),
            child: IconButton(
              onPressed: sendMessage,
              icon: Icon(
                Icons.send,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
