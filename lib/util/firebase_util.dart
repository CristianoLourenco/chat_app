import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class FirebaseUtil {
  static Future<void> askPermitionToNotify() async {
    await FirebaseMessaging.instance.setAutoInitEnabled(true);

    final settings = await FirebaseMessaging.instance.requestPermission(
      provisional: true,
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional) {
      final token = await FirebaseMessaging.instance.getToken();

      debugPrint("token: \n\n ===============================");
      debugPrint("token: $token");
      debugPrint("token: \n\n ===============================");
    } else {
      debugPrint('❌ Permissão de notificação negada.');
    }
  }

  @pragma('vm:entry-point')
  static Future<void> firebaseMessagingBackgroundHandler(
    RemoteMessage message,
  ) async {
    // If you're going to use other Firebase services in the background, such as Firestore,
    // make sure you call `initializeApp` before using other Firebase services.
    showNotification(message);
  }

  static final localNotifyPlugin = FlutterLocalNotificationsPlugin();

  static void showNotification(RemoteMessage sms) async {
    debugPrint(
      "\n\n================ \n sms sended \n\n======================\n",
    );
    final notification = sms.notification;
    if (notification == null) return;

    const androiddDetails = AndroidNotificationDetails(
      'default_id',
      'Notificações padrão',
      importance: Importance.max,
      priority: Priority.high,
    );

    const details = NotificationDetails(android: androiddDetails);
    localNotifyPlugin.show(
      notification.hashCode,
      notification.title,
      notification.body,
      details,
    );
  }
}
