import 'package:scheduled_notifications/scheduled_notifications.dart';

class NotifShow {
  // getUpdate(String username) {}

  showNotification(String val) async {
    int id = await ScheduledNotifications.scheduleNotification(
        new DateTime.now()
            .add(new Duration(milliseconds: 1))
            .millisecondsSinceEpoch,
        " ",
        "Order Update!",
        val);
  }
}