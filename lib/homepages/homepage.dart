import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_kickoff/models/user_model.dart';
import 'package:flutter_kickoff/services/firestore_services.dart';
import 'package:flutter_kickoff/utility/utils.dart';
import 'package:flutter_kickoff/widgets/shimmer_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'chat_screen.dart';

class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {


  final FirestoreService _firestoreService = FirestoreService();

  CollectionReference  _usersCollectionReference = FirebaseFirestore.instance.collection('users').doc(Utils.UID).collection("chatFriends");

  uploadImageToFirebaseStorage(String path) async{

    File file = File(path);
    FirebaseStorage storageReference = FirebaseStorage.instance;
    Reference profilePicsReference = storageReference.ref().child("profile-pics/");
    UploadTask uploadTask = profilePicsReference.child("profile_pic_${Utils.UID}.jpg").putFile(file);
    String profileImageURL = await (await uploadTask).ref.getDownloadURL(); // Get the URL of the Uploaded Image :)
    FirebaseFirestore db = FirebaseFirestore.instance;
    db.collection("users").doc(Utils.UID).update({"imageURL": profileImageURL}).then((value){
      print("Image Uploaded and URL Saved :)");
      print(profileImageURL);
      _firestoreService.getUser(Utils.UID).then((UserModel value){
        setState(() {
          user = value; // refresh i.e. re execute the build function to update UI
        });
      });
    });
  }

