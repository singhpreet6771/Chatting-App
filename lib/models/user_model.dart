import 'package:flutter/material.dart';

class UserModel {
  String id;
  String name;
  String phoneNumber;
  String imageURL;

  UserModel({this.id, this.name, this.phoneNumber, this.imageURL});

  UserModel.init({ @required this.id, @required this.name, @required this.phoneNumber, @required this.imageURL});

  UserModel.fromData(Map<String, dynamic> data)
      : id = data['id'],
        name = data['name'],
        phoneNumber = data['phoneNumber'],
        imageURL = data['imageURL'];

  factory UserModel.fromMap(Map<String, dynamic> document){
    return UserModel(name: document['name'], phoneNumber: document['phoneNumber'], id: document['id'], imageURL : document['imageURL']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phoneNumber': phoneNumber,
      'imageURL': imageURL,
    };
  }
}