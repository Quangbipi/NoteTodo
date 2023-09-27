import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:note_todo/app.dart';
import 'package:note_todo/bloc/bloc_observer.dart';
import 'package:note_todo/model/todo.dart';
import 'package:note_todo/service/local_todo_service.dart';
import 'package:note_todo/service/notification_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

Future<void> main() async {
  Bloc.observer = TodoObserver();
  tz.initializeTimeZones();
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService().initNotification();

  PermissionStatus notificationStatus =
  await Permission.notification.request();
  if(notificationStatus == PermissionStatus.granted){}
  if(notificationStatus == PermissionStatus.denied){}
  if(notificationStatus == PermissionStatus.permanentlyDenied){
    openAppSettings();
  }
  await Hive.initFlutter();
  Hive.registerAdapter(StatusTodoAdapter());
  Hive.registerAdapter(TodoAdapter());

  MobileAds.instance.initialize();
  runApp(const MyApp());
}



