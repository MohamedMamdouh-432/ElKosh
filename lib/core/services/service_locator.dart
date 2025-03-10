import 'package:auth_repository/auth_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_repository/data_repository.dart';
import 'package:dio/dio.dart';
import 'package:elkosh/core/services/observer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:models_repository/models_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:user_repository/user_repository.dart';

final GetIt sl = GetIt.instance;

Future<void> setup() async {
  //* Single Dependencies
  sl.registerSingleton<FirebaseFirestore>(FirebaseFirestore.instance);
  sl.registerSingleton<FirebaseStorage>(FirebaseStorage.instance);
  sl.registerSingleton<SharedPreferences>(
      await SharedPreferences.getInstance());

  //* Repositories Dependencies
  sl.registerSingleton<AuthRepo>(AuthRepo(
    firebaseAuth: FirebaseAuth.instance,
    firestore: sl.get<FirebaseFirestore>(),
    sharedPreferences: sl.get<SharedPreferences>(),
    dio: Dio(),
  ));
  sl.registerSingleton<UserRepo>(UserRepo(
    firestore: sl.get<FirebaseFirestore>(),
    storage: sl.get<FirebaseStorage>(),
    sharedPreferences: sl.get<SharedPreferences>(),
  ));
  sl.registerSingleton<DataRepo>(DataRepo(
    firestore: sl.get<FirebaseFirestore>(),
    fireStorage: sl.get<FirebaseStorage>(),
    sharedPref: sl.get<SharedPreferences>(),
  ));

  //* Hive Adapters
  Hive.registerAdapter(OrderStatusAdapter());
  Hive.registerAdapter(AdAdapter());
  Hive.registerAdapter(CategoryAdapter());
  Hive.registerAdapter(MarketAdapter());
  Hive.registerAdapter(UserOrderAdapter());
  Hive.registerAdapter(ProductAdapter());
  Hive.registerAdapter(DayTimeAdapter());
  Hive.registerAdapter(LocationAdapter());
  Hive.registerAdapter(OfferAdapter());

  //* Hive Boxes
  await Hive.openBox<Ad>('adsBox');
  await Hive.openBox<Category>('categoriesBox');
  await Hive.openBox<Market>('marketsBox');
  await Hive.openBox<UserOrder>('ordersBox');
  await Hive.openBox<Product>('productsBox');
  await Hive.openBox<Map>('cartBox');

  //* Firebase Cache Settings
  sl.get<FirebaseFirestore>().settings = const Settings(
    persistenceEnabled: true,
    cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
  );

  //* BLoC Observer
  Bloc.observer = const AppObserver();
}
