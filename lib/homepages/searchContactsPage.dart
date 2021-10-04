import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter_kickoff/services/firestore_services.dart';
import 'package:permission_handler/permission_handler.dart';

class SearchContactPage extends StatefulWidget {

  @override
  _SearchContactPageState createState() => _SearchContactPageState();
}

class _SearchContactPageState extends State<SearchContactPage> {
  List<Contact> contacts = [];
  final FirestoreService _firestoreService = FirestoreService();

  getAllContacts()async{
    var contactStatus = await Permission.contacts.status;
    if(!contactStatus.isGranted){
      await Permission.contacts.request();
      setState(() {});
    }
    if(contactStatus.isGranted){
      List<Contact> _contacts = (await ContactsService.getContacts(withThumbnails: false)).toList();
      setState(() {
        contacts = _contacts;
        print(_contacts.length);
      });
    }

  }
  @override
  void initState() {
    super.initState();
    setState(() {
      getAllContacts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black,),
          onPressed: (){
            Navigator.of(context).pop();
          },
        ),
        title: Text("Add Friends From your Contacts"),
      ),
      body:(contacts != null && contacts.length > 0)?
        ListView.builder(
          // padding: EdgeInsets.symmetric(horizontal: 10.0),
          itemCount: contacts.length,
          itemBuilder: (context, index){
            return ListTile(
              title: Text(contacts[index].displayName),
              leading: CircleAvatar(
                backgroundColor: Colors.cyan,
                child: Text(contacts[index].displayName[0], style: TextStyle(color: Colors.black),),
              ),
              subtitle: contacts[index].phones.isEmpty ? null :Text(contacts[index].phones.elementAt(0).value),
              onTap: ()async{
                String number = contacts[index].phones.elementAt(0).value.replaceAll(new RegExp(r"\s+"), "");
                print(number);
                var document;
                await _firestoreService.getUserDocumets(number).then((QuerySnapshot doc){
                  if(doc.docs.isNotEmpty){
                    print("user found");
                    document = doc.docs[0].data();
                  }
                  else {
                    print("user not found");
                  }
                  });
                  print(document['name']);
              },
            );
          }
      )
          :
          Center(
            child: Text("No Contacts Available"),
          ),
    );
  }
}
