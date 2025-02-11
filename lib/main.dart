import 'package:device_preview/device_preview.dart';
import 'package:elkosh/core/observer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/launcher.dart';
import 'firebase_options.dart';
import 'shared/services/service_locator.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await Supabase.initialize(
    url: 'https://pzhkkvmwddwtzztdpzkr.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InB6aGtrdm13ZGR3dHp6dGRwemtyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mzg2MDcwODIsImV4cCI6MjA1NDE4MzA4Mn0.hOzF33nhSx1DYEvYQWHQ3Kf3nHPNJ0OJooHPWZIyTXs',
  );
  Bloc.observer = const AppBlocObserver();
  await setup();

  runApp(DevicePreview(builder: (BuildContext context) => const ElKoshApp()));
}
