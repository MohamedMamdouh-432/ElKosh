import 'dart:developer';
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
  Market? _curMarket;
  Category? _curCategory;
  Product? _curProduct;

  AdminRepository({
    required this.firestore,
    required this.fireStorage,
    required this.sharedPref,
  });

  String getUserId() => sharedPref.getString('userId') ?? '';
  Market? getCurMarket() => _curMarket;
  Category? getCurCategory() => _curCategory;
  Product? getCurProduct() => _curProduct;
  void setCurMarket(Market market) => _curMarket = market;
  void setCurCategory(Category category) => _curCategory = category;
  void setCurProduct(Product product) => _curProduct = product;

  Future<String> uploadImage(File image, String docId, String prefix) async {
    try {
      final fileRef =
          await fireStorage.ref("$prefix/img-$docId").putFile(image);
      final url = await fileRef.ref.getDownloadURL();
      return url;
    } catch (e) {
      log(e.toString());
      log(e.toString());
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
      final imgUrl = await uploadImage(imageFile, marketDoc.id, "markets");
      final market = Market(
        id: marketDoc.id,
        name: name,
        hotline: hotline,
        location: location,
        desc: desc,
        imgUrl: imgUrl,
        beginTime: beginTime,
        endTime: endTime,
        adminId: getUserId(),
        active: true,
      );
      await marketDoc.set(market.toDoc());
      return const Right(null);
    } catch (e) {
      log(e.toString());
      log(e.toString());
      return const Left(Failure("حدث خطأ أثناء اضافة المتجر"));
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
    required bool active,
  }) async {
    try {
      final marketDoc = firestore.collection('markets').doc(id);
      String imgUrl = originalImgUrl;
      if (isImgChanged)
        imgUrl = await uploadImage(imageFile, marketDoc.id, "markets");
      final market = Market(
        id: marketDoc.id,
        name: name,
        hotline: hotline,
        location: location,
        desc: desc,
        imgUrl: imgUrl,
        beginTime: beginTime,
        endTime: endTime,
        adminId: getUserId(),
        active: active,
      );
      await marketDoc.set(market.toDoc());
      return const Right(null);
    } catch (e) {
      log(e.toString());
      log(e.toString());
      return const Left(Failure("حدث خطأ أثناء تعديل بيانات المتجر"));
    }
  }

  Future<Either<Failure, void>> blockMarket(String marketId) async {
    try {
      await firestore
          .collection('markets')
          .doc(marketId)
          .update({'active': false});
      return const Right(null);
    } catch (e) {
      log(e.toString());
      log(e.toString());
      throw const Failure("حدث خطأ أثناء توقيف المتجر");
    }
  }

  Future<Either<Failure, void>> unBlockMarket(String marketId) async {
    try {
      await firestore
          .collection('markets')
          .doc(marketId)
          .update({'active': true});
      return const Right(null);
    } catch (e) {
      log(e.toString());
      log(e.toString());
      throw const Failure("حدث خطأ أثناء الغاء توقيف المتجر");
    }
  }

  Future<Either<Failure, void>> deleteMarket(String marketId) async {
    try {
      WriteBatch batch = firestore.batch();
      QuerySnapshot categorySnapshot = await firestore
          .collection('categories')
          .where('marketId', isEqualTo: marketId)
          .get();

      for (var categoryDoc in categorySnapshot.docs) {
        QuerySnapshot productSnapshot = await firestore
            .collection('products')
            .where('marketId', isEqualTo: marketId)
            .where('categoryId', isEqualTo: categoryDoc.id)
            .get();

        for (var productDoc in productSnapshot.docs) {
          batch.delete(productDoc.reference);
          await fireStorage.ref("products/img-${productDoc.id}").delete();
        }
        batch.delete(categoryDoc.reference);
      }
      batch.delete(firestore.collection('markets').doc(marketId));
      await fireStorage.ref("markets/img-$marketId").delete();
      await batch.commit();
      return const Right(null);
    } catch (e) {
      log(e.toString());
      log(e.toString());
      throw const Failure("حدث خطأ أثناء حذف المتجر");
    }
  }

  Future<Either<Failure, List<Market>>> fetchMarkets() async {
    try {
      final response = await firestore.collection('markets').get();
      List<Market> marketsList = [];
      for (var marketDoc in response.docs)
        marketsList.add(Market.fromDoc(marketDoc.id, marketDoc.data()));
      return Right(marketsList);
    } catch (e) {
      log(e.toString());
      log(e.toString());
      return Left(Failure(e.toString()));
    }
  }

  Future<Either<Failure, void>> addCategory(MapEntry categoryItem) async {
    try {
      final similar = await firestore
          .collection('categories')
          .where('marketId', isEqualTo: _curMarket?.id)
          .where('name', isEqualTo: categoryItem.key)
          .get();
      if (similar.docs.isNotEmpty)
        return const Left(Failure('هذا الصنف موجود بالفعل'));
      await firestore.collection('categories').add({
        'name': categoryItem.key,
        'marketId': _curMarket?.id,
        'imgUrl': categoryItem.value,
      });
      return const Right(null);
    } catch (e) {
      log(e.toString());
      log(e.toString());
      return const Left(Failure('حدث خطأ أثناء اضافة هذا الصنف'));
    }
  }

  Future<Either<Failure, void>> deleteCategory(String categoryId) async {
    try {
      WriteBatch batch = firestore.batch();
      QuerySnapshot productSnapshot = await firestore
          .collection('products')
          .where('categoryId', isEqualTo: categoryId)
          .get();

      for (var productDoc in productSnapshot.docs) {
        batch.delete(productDoc.reference);
        await fireStorage.ref("products/img-${productDoc.id}").delete();
      }
      batch.delete(firestore.collection('categories').doc(categoryId));
      await batch.commit();
      return const Right(null);
    } catch (e) {
      log(e.toString());
      log(e.toString());
      return const Left(Failure("حدث خطأ أثناء حذف هذا الصنف"));
    }
  }

  Future<Either<Failure, List<Category>>> fetchCategories() async {
    try {
      final response = await firestore
          .collection('categories')
          .where('marketId', isEqualTo: _curMarket?.id)
          .get();
      List<Category> categoriesList = [];
      for (var categoryDoc in response.docs)
        categoriesList
            .add(Category.fromDoc(categoryDoc.id, categoryDoc.data()));
      return Right(categoriesList);
    } catch (e) {
      log(e.toString());
      log(e.toString());
      return Left(Failure(e.toString()));
    }
  }

  Future<Either<Failure, void>> addProduct({
    required String name,
    required String desc,
    required File imageFile,
    required double price,
    required String unit,
    required double unitVal,
    required double quantity,
  }) async {
    try {
      final sameProducts = await firestore
          .collection('products')
          .where('categoryId', isEqualTo: _curCategory?.id)
          .where('name', isEqualTo: name)
          .get();

      if (sameProducts.docs.isNotEmpty)
        return const Left(Failure("المنتج موجود بالفعل"));
      final productDoc = firestore.collection('products').doc();
      final imgUrl = await uploadImage(imageFile, productDoc.id, "products");
      final product = Product(
        id: productDoc.id,
        name: name,
        desc: desc,
        imgUrl: imgUrl,
        price: price,
        updatedPrice: 0,
        unit: unit,
        unitVal: unitVal,
        quantity: quantity,
        categoryId: _curCategory?.id ?? '',
        marketId: _curMarket?.id ?? '',
      );
      await productDoc.set(product.toDoc());
      return const Right(null);
    } catch (e) {
      log(e.toString());
      log(e.toString());
      return const Left(Failure("حدث خطأ أثناء اضافة المنتج"));
    }
  }

  Future<Either<Failure, void>> editProduct({
    required String id,
    required String name,
    required String desc,
    required File imageFile,
    required String originalImgUrl,
    required bool isImgChanged,
    required double price,
    required String unit,
    required double unitVal,
    required double quantity,
  }) async {
    try {
      final productDoc = firestore.collection('products').doc(id);
      String imgUrl = originalImgUrl;
      if (isImgChanged)
        imgUrl = await uploadImage(imageFile, productDoc.id, "products");
      final product = Product(
        id: productDoc.id,
        name: name,
        desc: desc,
        imgUrl: imgUrl,
        price: price,
        unit: unit,
        updatedPrice: _curProduct?.updatedPrice ?? 0,
        unitVal: unitVal,
        quantity: quantity,
        categoryId: _curCategory?.id ?? '',
        marketId: _curMarket?.id ?? '',
      );
      await productDoc.set(product.toDoc());
      return const Right(null);
    } catch (e) {
      log(e.toString());
      log(e.toString());
      return const Left(Failure("حدث خطأ أثناء تعديل بيانات المنتج"));
    }
  }

  Future<Either<Failure, void>> addProductDiscount(double newPrice) async {
    try {
      await firestore
          .collection('products')
          .doc(_curProduct?.id)
          .update({'updatedPrice': newPrice});
      return const Right(null);
    } catch (e) {
      log(e.toString());
      return Left(Failure(e.toString()));
    }
  }

  Future<Either<Failure, void>> deleteProduct(String docId) async {
    try {
      await fireStorage.ref("products/img-$docId").delete();
      await firestore.collection('products').doc(docId).delete();
      return const Right(null);
    } catch (e) {
      log(e.toString());
      log(e.toString());
      throw const Failure("حدث خطأ أثناء حذف المنتج");
    }
  }

  Future<Product> fetchProductById(String id) async {
    try {
      final productDoc = await firestore.collection('products').doc(id).get();
      return Product.fromDoc(productDoc.id, productDoc.data() ?? {});
    } catch (e) {
      log(e.toString());
      log(e.toString());
      throw const Failure("حدث خطأ أثناء جلب المنتج");
    }
  }

  Future<Either<Failure, List<Product>>> fetchProducts() async {
    try {
      log(_curCategory?.id ?? '');
      final response = await firestore
          .collection('products')
          .where('categoryId', isEqualTo: _curCategory?.id)
          .get();
      List<Product> productsList = [];
      for (var productDoc in response.docs)
        productsList.add(Product.fromDoc(productDoc.id, productDoc.data()));
      return Right(productsList);
    } catch (e) {
      log(e.toString());
      log(e.toString());
      return Left(Failure(e.toString()));
    }
  }

  Future<Either<Failure, Map<String, List<UserOrder>>>> fetchNotifications() async {
    try {
      final results = await Future.wait([
        firestore
            .collection('orders')
            .where('status', whereIn: ['pending', 'shipped'])
            .orderBy('createdAt', descending: true)
            .get(),
        firestore
            .collection('orders')
            .where('status', whereIn: ['cancelled', 'delivered'])
            .orderBy('createdAt', descending: true)
            .get(),
      ]);

      final ongoingOrders = results[0];
      final historyOrders = results[1];

      final List<UserOrder> ongoingOrderList = [];
      final List<UserOrder> historyOrderList = [];

      for (var orderDoc in ongoingOrders.docs) {
        if (orderDoc.data()['seqId'] != null) continue;
        Map<Product, int> shopping = {};
        orderDoc.data()['shopping'].forEach((id, countVal) async {
          final mappedProduct = await fetchProductById(id);
          shopping.putIfAbsent(mappedProduct, () => countVal);
        });
        ongoingOrderList.add(UserOrder.fromDoc(
          orderDoc.data(),
          shopping,
          orderDoc.id,
        ));
      }

      for (var orderDoc in historyOrders.docs) {
        if (orderDoc.data()['seqId'] != null) continue;
        Map<Product, int> shopping = {};
        orderDoc.data()['shopping'].forEach((id, countVal) async {
          final mappedProduct = await fetchProductById(id);
          shopping.putIfAbsent(mappedProduct, () => countVal);
        });
        historyOrderList.add(UserOrder.fromDoc(
          orderDoc.data(),
          shopping,
          orderDoc.id,
        ));
      }

      return Right({
        'ongoing': ongoingOrderList,
        'history': historyOrderList,
      });
    } catch (e) {
      log(e.toString());
      log(e.toString());
      return Left(Failure(e.toString()));
    }
  }

  Future<Either<Failure, void>> blockUser(String userId) async {
    try {
      await firestore.collection('users').doc(userId).update({'active': false});
      return const Right(null);
    } catch (e) {
      log(e.toString());
      log(e.toString());
      throw const Failure("حدث خطأ أثناء توقيف المستخدم");
    }
  }

  Future<Either<Failure, void>> unBlockUser(String userId) async {
    try {
      await firestore.collection('users').doc(userId).update({'active': true});
      return const Right(null);
    } catch (e) {
      log(e.toString());
      log(e.toString());
      throw const Failure("حدث خطأ أثناء الغاء توقيف المستخدم");
    }
  }

  Future<Either<Failure, List<User>>> fetchUsers() async {
    try {
      final results = await firestore.collection('users').get();
      final List<User> usersList = [];
      for (var userDoc in results.docs) {
        if (userDoc.data()['userType'] == 'admin') continue;
        usersList.add(User.fromDoc(userDoc.id, userDoc.data()));
      }
      return Right(usersList);
    } catch (e) {
      log(e.toString());
      log(e.toString());
      return Left(Failure(e.toString()));
    }
  }
}
