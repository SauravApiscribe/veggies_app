// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:get/get.dart';
// import 'package:veggies_mobile/order/previous_orders.dart';
// import 'package:veggies_mobile/veggies_basket/my_deliveries.dart';
//
// class PushNotificationsManager {
//   PushNotificationsManager._();
//
//   factory PushNotificationsManager() => _instance;
//
//   static final PushNotificationsManager _instance =
//       PushNotificationsManager._();
//
//   final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
//   bool _initialized = false;
//   String _token = '';
//
//   void navigateBasedOnNotification(Map<String, dynamic> message) {
//     if (message['data']['screen'] == 'ORDER') {
//       Get.to(PreviousOrders());
//     } else if (message['data']['screen'] == 'DELIVERY') {
//       Get.to(MyDeliveries());
//     }
//   }
//
//   String get fcmToken {
//     print('Token is $_token');
//     return _token;
//   }
//
//   Future<void> init() async {
//     if (!_initialized) {
//       print('initializing');
//       // For iOS request permission first.
//       _firebaseMessaging.requestNotificationPermissions();
//
//       // For testing purposes print the Firebase Messaging token
//       String token = await _firebaseMessaging.getToken();
//       print("FirebaseMessaging token: $token");
//       _token = token;
//
//       _firebaseMessaging.configure(
//         onMessage: (Map<String, dynamic> message) async {
//           print("onMessage: $message");
//         },
//         onLaunch: (Map<String, dynamic> message) async {
//           print("onLaunch: $message");
//           navigateBasedOnNotification(message);
//         },
//         onResume: (Map<String, dynamic> message) async {
//           print("onResume: $message");
//           navigateBasedOnNotification(message);
//         },
//       );
//
//       _initialized = true;
//     }
//   }
// }
