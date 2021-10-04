import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:flutter_kickoff/models/mesage_model.dart';
import 'package:flutter_kickoff/models/user_model.dart';
import 'package:flutter_kickoff/utility/utils.dart';

class FirestoreService {
  final CollectionReference _usersCollectionReference = FirebaseFirestore.instance.collection('users');
  final CollectionReference _messagesCollectionReference = FirebaseFirestore.instance.collection('messages');
  // final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  StreamController<List<MessagesModel>> _chatMessagesController = StreamController<List<MessagesModel>>.broadcast();

  Future createUser(UserModel user) async {
    try {
      await _usersCollectionReference.doc(Utils.UID).set(user.toJson());
      await _usersCollectionReference.doc(Utils.UID).collection("chatFriends").doc("Initial").set(
          {
            "id": "Initial",
            "name": "ChattApp",
            "phoneNumber": "+911234567898",
            "imageURL": 'https://firebasestorage.googleapis.com/v0/b/super-15.appspot.com/o/default_pics%2F152-1520367_user-profile-default-image-png-clipart-png-download.png?alt=media&token=482fcf71-ca0e-4f61-98fa-1557cdbffb08'
          });
      print("User added to fireStore database");

    } catch (e) {
      // TODO: Find or create a way to repeat error handling without so much repeated code
      if (e is PlatformException) {
        return e.message;
      }

      return e.toString();
    }
  }

  Future<UserModel> getUser(String uid) async {
    print(uid);
    DocumentSnapshot userData = await _usersCollectionReference.doc(uid).get();

    UserModel user = UserModel.fromMap(userData.data() as Map<String, dynamic>);
    return user;
  }

  Future createMessage(MessagesModel message) async {
    try {
      await _messagesCollectionReference.doc().set(message.toJson());
    } catch (e) {
      // TODO: Find or create a way to repeat error handling without so much repeated code
      if (e is PlatformException) {
        return e.message;
      }

      return e.toString();
    }
  }

  Stream listenToMessagesRealTime(String friendId, String currentUserId) {
    // Register the handler for when the posts data changes
    print("listenToMessagesRealTime started");
    _requestMessages(friendId, currentUserId);
    print("listenToMessagesRealTime finished");
    return _chatMessagesController.stream;
  }

  void _requestMessages(String friendId, String currentUserId) {
    print("_requestMessage function started");
    var messagesQuerySnapshot =
    _messagesCollectionReference.orderBy('createdAt', descending: true);

    messagesQuerySnapshot.snapshots().listen((messageSnapshot) {
      if (messageSnapshot.docs.isNotEmpty) {
        var messages = messageSnapshot.docs
            .map((snapshot) => MessagesModel.fromMap(snapshot.data()))
            .where((element) =>
        (element.receiverId == friendId &&
            element.senderId == currentUserId) ||
            (element.receiverId == currentUserId &&
                element.senderId == friendId))
            .toList();

        _chatMessagesController.add(messages);
      }
    });
  }


  Future<QuerySnapshot<Object>> getUserDocumets(String number) async{
    print("getUserDocument started");
    await _usersCollectionReference.where("phoneNumber", isEqualTo: number).get();
    print("getUserDocument ended");
  }

}