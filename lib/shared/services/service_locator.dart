import 'package:auth_repository/auth_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_repository/data_repository.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
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
  sl.registerSingleton<AuthRepository>(AuthRepository(
    firebaseAuth: FirebaseAuth.instance,
    firestore: sl.get<FirebaseFirestore>(),
    sharedPreferences: sl.get<SharedPreferences>(),
    dio: Dio(),
  ));
  sl.registerSingleton<UserRepository>(UserRepository(
    firestore: sl.get<FirebaseFirestore>(),
    storage: sl.get<FirebaseStorage>(),
    sharedPreferences: sl.get<SharedPreferences>(),
  ));
  sl.registerSingleton<DataRepository>(DataRepository(
    firestore: sl.get<FirebaseFirestore>(),
    fireStorage: sl.get<FirebaseStorage>(),
    sharedPref: sl.get<SharedPreferences>(),
  ));

  Hive.registerAdapter(MarketAdapter());
  Hive.registerAdapter(CategoryAdapter());
  Hive.registerAdapter(ProductAdapter());
  Hive.registerAdapter(UserOrderAdapter());
  Hive.registerAdapter(OrderStatusAdapter());
  Hive.registerAdapter(LocationAdapter());
  Hive.registerAdapter(OfferAdapter());
  Hive.registerAdapter(AdAdapter());
  await Hive.openBox<Category>('categoriesBox');
  await Hive.openBox<Market>('marketsBox');
  await Hive.openBox<Product>('productsBox');
  await Hive.openBox<Map>('cartBox');
  await Hive.openBox<UserOrder>('ordersBox');
  await Hive.openBox<Ad>('adsBox');
}
