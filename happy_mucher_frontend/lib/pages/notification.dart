import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';

class NotificationAPI {
  static final notifications = FlutterLocalNotificationsPlugin();
  static final onNotifications = BehaviorSubject<String?>();

  static Future notificationDetails() async {
    return NotificationDetails(
        android: AndroidNotificationDetails('channel id', 'channel name',
            channelDescription: 'channel description',
            importance: Importance.max,
            icon: '@mipmap/ic_launcher'));
  }

  static Future init({bool initScheduled = false}) async {
    final android = AndroidInitializationSettings('@mipmap/ic_launcher');
    final settings = InitializationSettings(android: android);
    await notifications.initialize(settings,
        onSelectNotification: (payload) async {
      onNotifications.add(payload);
    });
  }

  static Future showNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
  }) async =>
      notifications.show(id, title, body, await notificationDetails(),
          payload: payload);
}
