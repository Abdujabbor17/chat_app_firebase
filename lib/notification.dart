


import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'notif_message.dart';

Future<void> messageHandler(RemoteMessage message) async {
  Data notificationMessage = Data.fromJson(message.data);
  print('notification from background : ${notificationMessage.title}');

}

Future<void> _backgroundMessageHandler(RemoteMessage message) async {
  const androidPlatformChannelSpecifics = AndroidNotificationDetails(
    'channel_id',
    'channel_name',
    // 'channel_description',
    importance: Importance.high,
    priority: Priority.high,
    ticker: 'ticker',
    sound: RawResourceAndroidNotificationSound('notification'),
  );
 // const iOSPlatformChannelSpecifics = IOSNotificationDetails();
  const platformChannelSpecifics = NotificationDetails(
    android: androidPlatformChannelSpecifics,
  );
  await FlutterLocalNotificationsPlugin().show(
    0,
    message.notification?.title ?? '',
    message.notification?.body ?? '',
    platformChannelSpecifics,
    payload: message.data.toString(),
  );
}



void firebaseMessagingListener() {
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    Data notificationMessage = Data.fromJson(message.data);
    print('notification from foreground : ${notificationMessage.title}');

  });
}


Future<void> sendNotification() async {
  const postUrl = 'https://fcm.googleapis.com/fcm/send';
  Dio dio = Dio();

  var token = await getDeviceToken();
  print('device token : $token');


  final data = {

    "data": {
      "message": "Accept Ride Request",
      "title": "This is Ride Request"
    },
    "to": 'fapMmQbJSSOFZ21u5m4QxB:APA91bEBJvTylbUjltx-jbgZEidc1TygKx_oFf5g506vRvrJHnBxex7ePodEl0FM870SMfoK0FtB0esRX0VMbvPW88iRMm0z-E1Qk8MVSyvrv3cI6AMtiAF2DDESbTi7Y3dRwaxOraSw'
  };

  dio.options.headers['Content-Type'] = 'application/json';
  dio.options.headers["Authorization"] = 'key=AAAAHg33cDk:APA91bH7VjhakZI3GzxLcaoshKyWKUsmrp1yEwXuJ0fBH9XJs_AFzuaIL7KvYG2TgUHh446FS18d_cF9XOfgurdOSORZXyqr8n6FSb9nktG7PADMAQPqlcitkcyYmhWBod0iZIsiMbfH';



  try {
    final response = await dio.post(postUrl, data: data);

    if (response.statusCode == 200) {
      print('Request Sent To Driver');
    } else {
      print('notification sending failed');
    }
  } catch (e) {
    print('exception $e');
  }
}

Future<String?> getDeviceToken()  async{
  return await FirebaseMessaging.instance.getToken();
}

Future<void> _createNotificationChannel() async {
  const channel = AndroidNotificationChannel(
    'channel_id',
    'channel_name',
    importance: Importance.high,
    sound: RawResourceAndroidNotificationSound('notification'),
  );
  await FlutterLocalNotificationsPlugin().resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(channel);
}