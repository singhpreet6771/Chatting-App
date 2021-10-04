import 'package:flutter/material.dart';
import 'package:bubble/bubble.dart';

class ChatBubble extends StatelessWidget {
  const ChatBubble({
    Key key,
    @required this.isSent,
    @required this.message,
    @required this.time,
  }) : super(key: key);

  final bool isSent;
  final String message;
  final int time;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.cyanAccent,
      highlightColor: Colors.cyan,
      onLongPress: (){
        print("message long pressed");
      },
      child: Bubble(
        margin: isSent
            ? BubbleEdges.only(top: 10, right: 20)
            : BubbleEdges.only(top: 10, left: 20),
        padding: BubbleEdges.all(15),
        elevation: 3,
        nipRadius: 5,
        nipWidth: 30,
        nipHeight: 10,
        alignment: isSent ? Alignment.topRight : Alignment.topLeft,
        nip: isSent ? BubbleNip.rightBottom : BubbleNip.leftTop,
        color: isSent ? Colors.cyanAccent : Colors.cyan,
        child: Text(
          message,
          style: TextStyle(color: Colors.black),
        )
      ),
    );
  }
}