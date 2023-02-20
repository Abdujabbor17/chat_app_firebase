

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:test_chat/notification.dart';

import 'login.dart';
import 'message.dart';

class ChatPage extends StatefulWidget {
  String email;
  ChatPage({super.key, required this.email});
  @override
  _ChatPageState createState() => _ChatPageState(email: email);
}

class _ChatPageState extends State<ChatPage> {
  String email;
  _ChatPageState({required this.email});

  final fs = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  final TextEditingController message =  TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'data',
        ),
        actions: [
          MaterialButton(
            onPressed: () {
              _auth.signOut().whenComplete(() {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Home(),
                  ),
                );
              });
            },
            child: const Text(
              "signOut",
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.79,
              child: Messages(
                email: email,
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: message,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.purple[100],
                      hintText: 'message',
                      enabled: true,
                      contentPadding: const EdgeInsets.only(
                          left: 14.0, bottom: 8.0, top: 8.0),
                      focusedBorder: OutlineInputBorder(
                        borderSide:  const BorderSide(color: Colors.purple),
                        borderRadius:  BorderRadius.circular(10),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide:  const BorderSide(color: Colors.purple),
                        borderRadius:  BorderRadius.circular(10),
                      ),
                    ),
                    validator: (value) {},
                    onSaved: (value) {
                      message.text = value!;
                    },
                  ),
                ),
                IconButton(
                  onPressed: () {
                    if (message.text.isNotEmpty) {
                      fs.collection('Messages').doc().set({
                        'message': message.text.trim(),
                        'time': DateTime.now(),
                        'email': email,
                      });

                      message.clear();
                    }
                  },
                  icon: const Icon(Icons.send_sharp),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Future<bool> requestSmsPermission(Permission per) async {
  var status = await per.status;
  if (status.isGranted) {
    return true;
  } else {
    await per.request();
  }
  return false;
}

// Future<void> userTokens() async{
//   final  result = FirebaseFirestore.instance
//       .collection('Users')
//       .snapshots();
//
// print('===============================================${result.');
//
//
// }

Future<String?> getUser() async {
    try {
      CollectionReference users =
      FirebaseFirestore.instance.collection('Users');
      final snapshot = await users.doc('jabborpro@gmail.com').get();

      print(snapshot.toString());
      final data = snapshot.data() as Map<String, dynamic>;
      print(data);
      return data['token'];
    } catch (e) {
      return 'Error fetching user';
    }
  }

