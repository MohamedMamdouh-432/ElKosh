import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:either_dart/either.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:models_repository/models_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminRepository {
  final FirebaseFirestore firestore;
  final FirebaseStorage fireStorage;
  final SharedPreferences sharedPref;
  Market? _selctedMarket;
  Product? _selectedProduct;

  AdminRepository({
    required this.firestore,
    required this.fireStorage,
    required this.sharedPref,
  });

  String getUserId() => sharedPref.getString('userId')!;
  Market? getCurMarket() => _selctedMarket;
  Product? getCurProduct() => _selectedProduct;
  void setCurMarket(Market market) => _selctedMarket = market;
  void setCurProduct(Product product) => _selectedProduct = product;

  Future<String> uploadImage(File image, String docId) async {
    try {
      final fileRef =
          await fireStorage.ref("markets/img-$docId").putFile(image);
      final url = await fileRef.ref.getDownloadURL();
      return url;
    } catch (e) {
      throw Exception('حدث خطأ أثناء تحميل الصورة');
    }
  }

  Future<Either<Failure, void>> addMarket({
    required String name,
    required String hotline,
    required String desc,
    required File imageFile,
    required Location location,
    required TimeOfDay beginTime,
    required TimeOfDay endTime,
  }) async {
    try {
      final sameMarkets = await firestore
          .collection('markets')
          .where('name', isEqualTo: name)
          .get();

      if (sameMarkets.docs.isNotEmpty)
        return const Left(Failure("المتجر موجود بالفعل"));
      final marketDoc = firestore.collection('markets').doc();
      final imgUrl = await uploadImage(imageFile, marketDoc.id);
      final market = Market(
        id: marketDoc.id,
        name: name,
        hotline: hotline,
        location: location,
        desc: desc,
        imgUrl: imgUrl,
        beginTime: beginTime,
        endTime: endTime,
        sellerId: getUserId(),
      );
      await marketDoc.set(market.toDoc());
      return const Right(null);
    } catch (e) {
      throw const Failure("حدث خطأ أثناء اضافة المتجر");
    }
  }

  Future<Either<Failure, void>> editMarket({
    required String id,
    required String name,
    required String hotline,
    required String desc,
    required File imageFile,
    required String originalImgUrl,
    required bool isImgChanged,
    required TimeOfDay beginTime,
    required TimeOfDay endTime,
    required Location location,
  }) async {
    try {
      final marketDoc = firestore.collection('markets').doc(id);
      String imgUrl = originalImgUrl;
      if (isImgChanged) imgUrl = await uploadImage(imageFile, marketDoc.id);
      final market = Market(
        id: marketDoc.id,
        name: name,
        hotline: hotline,
        location: location,
        desc: desc,
        imgUrl: imgUrl,
        beginTime: beginTime,
        endTime: endTime,
        sellerId: getUserId(),
      );
      await marketDoc.set(market.toDoc());
      return const Right(null);
    } catch (e) {
      return const Left(Failure("حدث خطأ أثناء تعديل بيانات المتجر"));
    }
  }

  Future<Either<Failure, void>> deleteMarket(String docId) async {
    try {
      await fireStorage.ref("markets/img-$docId").delete();
      await firestore.collection('markets').doc(docId).delete();
      // delete all categories that marketId = docId
      // delete all products that marketId = docId
      return const Right(null);
    } catch (e) {
      throw const Failure("حدث خطأ أثناء حذف المتجر");
    }
  }

  Future<Either<Failure, List<Market>>> fetchMarkets(int? limits) async {
    try {
      final response = limits != null
          ? await firestore
              .collection('markets')
              .where('sellerId', isEqualTo: getUserId())
              .limit(limits)
              .get()
          : await firestore
              .collection('markets')
              .where('sellerId', isEqualTo: getUserId())
              .get();
      List<Market> marketsList = [];
      for (var marketDoc in response.docs)
        marketsList.add(Market.fromDoc(marketDoc.id, marketDoc.data()));
      return Right(marketsList);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  Future<Either<Failure, List<Product>>> fetchCategories() async {
    try {
      final response = await firestore.collection('categories').get();
      List<Product> categoriesList = [];
      for (var categoryDoc in response.docs)
        categoriesList.add(Product.fromDoc(categoryDoc.id, categoryDoc.data()));
      return Right(categoriesList);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  Future<Either<Failure, List<Product>>> fetchProducts(int? limits) async {
    try {
      final response = limits != null
          ? await firestore.collection('products').limit(limits).get()
          : await firestore.collection('products').get();
      List<Product> productsList = [];
      for (var productDoc in response.docs)
        productsList.add(Product.fromDoc(productDoc.id, productDoc.data()));
      return Right(productsList);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  Future<Product> fetchProductById(String id) async {
    try {
      final productDoc = await firestore.collection('products').doc(id).get();
      return Product.fromDoc(productDoc.id, productDoc.data()!);
    } catch (e) {
      throw const Failure("حدث خطأ أثناء جلب المنتج");
    }
  }

  Future<Either<Failure, List<UserOrder>>> fetchOngoingOrders() async {
    try {
      final orders = await firestore
          .collection('orders')
          .where('userId', isEqualTo: sharedPref.getString('userId'))
          .where('status', whereIn: ['pending', 'shipped'])
          .orderBy('createdAt', descending: true)
          .get();

      final List<UserOrder> orderList = [];
      for (var orderDoc in orders.docs) {
        if (orderDoc.data()['seqId'] != null) continue;
        Map<Product, int> shopping = {};
        orderDoc.data()['shopping'].forEach((id, countVal) async {
          final mappedProduct = await fetchProductById(id);
          shopping.putIfAbsent(mappedProduct, () => countVal);
        });
        orderList.add(UserOrder.fromDoc(
          orderDoc.data(),
          shopping,
          orderDoc.id,
        ));
      }
      return Right(orderList);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  Future<Either<Failure, List<UserOrder>>> fetchHistoryOrders() async {
    try {
      final orders = await firestore
          .collection('orders')
          .where('userId', isEqualTo: sharedPref.getString('userId'))
          .where('status', whereIn: ['cancelled', 'delivered'])
          .orderBy('createdAt', descending: true)
          .get();

      final List<UserOrder> orderList = [];
      for (var orderDoc in orders.docs) {
        if (orderDoc.data()['seqId'] != null) continue;
        Map<Product, int> shopping = {};
        orderDoc.data()['shopping'].forEach((id, countVal) async {
          final mappedProduct = await fetchProductById(id);
          shopping.putIfAbsent(mappedProduct, () => countVal);
        });
        orderList.add(UserOrder.fromDoc(
          orderDoc.data(),
          shopping,
          orderDoc.id,
        ));
      }
      return Right(orderList);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}
