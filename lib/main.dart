import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elkosh/general/core/launcher.dart';
import 'package:elkosh/general/core/observer.dart';
import 'package:elkosh/general/shared/services/service_locator.dart';
import 'package:elkosh/user/search/bloc/search_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Bloc.observer = const AppBlocObserver();
  await setup();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              SearchBloc(firestore: FirebaseFirestore.instance),
        ),
        // Add other providers if needed
      ],
      child: const ElKoshApp(),
    ),
  );
}
