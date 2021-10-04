import 'package:basic_utils/basic_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker/emoji_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_kickoff/models/mesage_model.dart';
import 'package:flutter_kickoff/services/firestore_services.dart';
import 'package:flutter_kickoff/utility/utils.dart';
import 'package:flutter_kickoff/widgets/message_list.dart';
import 'package:lottie/lottie.dart';

class ChatScreen extends StatefulWidget {
  DocumentSnapshot<Object> document;
  String senderName;
  ChatScreen({Key key, @required this.document, @required this.senderName}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  List<MessagesModel> _messages = [];

  bool setBusy = false;

  final FirestoreService _firestoreService = FirestoreService();

  bool _shoeEmojiPicker = false;

  final TextEditingController _messageBodyController = TextEditingController();
  final FocusNode _messageFocus = FocusNode();

  void toggleEmojiPicker(){
    setState(() {
      _shoeEmojiPicker = ! _shoeEmojiPicker;
      print(_shoeEmojiPicker);
    });
  }

  void listenToMessages(String friendId) {
    _firestoreService
        .listenToMessagesRealTime(friendId, Utils.UID)
        .listen((messagesData) {
      List<MessagesModel> updatedMessages = messagesData;
      if (updatedMessages != null && updatedMessages.length > 0) {
        setState(() {
          _messages = updatedMessages;
          print("_messages updated");
          print(_messages.length);
        });

      }
    });
  }

  Future sendMessage(
      String messageBody, String receiverId, String receiverName) async {
    final MessagesModel message = MessagesModel(
      messageBody: messageBody,
      receiverId: receiverId,
      senderId: Utils.UID,
      senderName: widget.senderName,
      receiverName: receiverName,
      createdAt: DateTime.now().millisecondsSinceEpoch,
    );
    return await _firestoreService.createMessage(message);
  }

  @override
  void initState() {
    super.initState();
    print("listenToMessages started");
    listenToMessages(widget.document.id);
    print("listenToMessages finished");
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    Widget buildChatMessages(friendId, name) {
        if (_messages.length == 0) {
          return Container(
            margin: EdgeInsets.all(20.0),
            height: size.height*0.4,
            child: Card(
                child: Column(
                  children: [
                    Container(
                        height: size.height*0.3,
                        child: Lottie.asset('assets/lottie/hello.json')
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 20),
                      alignment: Alignment.center,
                      height: 23.0,
                      child: Text("Say Hello to '$name' to start a Chat!", style: TextStyle(fontSize: size.width*0.05, fontWeight: FontWeight.w600),),
                    ),
                  ],
                )
            ),
          );
        }
        else{
          return MessagesList(messages: _messages, friendId: friendId);
        }
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.document['name']),
        leading: InkWell(
          onTap: (){
            Navigator.of(context).pop();
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Icon(Icons.arrow_back, color: Colors.black, size: 20,),
              SizedBox(width: 4.0,),
              CircleAvatar(
                radius: 16,
                backgroundImage: NetworkImage(widget.document['imageURL']),
              )
            ],
          ),
        ),
        actions:  [
          IconButton(
            icon: const Icon(CupertinoIcons.video_camera_solid, color: Colors.black87,size: 30.0,),
            tooltip: 'Settings',
            onPressed: () {
              // handle the press
            },
          ),
          IconButton(
            icon: const Icon(CupertinoIcons.phone_fill, color: Colors.black,size: 30.0),
            tooltip: 'Settings',
            onPressed: () {
              // handle the press
            },
          ),
          IconButton(
            icon: const Icon(CupertinoIcons.ellipsis, color: Colors.black,size: 30.0),
            tooltip: 'Settings',
            onPressed: () {
              // handle the press
            },
          ),
        ],
      ),
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            buildChatMessages(widget.document.id, widget.document['name']),
      SizedBox(height: 20),
      Container(
        height: size.height*0.06,
        color: Colors.cyanAccent,
        child: Row(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.tag_faces),
              onPressed: () {
                _messageFocus.unfocus();
                toggleEmojiPicker();
              },
            ),
            IconButton(
              icon: Icon(Icons.attach_file),
              onPressed: () {

              },
            ),
            Expanded(
              child: TextField(
                focusNode: _messageFocus,
                onTap: () {
                  if (_shoeEmojiPicker == true) {
                    toggleEmojiPicker();
                  }
                },
                controller: _messageBodyController,
                maxLines: null,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Send Message..',
                ),
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.send,
                color: Colors.black,
              ),
              onPressed: () {
                if (_messageBodyController.text.isEmpty) {
                  return;
                }
                sendMessage(_messageBodyController.text, widget.document.id, widget.document['name']);
                _messageBodyController.clear();
              },
            ),
            _shoeEmojiPicker
                ? EmojiPicker(
              rows: 10,
              columns: 3,
              selectedCategory: Category.SMILEYS,
              buttonMode: ButtonMode.MATERIAL,
              onEmojiSelected: (item, category) {
                _messageBodyController.text = StringUtils.addCharAtPosition(
                        _messageBodyController.text,
                        item.emoji,
                        _messageBodyController.text.length);
              },
            )
                : Container()
          ],
        ),
      ),
      ]
    ),
    );
  }
}
