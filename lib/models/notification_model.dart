import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'notification_model.g.dart';

@HiveType(typeId: 0)
class NotificationModel extends HiveObject {
  @HiveField(0)
  String title;

  @HiveField(1)
  String body;

  @HiveField(2)
  String time;

  NotificationModel({required this.title, required this.body, required this.time});
}
