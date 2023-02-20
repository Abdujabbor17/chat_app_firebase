import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'login.dart';
import 'notification.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(messageHandler);
  firebaseMessagingListener();

//  await _initializeLocalNotificationsPlugin();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'chat',
      theme: ThemeData(
        primaryColor: Colors.orange[900],
      ),
      home: Home(),
      debugShowCheckedModeBanner: false,
    );
  }
}


//
// Future<void> _initializeLocalNotificationsPlugin() async {
//   const initializationSettingsAndroid = AndroidInitializationSettings('app_icon');
//  // const initializationSettingsIOS = IOSInitializationSettings();
//   const initializationSettings = InitializationSettings(
//     android: initializationSettingsAndroid,
//     //iOS: initializationSettingsIOS,
//   );
//   await FlutterLocalNotificationsPlugin().initialize(initializationSettings);
// }