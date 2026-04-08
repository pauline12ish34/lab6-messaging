import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'services/notification_service.dart';
import 'models/notification_model.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/notification_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  void _showPopup(RemoteMessage message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        icon: const Icon(Icons.notifications_active, color: Colors.deepPurple),
        title: Text(message.notification?.title ?? 'Notification'),
        content: Text(message.notification?.body ?? ''),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Dismiss'),
          ),
        ],
      ),
    );
  }

  String _deviceToken = 'Fetching token...';
  List<NotificationModel> _messages = [];
  late Box<NotificationModel> _notificationBox;

  @override
  void initState() {
    super.initState();
    _initHiveAndNotifications();
  }

  Future<void> _initHiveAndNotifications() async {
    _notificationBox = Hive.box<NotificationModel>('notifications');
    // Load saved notifications
    setState(() {
      _messages = _notificationBox.values.toList().reversed.toList();
    });
    await _initNotifications();
  }

  Future<void> _initNotifications() async {
    await NotificationService().init(context, (RemoteMessage message) {
      _addMessage(message);
      _showPopup(message);
    });
    String? token = await NotificationService().getToken();
    setState(() => _deviceToken = token ?? 'No token found');
    print('FCM Token: $token');

    // App launched from terminated state
    RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      _addMessage(initialMessage);
    }
  }

  void _addMessage(RemoteMessage message) {
    final notification = NotificationModel(
      title: message.notification?.title ?? 'No Title',
      body: message.notification?.body ?? 'No Body',
      time: DateTime.now().toString().substring(0, 19),
    );
    _notificationBox.add(notification);
    setState(() {
      _messages.insert(0, notification);
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FCM Push Notifications'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Token Card
            Card(
              color: Colors.deepPurple.shade50,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Device Token:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SelectableText(
                      _deviceToken,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Messages Header
            Row(
              children: [
                const Icon(Icons.inbox, color: Colors.deepPurple),
                const SizedBox(width: 8),
                const Text('Received Messages',
                    style: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
                const Spacer(),
                if (_messages.isNotEmpty)
                  TextButton(
                    onPressed: () => setState(() => _messages.clear()),
                    child: const Text('Clear'),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            // Messages List
            Expanded(
              child: _messages.isEmpty
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.notifications_none,
                              size: 64, color: Colors.grey),
                          SizedBox(height: 12),
                          Text('No notifications yet',
                              style: TextStyle(color: Colors.grey)),
                          Text('Send a message from Firebase Console',
                              style: TextStyle(
                                  color: Colors.grey, fontSize: 12)),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: _messages.length,
                      itemBuilder: (context, index) {
                        final msg = _messages[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: ListTile(
                            leading: const CircleAvatar(
                              backgroundColor: Colors.deepPurple,
                              child: Icon(Icons.notifications,
                                  color: Colors.white, size: 20),
                            ),
                            title: Text(msg.title,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(msg.body),
                                Text(msg.time,
                                    style: const TextStyle(
                                        fontSize: 11, color: Colors.grey)),
                              ],
                            ),
                            isThreeLine: true,
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}