  UserModel user = UserModel();
  @override
  void initState() {
    super.initState();
    _firestoreService.getUser(Utils.UID).then((UserModel value){
      setState(() {
        user = value; // refresh i.e. re execute the build function to update UI
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return (user.imageURL == null) ? Scaffold(
        appBar: AppBar(
          title: Text("ChattingApp", style: TextStyle(fontSize: size.width*0.05),),
          actions: [
              IconButton(
                icon: const Icon(Icons.search, color: Colors.black,size: 30.0),
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
        drawer: Drawer(),
        body: ListView.builder(
          itemCount: 12,
            itemBuilder: (context, index){
            return buildAppShimmer();
            }
        ),
    ) : Scaffold(
      drawer: Drawer(
        child: SafeArea(
          bottom: false,
          child: Stack(
            children: [
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.only(top: 20.0),
                child: Column(
                  children: <Widget>[
                    CircleAvatar(
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 65,
                        backgroundImage: NetworkImage(user.imageURL),
                      ),
                      radius: 66.5,
                      backgroundColor: Colors.black,
                    ),
                    SizedBox(height: 15.0,),
                    Container(
                      child: Text(user.name, style: TextStyle(fontSize: size.width*0.05),),
                    ),
                    SizedBox(height: 5.0,),
                    Container(
                      child: Text(user.phoneNumber, style: TextStyle(fontSize: size.width*0.037),),
                    ),
                    SizedBox(height: 5.0,),
                    Divider(thickness: 2.5,),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0.0),
                      child: Column(
                        children: [
                          ListTile(
                            title: Text("Settings", style: TextStyle(fontSize: size.width*0.04),),
                            onTap: ()async{
                              print("taping setting listTile");
                              PickedFile pickedFile = await ImagePicker.platform.pickImage(source: ImageSource.gallery);
                              uploadImageToFirebaseStorage(pickedFile.path); // give the path of the picked image :)
                            },
                            subtitle: Text("Change your settings here", style: TextStyle(fontSize: size.width*0.03),),
                            leading: Icon(Icons.settings, color: Colors.black,size: 35.0,),
                            trailing: Icon(CupertinoIcons.right_chevron, color: Colors.black,),
                          ),
                          Divider(thickness: 1.5,),
                          ListTile(
                            title: Text("T&C", style: TextStyle(fontSize: size.width*0.04),),
                            onTap: (){
                              print(user.imageURL);
                              print("taping t&c listTile");
                            },
                            subtitle: Text("Read Terms and Conditions", style: TextStyle(fontSize: size.width*0.03),),
                            leading: Icon(CupertinoIcons.book, color: Colors.black,size: 40.0,),
                            trailing: Icon(CupertinoIcons.right_chevron, color: Colors.black,),
                          ),
                          Divider(thickness: 1.5,),
                          ListTile(
                            title: Text("Help & Assist", style: TextStyle(fontSize: size.width*0.04),),
                            onTap: (){
                              print("taping Help & Assist listTile");
                            },
                            subtitle: Text("FAQ's about the App and Usage", style: TextStyle(fontSize: size.width*0.03),),
                            leading: Icon(Icons.volunteer_activism, color: Colors.black,size: 35.0,),
                            trailing: Icon(CupertinoIcons.right_chevron, color: Colors.black,),
                          ),
                          Divider(thickness: 1.5,),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 0.0,
                left: 0.0,
                right: 0.0,
                child: ListTile(
                  tileColor: Colors.red,
                  title: Text("Log Out", style: TextStyle(fontSize: size.width*0.04),),
                  onTap: (){
                    showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) {
                          return Dialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 0,
                            backgroundColor: Colors.transparent,
                            child: dialogContent(context),
                          );
                        });
                  },
                  subtitle: Text("Click here to logout", style: TextStyle(fontSize: size.width*0.03),),
                  leading: Icon(Icons.logout, color: Colors.black,size: 35.0,),
                ),
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        title: Text("ChattingApp", style: TextStyle(fontSize: size.width*0.05),),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: "Add Friends",
        child: Center(
          child: Icon(CupertinoIcons.add, color: Colors.black, size: 40.0,),
        ),
        onPressed: (){
          Navigator.pushNamed(context, "/searchContactPage");
        },
        elevation: 5,
        splashColor: Colors.cyanAccent,
      ),
      body: Container(
        child: StreamBuilder<QuerySnapshot>(
          stream: _usersCollectionReference.snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text("${snapshot.error}"),
                );
              }
              return snapshot.hasData ?  Stack(
                children: <Widget>[
            ListView(
            children: snapshot.data.docs.map((DocumentSnapshot document) {
              print("length is : ${snapshot.data.docs.length}");
              if(snapshot.data.docs.length == 0){
                return Center(
                  child: Text("No One Added yet in your chat list"),
                );
              }
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 26.0,
                    backgroundColor: Colors.black,
                    child: CircleAvatar(
                      radius: 25.0,
                      backgroundImage: NetworkImage(document['imageURL']),
                    ),
                  ),
                  trailing: IconButton(
                    icon: Icon(
                      Icons.arrow_forward_ios,
                      size: 15,
                    ),
                    onPressed: (){},
                  ),
                  title: Text('${document['name']}', style: TextStyle(fontSize: size.width*0.043)),
                  subtitle: Text('${document['phoneNumber']}', style: TextStyle(fontSize: size.width*0.034)),
                  onTap: () {
                    MaterialPageRoute route = MaterialPageRoute(builder: (context) => ChatScreen(document: document, senderName: user.name,),);
                    Navigator.push(context, route);
                  },
                ),
              );
            }).toList(),
            )
                ],
              )
                  :
              ListView.builder(
                  itemCount: 12,
                  itemBuilder: (context, index){
                    return buildAppShimmer();
                  }
              );
          },
        ),
      ),
    );
  }

  Widget buildAppShimmer() => ListTile(
    leading: ShimmerWidget.circular(height: 65, width: 65,),
    title: Align(
      alignment: Alignment.centerLeft,
      child: ShimmerWidget.rectangular(
        width: MediaQuery.of(context).size.width*0.3,
        height: 15,
      ),
    ),
    subtitle: ShimmerWidget.rectangular(height: 13),
    trailing: ShimmerWidget.icon(height: 25, width: 25),
  );

  dialogContent(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(
              top: 120,
              bottom: 16,
              left: 16,
              right: 16
          ),
          margin: EdgeInsets.only(top: 16),
          decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(17),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10.0,
                  offset: Offset(0.0, 10.0),
                )
              ]
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                "Are You Sure You Want to Log Out?",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 16.0,),
              SizedBox(height: 24.0,),
              Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    TextButton(
                      onPressed: (){
                        FirebaseAuth.instance.signOut();
                        Navigator.pushReplacementNamed(context, "/");
                      },
                      child: Text("YES"),
                    ),
                    TextButton(
                      onPressed: (){
                        Navigator.pop(context);
                      },
                      child: Text("NO"),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        Positioned(
            top: 0,
            left: 16,
            right: 16,
            child: Container(
              height: 100,
              margin: EdgeInsets.symmetric(horizontal: 100.0),
              decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle
              ),
              child: Lottie.asset('assets/lottie/alert.json', fit: BoxFit.cover),
            )
        ),
      ],
    );
  }

}
