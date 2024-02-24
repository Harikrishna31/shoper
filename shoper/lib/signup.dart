import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/login.dart';

class SignupPage extends StatefulWidget {
  @override
  State<SignupPage> createState() {
    return SignupPageState();
  }
}

class SignupPageState extends State<SignupPage> {
  TextEditingController usernamecontroller = TextEditingController();
  TextEditingController userEmailcontroller = TextEditingController();
  TextEditingController userPasswordcontroller = TextEditingController();
  TextEditingController userphonenumbercontroller = TextEditingController();
  User? currrentUser = FirebaseAuth.instance.currentUser;
  String username = '';
  String phoneNumber = '';
  String email = '';
  String password = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        actions: [],
      ),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height / 3.5,
            child: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(
                        'assets/g.jpg',
                      ),
                      fit: BoxFit.cover),
                  borderRadius: BorderRadius.circular(2)),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height / 5,
            left: 20.0,
            right: 20.0,
            child: Container(
              height: MediaQuery.of(context).size.height / 1.7,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(50)),
              ),
              child: Form(
                child: Column(
                  children: [
                    Text(
                      'SIGNUP',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: usernamecontroller,
                      onChanged: (Value) => setState(() {}),
                      decoration: InputDecoration(
                        errorText: usernamevalidate(usernamecontroller.text),
                        hintText: "Username",
                        prefixIcon: Icon(Icons.person),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: userphonenumbercontroller,
                      onChanged: (Value) => setState(() {}),
                      decoration: InputDecoration(
                        hintText: "phone number",
                        prefixIcon: Icon(Icons.phone),
                        errorText: phonenume(userphonenumbercontroller.text),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: userEmailcontroller,
                      onChanged: (value) => setState(() {}),
                      decoration: InputDecoration(
                        errorText: validateEmail(userEmailcontroller.text),
                        labelText: "Email",
                        prefixIcon: Icon(Icons.email),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: userPasswordcontroller,
                      obscureText: true,
                      onChanged: (value) => setState(() {}),
                      decoration: InputDecoration(
                        errorText:
                            validatepassword(userPasswordcontroller.text),
                        labelText: 'Password',
                        prefixIcon: Icon(Icons.password),
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        var username = usernamecontroller.text.trim();
                        var useremail = userEmailcontroller.text.trim();
                        var userpassword = userPasswordcontroller.text.trim();
                        var userphone = userphonenumbercontroller.text.trim();

                        try {
                          UserCredential userCredential = await FirebaseAuth
                              .instance
                              .createUserWithEmailAndPassword(
                            email: useremail,
                            password: userpassword,
                          );

                          await FirebaseFirestore.instance
                              .collection("users")
                              .doc(userCredential.user!.uid)
                              .set({
                            'username': username,
                            'userphone': userphone,
                            'useremail': useremail,
                            'createdAt': DateTime.now(),
                            'userId': userCredential.user!.uid,
                          });

                          print('User created in Firebase and Firestore');

                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => login()),
                          );
                        } catch (e) {
                          print('Error creating user: $e');
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        "SIGNUP",
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

String? validateEmail(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter an email address';
  } else if (!value.contains("@")) {
    return 'Invalid Email';
  }
  return null;
}

String? validatepassword(String? value) {
  if (value == null || value.length <= 5) {
    return "Enter the password more 6 ";
  }
  return null;
}

String? usernamevalidate(String? value) {
  if (value == null || value.isEmpty) {
    return " Please Enter Name ";
  } else {
    return null;
  }
}

String? phonenume(String? value) {
  if (value?.length == 10) {
    return null;
  } else {
    return "enter phone number  ";
  }
}
