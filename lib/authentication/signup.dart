import 'package:custom_fade_animation/custom_fade_animation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_kickoff/models/user_model.dart';
import 'package:flutter_kickoff/services/firestore_services.dart';
import 'package:flutter_kickoff/utility/utils.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Signup extends StatefulWidget {
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {

  String _phone = "";
  String defaultUrl = 'https://firebasestorage.googleapis.com/v0/b/super-15.appspot.com/o/default_pics%2F152-1520367_user-profile-default-image-png-clipart-png-download.png?alt=media&token=482fcf71-ca0e-4f61-98fa-1557cdbffb08';
  final _codeController = TextEditingController();
  final _nameController = TextEditingController();

  final FirestoreService _firestoreService = FirestoreService();
  UserModel _currentUser;
  UserModel get currentUser => _currentUser;

  void onPhoneNumberChange(String number, String internationalizedPhoneNumber, String isoCode) {
    setState(() {
      _phone = internationalizedPhoneNumber;
    });
  }

  Future<bool> loginUser(String phone, BuildContext context) async {
    FirebaseAuth _auth = FirebaseAuth.instance;

    _auth.verifyPhoneNumber(
        phoneNumber: phone,
        timeout: Duration(seconds: 60),
        verificationCompleted: (AuthCredential credential) async {
          Navigator.of(context).pop();

          UserCredential result = await _auth.signInWithCredential(credential);

          User user = result.user;

          if (user != null) {
            Utils.UID = user.uid;
            Navigator.pushReplacementNamed(context, "/home");
          } else {
            print("Error");
          }

          //This callback would gets called when verification is done automatically
        },
        verificationFailed: (Exception exception) {
          print(exception);
        },
        codeSent: (String verificationId, [int forceResendingToken]) {
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
                  child: Stack(
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
                              "ENTER OTP",
                              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w700),
                            ),
                            SizedBox(height: 16.0,),
                            TextFormField(
                              decoration: InputDecoration(
                                  labelStyle: TextStyle(
                                      color: Colors.black),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      borderSide: BorderSide(color: Color(0xff24BDC9), width: 2.0)
                                  ),
                                  border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black)
                                  ),
                                  hintText: "Enter OTP",
                                labelText: "OTP"
                              ),
                              controller: _codeController,
                            ),
                            SizedBox(height: 24.0,),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  TextButton(
                                    onPressed: ()async {

                                      final code = _codeController.text.trim();
                                      AuthCredential credential =
                                      PhoneAuthProvider.credential(
                                          verificationId: verificationId, smsCode: code);

                                      UserCredential result =
                                      await _auth.signInWithCredential(credential);

                                      User user = result.user;

                                      if (user != null) {
                                        Utils.UID = user.uid;
                                        _currentUser = UserModel(
                                          id: result.user.uid,
                                          phoneNumber: _phone,
                                          name: _nameController.text,
                                          imageURL: defaultUrl,
                                        );
                                        _firestoreService.createUser(_currentUser);
                                        Navigator.of(context).pushReplacementNamed('/home');
                                      } else {
                                        print("Error");
                                      }
                                    },
                                    child: Text("Confirm"),
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
                            child: Lottie.asset('assets/lottie/otp.json'),
                          )
                      ),
                    ],
                  ),
                );
              });
        },
        codeAutoRetrievalTimeout: null
    );
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        body: SafeArea(
          bottom: false,
          child: SingleChildScrollView(
      child: Container(
          height: size.height,
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: <Widget>[
            FadeAnimation(1,Container(
                height: size.height*0.45,
                 child: Lottie.asset('assets/lottie/login.json'),
              )),
        FadeAnimation(1.4,Container(
                alignment: Alignment.center,
                child: Text(
                  "Enter Your Details",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: size.width*0.055,
                      fontWeight: FontWeight.w500),
                ),
              )),
              SizedBox(
                height: 20,
              ),
        FadeAnimation(1.7,TextFormField(
          decoration: InputDecoration(
            labelText: "Name",
            hintText: "Ex. Ram",
            labelStyle: TextStyle(
                color: Colors.black),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(color: Color(0xff24BDC9), width: 2.0)
            ),
            border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black)
            ),
          ),
          controller: _nameController,
        ),),
        SizedBox(height: size.height*0.025,),
        FadeAnimation(1.7,IntlPhoneField(
                decoration: InputDecoration(
                  labelText: "Mobile Number",
                  hintText: "Enter Mobile Number",
                  labelStyle: TextStyle(
                      color: Colors.black),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(color: Color(0xff24BDC9), width: 2.0)
                  ),
                  border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black)
                  ),
                ),
                onChanged: (phone) {
                  _phone = phone.completeNumber;
                  print(phone.completeNumber);
                },
                onCountryChanged: (phone) {
                  print('Country code changed to: ' + phone.countryCode);
                  _phone = phone.completeNumber;
                },
              )),
              SizedBox(
                height: size.height*0.08,
              ),
        FadeAnimation(1.8,Container(
                width: 180,
                child: MaterialButton(
                  child: Text("LOGIN", style: TextStyle(fontSize: 18.0),),
                  onPressed: () {
                    final phone = _phone.trim();
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
                            child: dialogContent(context, phone, _nameController.text.trim()),
                          );
                        });
                  },
                  height: 60.0,
                  elevation: 3.0,
                  textColor: Colors.white,
                  color: Colors.cyan,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)
                  ),

                ),
              )),
            ],
          ),
      ),
    ),
        ));
  }
  dialogContent(BuildContext context, String phone, String name) {
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
                "Hi, $name",
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w700),
              ),
              SizedBox(height: 16.0,),
              Text(
                  "Is $phone Correct number?\nIf not you can change it now.",
                style: TextStyle(
                    fontSize: 16.0
                ),
              ),
              SizedBox(height: 24.0,),
              Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    TextButton(
                      onPressed: (){
                        CircularProgressIndicator();
                        loginUser(phone, context);
                      },
                      child: Text("Confirm"),
                    ),
                    TextButton(
                      onPressed: (){
                        Navigator.pop(context);  dialogContent(BuildContext context, String phone, String name) {
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
                                      "Hi, $name",
                                      style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w700),
                                    ),
                                    SizedBox(height: 16.0,),
                                    Text(
                                      "Is $phone Correct number?\nIf not you can change it now.",
                                      style: TextStyle(
                                          fontSize: 16.0
                                      ),
                                    ),
                                    SizedBox(height: 24.0,),
                                    Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: <Widget>[
                                          TextButton(
                                            onPressed: (){
                                              CircularProgressIndicator();
                                              loginUser(phone, context);
                                            },
                                            child: Text("Confirm"),
                                          ),
                                          TextButton(
                                            onPressed: (){
                                              Navigator.pop(context);
                                            },
                                            child: Text("Cancle"),
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
                      },
                      child: Text("Cancle"),
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
