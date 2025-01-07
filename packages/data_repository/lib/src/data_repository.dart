import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:either_dart/either.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:models_repository/models_repository.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DataRepository {
  final FirebaseFirestore firestore;
  final FirebaseStorage fireStorage;
  final SharedPreferences sharedPref;
  Market? _selctedMarket;
  Category? _selectedCategory;
  Product? _selectedProduct;
  Ad? _selectedAd;
  UserOrder? _selectedOrder;
  double _price;
  Map<String, int> _shopping;

  DataRepository({
    required this.firestore,
    required this.fireStorage,
    required this.sharedPref,
  })  : _price = 0,
        _shopping = {};

  String getUserId() => sharedPref.getString('userId') ?? '';
  Market? getCurMarket() => _selctedMarket;
  Category? getCurCategory() => _selectedCategory;
  Product? getCurProduct() => _selectedProduct;
  Ad? getCurAd() => _selectedAd;
  UserOrder? getCurOrder() => _selectedOrder;
  void setCurMarket(Market market) => _selctedMarket = market;
  void setCurCategory(Category category) => _selectedCategory = category;
  void setCurProduct(Product product) => _selectedProduct = product;
  void setCurAd(Ad ad) => _selectedAd = ad;
  void setCurOrder(UserOrder order) => _selectedOrder = order;

  /*----- Market Operations -----*/

  Stream<Either<Failure, List<Market>>> marketsStream() async* {
    try {
      final query = firestore.collection(ConstantManager.marketCollection);
      yield* query.snapshots().asyncMap((snapshot) async {
        try {
          List<Market> marketsList = [];
          for (var doc in snapshot.docs) {
            if (doc.data()['active'] == false) continue;
            marketsList.add(Market.fromDoc(doc.id, doc.data()));
          }
          return Right(marketsList);
        } catch (e) {
          return Left(Failure(e.toString()));
        }
      });
    } catch (e) {
      yield Left(Failure(e.toString()));
    }
  }

  Stream<Either<Failure, Market>> marketDetailsStream() async* {
    try {
      final docRef = firestore
          .collection(ConstantManager.marketCollection)
          .doc(_selctedMarket?.id);
      yield* docRef.snapshots().asyncMap((snapshot) async {
        try {
          if (!snapshot.exists)
            return const Left(Failure('لم يتم العثور على هذاالمتجر'));
          return Right(Market.fromDoc(snapshot.id, snapshot.data()!));
        } catch (e) {
          return Left(Failure(e.toString()));
        }
      });
    } catch (e) {
      yield Left(Failure(e.toString()));
    }
  }

  Future<Either<Failure, List<Market>>> fetchMarkets() async {
    try {
      final response =
          await firestore.collection(ConstantManager.marketCollection).get();
      List<Market> marketsList = [];
      for (var marketDoc in response.docs) {
        if (marketDoc.data()['active'] == false) continue;
        marketsList.add(Market.fromDoc(marketDoc.id, marketDoc.data()));
      }
      return Right(marketsList);
    } catch (e) {
      log(e.toString());
      return Left(Failure(e.toString()));
    }
  }

  Future<bool> isMarketActive(String id) async {
    try {
      final marketDoc = await firestore
          .collection(ConstantManager.marketCollection)
          .doc(id)
          .get();
      return marketDoc.data()?['active'];
    } catch (e) {
      log(e.toString());
      throw const Failure("حدث خطأ أثناء جلب المتجر");
    }
  }

  /*----- Category Operations -----*/

  Stream<Either<Failure, List<Category>>> categorysStream() async* {
    try {
      final query = firestore
          .collection(ConstantManager.categoryCollection)
          .where('marketId', isEqualTo: _selctedMarket?.id)
          .orderBy('orderId');
      yield* query.snapshots().asyncMap((snapshot) async {
        try {
          List<Category> categorysList = [];
          for (var doc in snapshot.docs)
            categorysList.add(Category.fromDoc(doc.id, doc.data()));
          return Right(categorysList);
        } catch (e) {
          return Left(Failure(e.toString()));
        }
      });
    } catch (e) {
      yield Left(Failure(e.toString()));
    }
  }

  Future<Either<Failure, List<Category>>> fetchCategories() async {
    try {
      final response = await firestore
          .collection(ConstantManager.categoryCollection)
          .where('marketId', isEqualTo: _selctedMarket?.id)
          .orderBy('orderId')
          .get();
      List<Category> categoriesList = [];
      for (var doc in response.docs)
        categoriesList.add(Category.fromDoc(doc.id, doc.data()));
      return Right(categoriesList);
    } catch (e) {
      log(e.toString());
      return Left(Failure(e.toString()));
    }
  }

  /*----- Product Operations -----*/

  Stream<Either<Failure, Product>> productDetailsStream() async* {
    try {
      final docRef = firestore
          .collection(ConstantManager.productCollection)
          .doc(_selectedProduct?.id);
      yield* docRef.snapshots().asyncMap((snapshot) async {
        try {
          if (!snapshot.exists)
            return const Left(Failure('لم يتم العثور على المنتج'));
          return Right(Product.fromDoc(snapshot.id, snapshot.data()!));
        } catch (e) {
          return Left(Failure(e.toString()));
        }
      });
    } catch (e) {
      yield Left(Failure(e.toString()));
    }
  }

  Future<Either<Failure, List<Product>>> fetchProducts(int? limits) async {
    try {
      final response = limits != null
          ? await firestore
              .collection(ConstantManager.productCollection)
              .limit(limits)
              .get()
          : await firestore.collection(ConstantManager.productCollection).get();
      List<Product> productsList = [];
      for (var productDoc in response.docs) {
        final marketActive =
            await isMarketActive(productDoc.data()['marketId']);
        if (!marketActive ||
            productDoc.data()['quantity'].toDouble().floor() == 0) continue;
        productsList.add(Product.fromDoc(productDoc.id, productDoc.data()));
      }
      return Right(productsList);
    } catch (e) {
      log(e.toString());
      return Left(Failure(e.toString()));
    }
  }

  Stream<Either<Failure, List<Product>>> productsStream() async* {
    try {
      final query = firestore.collection(ConstantManager.productCollection);
      yield* query.snapshots().asyncMap((snapshot) async {
        try {
          List<Product> productsList = [];
          for (var doc in snapshot.docs) {
            final marketActive = await isMarketActive(doc.data()['marketId']);
            if (!marketActive || doc.data()['quantity'].toDouble().floor() == 0)
              continue;
            productsList.add(Product.fromDoc(doc.id, doc.data()));
          }
          return Right(productsList);
        } catch (e) {
          return Left(Failure(e.toString()));
        }
      });
    } catch (e) {
      yield Left(Failure(e.toString()));
    }
  }

  Future<Either<Failure, List<Product>>> fetchCategoryRelatedProducts() async {
    try {
      final response = await firestore
          .collection(ConstantManager.productCollection)
          .where('categoryId', isEqualTo: _selectedCategory?.id)
          .get();
      List<Product> productsList = [];
      for (var productDoc in response.docs)
        productsList.add(Product.fromDoc(productDoc.id, productDoc.data()));
      return Right(productsList);
    } catch (e) {
      log(e.toString());
      return Left(Failure(e.toString()));
    }
  }

  Future<Product> getProductById(String id) async {
    try {
      final productDoc = await firestore
          .collection(ConstantManager.productCollection)
          .doc(id)
          .get();
      return Product.fromDoc(productDoc.id, productDoc.data() ?? {});
    } catch (e) {
      log(e.toString());
      throw const Failure("حدث خطأ أثناء جلب المنتج");
    }
  }

  /*----- Cart Operations -----*/

  Future<Either<Failure, Map<String, dynamic>>> fetchCart() async {
    try {
      _price = 0;
      String? cartMap = sharedPref.getString('shopping');
      if (cartMap == null) {
        _shopping = {};
        await sharedPref.setDouble('price', _price);
        await sharedPref.setString('shopping', json.encode(_shopping));
        return const Right({
          'shopping': <Product, int>{},
          'price': 0.0,
        });
      }
      Map<String, dynamic> decShopping = json.decode(cartMap);
      Map<Product, int> shoppingData = {};
      _shopping = decShopping.map((id, cnt) => MapEntry(id, cnt as int));
      for (MapEntry<String, int> entry in _shopping.entries) {
        final mappedProduct = await getProductById(entry.key);
        _price += mappedProduct.updatedPrice * entry.value;
        shoppingData.putIfAbsent(mappedProduct, () => entry.value);
      }
      return Right({
        'price': _price,
        'shopping': shoppingData,
      });
    } catch (e) {
      log(e.toString());
      return const Left(Failure('حدث خطأ أثناء تحميل السله'));
    }
  }

  Future<Either<Failure, Map<String, dynamic>>> resetCart() async {
    _price = 0;
    _shopping = {};
    try {
      await sharedPref.setDouble('price', _price);
      await sharedPref.setString('shopping', json.encode(_shopping));
      return Right({
        'price': _price,
        'shopping': const <Product, int>{},
      });
    } catch (e) {
      log(e.toString());
      return const Left(Failure('حدث خطأ أثناء اعادة السله'));
    }
  }

  Future<Either<Failure, void>> addProductToCart(
    Product product,
  ) async {
    try {
      _price += product.updatedPrice;
      _shopping.update(
        product.id,
        (value) => value + 1,
        ifAbsent: () => 1,
      );
      await sharedPref.setDouble('price', _price);
      await sharedPref.setString('shopping', json.encode(_shopping));
      return const Right(null);
    } catch (e) {
      log(e.toString());
      return const Left(Failure('حدث خطأ أثناء اضافة المنتج للسله'));
    }
  }

  Future<Either<Failure, void>> removeProductFromCart(Product product) async {
    try {
      if (_shopping.containsKey(product.id)) {
        _price -= product.updatedPrice * (_shopping[product.id] ?? 0);
        _shopping.remove(product.id);
        await sharedPref.setDouble('price', _price);
        await sharedPref.setString('shopping', json.encode(_shopping));
      }
      return const Right(null);
    } catch (e) {
      log(e.toString());
      return const Left(Failure('حدث خطأ أثناء حذف المنتج من السله'));
    }
  }

  Future<Either<Failure, void>> increaseProductQuantityInCart(
      Product product) async {
    try {
      _price += product.updatedPrice;
      _shopping.update(
        product.id,
        (value) => value + 1,
        ifAbsent: () => 1,
      );
      await sharedPref.setDouble('price', _price);
      await sharedPref.setString('shopping', json.encode(_shopping));
      return const Right(null);
    } catch (e) {
      log(e.toString());
      return const Left(Failure('حدث خطأ أثناء زيادة كمية المنتج فى السله'));
    }
  }

  Future<Either<Failure, void>> decreaseProductQuantityFromCart(
    Product product,
  ) async {
    try {
      if (_shopping.containsKey(product.id)) {
        _price -= product.updatedPrice;
        _shopping.update(
          product.id,
          (value) => value - 1,
          ifAbsent: null,
        );
        if (_shopping[product.id] == 0) {
          _shopping.remove(product.id);
        }
        await sharedPref.setDouble('price', _price);
        await sharedPref.setString('shopping', json.encode(_shopping));
      }
      return const Right(null);
    } catch (e) {
      log(e.toString());
      return const Left(Failure('حدث خطأ أثناء تقليل كمية المنتج من السله'));
    }
  }

  /*----- Order Operations -----*/

  Future<Either<Failure, Null>> placeOrder(Location location) async {
    try {
      final seqIdDoc = firestore
          .collection(ConstantManager.ordersCollection)
          .doc(ConstantManager.orderSeqIdDoc);
      int seqIdVal = (await seqIdDoc.get()).data()?['seqId'];
      final orderMap = {
        'total': _price,
        'code': seqIdVal,
        'shopping': _shopping,
        'userId': getUserId(),
        'status': OrderStatus.pending.name,
        'createdAt': DateTime.now(),
        'location': location.toJson(),
      };
      await firestore.collection('orders').add(orderMap);
      await seqIdDoc.set({'seqId': seqIdVal + 1});
      _shopping.forEach((id, taken) async {
        await firestore
            .collection(ConstantManager.productCollection)
            .doc(id)
            .update({'quantity': FieldValue.increment(-taken)});
      });
      return const Right(null);
    } catch (e) {
      log(e.toString());
      return Left(Failure(e.toString()));
    }
  }

  Future<Either<Failure, Null>> confirmDeliveryOrder(String orderId) async {
    try {
      await firestore
          .collection('orders')
          .doc(orderId)
          .update({'status': OrderStatus.delivered.name});
      return const Right(null);
    } catch (e) {
      log(e.toString());
      return Left(Failure(e.toString()));
    }
  }

  Future<Either<Failure, Null>> cancelOrder(String orderId) async {
    try {
      final orderData =
          (await firestore.collection('orders').doc(orderId).get()).data() ??
              {};
      if (orderData['status'] == OrderStatus.shipped.name)
        return const Left(Failure('تم شحن الطلب بالفعل'));
      await firestore
          .collection('orders')
          .doc(orderId)
          .update({'status': OrderStatus.cancelled.name});
      orderData['shopping'].forEach((id, taken) async {
        await firestore
            .collection(ConstantManager.productCollection)
            .doc(id)
            .update({'quantity': FieldValue.increment(taken)});
      });
      return const Right(null);
    } catch (e) {
      log(e.toString());
      return Left(Failure(e.toString()));
    }
  }

  Future<Either<Failure, Null>> refuseOrder(String orderId) async {
    try {
      final orderData =
          (await firestore.collection('orders').doc(orderId).get()).data() ??
              {};
      await firestore
          .collection('orders')
          .doc(orderId)
          .update({'status': OrderStatus.refused.name});
      orderData['shopping'].forEach((id, taken) async {
        await firestore
            .collection(ConstantManager.productCollection)
            .doc(id)
            .update({'quantity': FieldValue.increment(taken)});
      });
      return const Right(null);
    } catch (e) {
      log(e.toString());
      return Left(Failure(e.toString()));
    }
  }

  Stream<Either<Failure, Map<String, List<UserOrder>>>> ordersStream() async* {
    try {
      final userId = getUserId();
      final ongoingOrdersStream = firestore
          .collection('orders')
          .where('userId', isEqualTo: userId)
          .where('status', whereIn: ['pending', 'shipped'])
          .orderBy('createdAt', descending: true)
          .snapshots();

      final historyOrdersStream = firestore
          .collection('orders')
          .where('userId', isEqualTo: userId)
          .where('status', whereIn: ['cancelled', 'delivered', 'refused'])
          .orderBy('createdAt', descending: true)
          .snapshots();

      yield* Rx.combineLatest2(
        ongoingOrdersStream,
        historyOrdersStream,
        (ongoingSnapshot, historySnapshot) async {
          try {
            final List<UserOrder> ongoingOrderList = [];
            final List<UserOrder> historyOrderList = [];
            for (var doc in ongoingSnapshot.docs) {
              if (doc.data()['seqId'] != null) continue;
              Map<Product, int> shopping = {};
              for (MapEntry<String, dynamic> entry
                  in doc.data()['shopping'].entries) {
                final mappedProduct = await getProductById(entry.key);
                shopping[mappedProduct] = entry.value as int;
              }
              ongoingOrderList.add(UserOrder.fromDoc(
                doc.data(),
                shopping,
                doc.id,
              ));
            }

            for (var doc in historySnapshot.docs) {
              if (doc.data()['seqId'] != null) continue;
              Map<Product, int> shopping = {};
              for (MapEntry<String, dynamic> entry
                  in doc.data()['shopping'].entries) {
                final mappedProduct = await getProductById(entry.key);
                shopping[mappedProduct] = entry.value as int;
              }
              historyOrderList.add(UserOrder.fromDoc(
                doc.data(),
                shopping,
                doc.id,
              ));
            }

            return Right({
              'ongoing': ongoingOrderList,
              'history': historyOrderList,
            });
          } catch (e) {
            return Left(Failure(e.toString()));
          }
        },
      ).asyncMap((value) async =>
          await value as Either<Failure, Map<String, List<UserOrder>>>);
    } catch (e) {
      yield Left(Failure(e.toString()));
    }
  }

  Future<Either<Failure, Map<String, List<UserOrder>>>> fetchOrders() async {
    try {
      final results = await Future.wait([
        firestore
            .collection('orders')
            .where('userId', isEqualTo: getUserId())
            .where('status', whereIn: ['pending', 'shipped'])
            .orderBy('createdAt', descending: true)
            .get(),
        firestore
            .collection('orders')
            .where('userId', isEqualTo: getUserId())
            .where('status', whereIn: ['cancelled', 'delivered', 'refused'])
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
          final mappedProduct = await getProductById(id);
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
          final mappedProduct = await getProductById(id);
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

  /*----- Ads Operations -----*/

  Stream<Either<Failure, List<Ad>>> adsStream() async* {
    try {
      final query = firestore.collection(ConstantManager.adsCollection);
      yield* query.snapshots().asyncMap((snapshot) async {
        try {
          List<Ad> adsList = [];
          for (var adDoc in snapshot.docs) {
            List<Offer> offers = [];
            for (var offerDoc in adDoc.data()['offers']) {
              final offerProduct = await getProductById(offerDoc['productId']);
              offers.add(Offer.fromDoc(offerDoc, offerProduct));
            }
            adsList.add(Ad.fromDoc(adDoc.id, offers, adDoc.data()));
          }
          return Right(adsList);
        } catch (e) {
          return Left(Failure(e.toString()));
        }
      });
    } catch (e) {
      yield Left(Failure(e.toString()));
    }
  }

  Future<Either<Failure, List<Ad>>> fetchAds() async {
    try {
      final response =
          await firestore.collection(ConstantManager.adsCollection).get();
      List<Ad> adsList = [];
      for (var adDoc in response.docs) {
        List<Offer> offers = [];
        for (var offerDoc in adDoc.data()['offers']) {
          final offerProduct = await getProductById(offerDoc['productId']);
          offers.add(Offer.fromDoc(offerDoc, offerProduct));
        }
        adsList.add(Ad.fromDoc(adDoc.id, offers, adDoc.data()));
      }
      return Right(adsList);
    } catch (e) {
      log(e.toString());
      return Left(Failure(e.toString()));
    }
  }

  Stream<Either<Failure, Ad>> adDetailsStream() async* {
    try {
      final docRef = firestore
          .collection(ConstantManager.adsCollection)
          .doc(_selectedAd?.id);
      yield* docRef.snapshots().asyncMap((snapshot) async {
        try {
          if (!snapshot.exists)
            return const Left(Failure('لم يتم العثور على المنتج'));
          List<Offer> offers = [];
          for (var offerDoc in snapshot.data()!['offers']) {
            final offerProduct = await getProductById(offerDoc['productId']);
            offers.add(Offer.fromDoc(offerDoc, offerProduct));
          }
          return Right(Ad.fromDoc(snapshot.id, offers, snapshot.data()!));
        } catch (e) {
          return Left(Failure(e.toString()));
        }
      });
    } catch (e) {
      yield Left(Failure(e.toString()));
    }
  }

  /*----- Search Operation -----*/

  Future<Either<Failure, List<Product>>> searchForProductByName(
    String productName,
  ) async {
    try {
      final searchResults = await firestore
          .collection(ConstantManager.productCollection)
          .where(
            'name',
            isGreaterThanOrEqualTo: productName,
            isLessThanOrEqualTo: '$productName\uf8ff',
          )
          .get();

      final List<Product> searchProductList = [];
      for (var result in searchResults.docs)
        searchProductList.add(Product.fromDoc(result.id, result.data()));
      return Right(searchProductList);
    } catch (e) {
      log(e.toString());
      return Left(Failure(e.toString()));
    }
  }
}
