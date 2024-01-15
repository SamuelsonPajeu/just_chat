import 'package:flutter/material.dart';
import 'package:just_chat/themes/theme_provider.dart';
import 'package:provider/provider.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isCurrentUser;

  const ChatBubble({
    super.key,
    required this.message,
    required this.isCurrentUser,
  });

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    bool isDarkMode =
        Provider.of<ThemeProvider>(context, listen: false).isDarkMode;

    return Container(
      decoration: BoxDecoration(
          color: isCurrentUser ? colorScheme.primary : colorScheme.tertiary,
          borderRadius: BorderRadius.circular(12.0)),
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 25),
      child: Text(
        message,
        style: TextStyle(
          color: isCurrentUser
              ? isDarkMode
                  ? colorScheme.inversePrimary
                  : colorScheme.secondary
              : colorScheme.inversePrimary,
        ),
      ),
    );
  }
}
