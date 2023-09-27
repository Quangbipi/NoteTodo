import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:note_todo/model/todo.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initNotification() async {
    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('app_icon');

    var iOSInitializationSettings = DarwinInitializationSettings(
        requestSoundPermission: true,
        requestAlertPermission: true,
        requestBadgePermission: true,
        onDidReceiveLocalNotification:
            (int id, String? title, String? body, String? payload) async {});

    var initializationSettings = InitializationSettings(
        android: androidInitializationSettings, iOS: iOSInitializationSettings);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse:
            (NotificationResponse notificationResponse) async {});
  }

  _notificationDetails() async {
    return NotificationDetails(
        android: AndroidNotificationDetails(
            "channelId", "channelName",
            importance: Importance.max,
            icon: 'app_icon'
        ),
        iOS: DarwinNotificationDetails());
  }

  Future showNotification(
      {int id = 0, String? title, String? body, String? payload}) async {
    return flutterLocalNotificationsPlugin.show(
        id, title, body, await _notificationDetails());
  }

  Future scheduleNotification(
      {int id = 0,
      String? title,
      String? body,
      String? payload,
      required DateTime scheduleNotification}) async {
    return flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.from(scheduleNotification, tz.local),
        await _notificationDetails(),
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }

  Future<List<int>> scheduleMultipleNotifications(List<Todo> notifications) async {
    List<int> notificationIds = [];

    for (var i = 0; i < notifications.length; i++) {
      var notification = notifications[i];

      if (notification.time.isAfter(DateTime.now())) {
        var id = notification.id;
        var title = "Thông báo";
        var body = notification.content;
        var scheduleDateTime = notification.time;

        print("----------------------Đây là id của notifi $id---------------------------");
        await flutterLocalNotificationsPlugin.zonedSchedule(
          int.parse(id),
          title,
          body,
          tz.TZDateTime.from(scheduleDateTime, tz.local),
          await _notificationDetails(),
          uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.wallClockTime,
        );

        notificationIds.add(int.parse(id));

      } else {
        print("Thời gian này không phải là thời gian tương lai.");
      }

    }

    return notificationIds;
  }

  Future<void> cancelNotification( int index) async {
    await flutterLocalNotificationsPlugin.cancel(index);
    
  }
}
