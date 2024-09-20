import 'package:elkosh/core/launcher.dart';
import 'package:elkosh/core/observer.dart';
import 'package:elkosh/shared/services/service_locator.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Bloc.observer = const AppBlocObserver();
  await setup();
  runApp(const ElKoshApp());
}
