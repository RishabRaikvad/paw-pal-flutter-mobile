import 'package:flutter/material.dart';
import 'package:paw_pal_mobile/app.dart';
import 'package:paw_pal_mobile/services/notification_service.dart';

Future<void> main() async {
  Widget app = await initializeApp();
  runApp(app);
  NotificationService().setUpInteractedMessage();
}


