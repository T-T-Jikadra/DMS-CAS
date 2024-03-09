// ignore_for_file: use_build_context_synchronously, no_leading_underscores_for_local_identifiers

import 'dart:io';
import 'package:app_settings/app_settings.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import '../../Citizen Related/Screens/open_response_screen.dart';
import '../../Utils/common_files/open_req.dart';

// ignore: camel_case_types
class NotificationServices {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  FirebaseMessaging messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  AndroidNotificationChannel channel = const AndroidNotificationChannel(
      //Random.secure().nextInt(100000).toString(),
      "101",
      'Max Importance',
      importance: Importance.max);

  //To check the notification permission state
  void requestNotificationPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      if (kDebugMode) {
        print("User Granted notification permission ...");
      }
      //for ios
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      if (kDebugMode) {
        print("User Granted Provisional notification permission ...");
      }
    } else {
      AppSettings.openNotificationSettings();
      if (kDebugMode) {
        print("User Denied notification permission ...");
      }
    }
  }

  void initLocalNotification(
      BuildContext context, RemoteMessage message) async {
    var androidInitialization =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    var iosInitialization = const DarwinInitializationSettings();

    var initializationSetting = InitializationSettings(
        android: androidInitialization, iOS: iosInitialization);

    // await _flutterLocalNotificationsPlugin
    //     .resolvePlatformSpecificImplementation<
    //         AndroidFlutterLocalNotificationsPlugin>()
    //     ?.createNotificationChannel(channel);

    await _flutterLocalNotificationsPlugin.initialize(initializationSetting,
        onDidReceiveNotificationResponse: (payload) async {
      if (message.data['type'] == 'response') {
        Get.to(() => const Open_Response_Screen());
      } else if (message.data['type'] == 'alert') {
        handleMessage(context, message);
      }
      // Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //       builder: (context) => const req_open(),
      //     ));
    });
  }

  void firebaseInit(BuildContext context) {
    FirebaseMessaging.onMessage.listen((message) {
      if (kDebugMode) {
        // print(message.notification!.title.toString());
        // print(message.notification!.body.toString());
        // print(message.data.toString());
        // print(message.data['title']);
        // print(message.data['address']);
        // print(message.data['pincode']);
      }
      if (Platform.isAndroid) {
        //to open a specific page (doesn't works for now)
        initLocalNotification(context, message);
        //Shows the notification
        showNotification(message);
      } else {
        //Shows the notification
        showNotification(message);
      }

      //at 12 PM

      if (message.notification != null) {
        // if (kDebugMode) {
        //   print(
        //       'Message also contained a notification: ${message.notification}');
        // }
      }
    });
  }

  Future<void> showNotification(RemoteMessage message) async {
    AndroidNotificationChannel channel = const AndroidNotificationChannel(
        //Random.secure().nextInt(100000).toString(),
        '101',
        'Max Importance',
        importance: Importance.max);

    //for android
    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      channel.id.toString(),
      channel.name.toString(),
      channelDescription: 'Your channel description',
      importance: Importance.max,
      //changes
      ticker: 'Notification ticker',
      priority: Priority.max,
      visibility: NotificationVisibility.public,
      ongoing: true,
      //playSound: true,
      enableVibration: true,
      vibrationPattern: Int64List.fromList([1000, 500, 1000]),
      //category: 'category',
      //fullScreenIntent: true,
      // actions: [
      //   const AndroidNotificationAction('V1', 'View request'),
      //   const AndroidNotificationAction(
      //     'R1',
      //     'Dismiss',
      //     cancelNotification: true,
      //   ),
      // ],
    );

    //for ios
    const DarwinNotificationDetails darwinNotificationDetails =
        DarwinNotificationDetails(
            presentAlert: true, presentBadge: true, presentSound: true);

    NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails, iOS: darwinNotificationDetails);

    Future.delayed(Duration.zero, () {
      _flutterLocalNotificationsPlugin.show(
          0,
          message.notification!.title.toString(),
          message.notification!.body.toString(),
          notificationDetails);
    });
  }

  //To get the device token
  Future<String> getDeviceToken() async {
    String? token = await messaging.getToken();
    return token!;
  }

  //To check for token is refreshed
  void isTokenRefresh() async {
    messaging.onTokenRefresh.listen((event) {
      event.toString();
      if (kDebugMode) {
        print('Token refreshed ');
      }
    });
  }

  Future<void> setupInteractMessage(BuildContext context) async {
    //when app is terminated ..
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      if (initialMessage.data['type'] == 'response') {
        Get.to(() => const Open_Response_Screen());
      } else if (initialMessage.data['type'] == 'alert') {
        handleMessage(context, initialMessage);
      }
    }

    //need to remove {opens the page as teh req sent}
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.data['type'] == 'response') {
        //Get.to(() => const alert_Screen());
      } else if (message.data['type'] == 'alert') {
        //handleMessage(context, message);
      }
    });

    //when app is in background ...
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      if (event.data['type'] == 'response') {
        Get.to(() => const Open_Response_Screen());
      } else if (event.data['type'] == 'alert') {
        handleMessage(context, event);
      }
    });

    @pragma('vm:entry-point')
    Future<void> _firebaseMessagingBackgroundHandle(
        RemoteMessage message) async {
      if (message.data['type'] == 'response') {
        Get.to(() => const Open_Response_Screen());
      } else if (message.data['type'] == 'alert') {
        Get.to(() => req_open(
              title: message.data['title'],
              add: message.data['address'],
              pin: message.data['pincode'],
              userName: message.data['username'],
              city: message.data['city'],
              rid: message.data['ReqId'],
              contactNo: message.data['phoneNumber'],
            ));
      }

      if (kDebugMode) {
        print(message.notification!.title.toString());
      }
    }
  }

  void handleMessage(BuildContext context, RemoteMessage message) {
    Get.to(() => req_open(
          title: message.data['title'],
          add: message.data['address'],
          pin: message.data['pincode'],
          userName: message.data['username'],
          city: message.data['city'],
          rid: message.data['ReqId'],
          contactNo: message.data['phoneNumber'],
        ));
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => req_open(
    //       title: message.data['title'],
    //       add: message.data['address'],
    //       pin: message.data['pincode'],
    //     ),
    //   ),
    // );
  }
}
