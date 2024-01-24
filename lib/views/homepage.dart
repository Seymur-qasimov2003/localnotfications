import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var flp = FlutterLocalNotificationsPlugin();

  Future<void> kurulum() async {
    var android = AndroidInitializationSettings('@mipmap/ic_launcher');
    var ios = DarwinInitializationSettings();
    var init = InitializationSettings(android: android, iOS: ios);
    await flp.initialize(init, onDidReceiveNotificationResponse: bildirimSecme);
  }

  Future<void> bildirimSecme(NotificationResponse notificationResponse) async {
    var payload = notificationResponse.payload;
    if (payload != null) {
      print('Payload: $payload');
    } else {
      print('Payload: null');
    }
  }

  @override
  void initState() {
    kurulum();
    // TODO: implement initState
    super.initState();
  }

  Future<void> bildirimGoster() async {
    var android = AndroidNotificationDetails(
      'channelId',
      'channelName',
      channelDescription: 'channelDescription',
      importance: Importance.max,
      priority: Priority.high,
    );
    var ios = DarwinNotificationDetails();
    var bildirimDetay = NotificationDetails(android: android, iOS: ios);
    await flp.show(0, 'Başlık', 'İçerik', bildirimDetay,
        payload: 'payload gonderildi');
  }

  Future<void> bildirimGosterGecikmeli() async {
    var android = AndroidNotificationDetails(
      'channelId',
      'channelName',
      channelDescription: 'channelDescription',
      importance: Importance.max,
      priority: Priority.high,
    );
    var ios = DarwinNotificationDetails();
    var bildirimDetay = NotificationDetails(android: android, iOS: ios);
    tz.initializeTimeZones();
    var gecikme = tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5));
    await flp.zonedSchedule(
      0,
      'Başlık gecikmeli',
      'İçerik gecikmeli',
      gecikme,
      bildirimDetay,
      payload: 'payload gonderildi gecikmeli',
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Demo Home Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                bildirimGoster();
              },
              child: Text('Local Notification'),
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                bildirimGosterGecikmeli();
              },
              child: Text('Local Notification2'),
            ),
          ],
        ),
      ),
    );
  }
}
