import 'package:flutter/material.dart';
import 'package:flutter_kickoff/models/mesage_model.dart';
import 'chat_Bubble.dart';

class MessagesList extends StatelessWidget {
  const MessagesList({
    Key key,
    @required this.messages,
    @required this.friendId,
  }) : super(key: key);

  final List<MessagesModel> messages;
  final String friendId;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        reverse: true,
        itemCount: messages.length,
        itemBuilder: (ctx, idx) {
          bool isSent = messages[idx].senderId != friendId;
          return ChatBubble(
            isSent: isSent,
            message: messages[idx].messageBody,
            time: messages[idx].createdAt,
          );
        },
      ),
    );
  }
}