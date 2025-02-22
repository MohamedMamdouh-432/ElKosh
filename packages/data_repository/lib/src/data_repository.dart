import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:either_dart/either.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:models_repository/models_repository.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DataRepository {
  final FirebaseFirestore firestore;
  final FirebaseStorage fireStorage;
  final SharedPreferences sharedPref;
  Market? _curMarket;
  Category? _curCategory;
  Product? _curProduct;
  Ad? _curAd;
  UserOrder? _curOrder;
  double _price;
  Map<String, int> _shopping;
  String? _lastId;
  int? _lastIdVal;

  DataRepository({
    required this.firestore,
    required this.fireStorage,
    required this.sharedPref,
  })  : _price = 0,
        _shopping = {};

  String getUserId() => sharedPref.getString('userId') ?? '';
  Market? getCurMarket() => _curMarket;
  Category? getCurCategory() => _curCategory;
  Product? getCurProduct() => _curProduct;
  Ad? getCurAd() => _curAd;
  UserOrder? getCurOrder() => _curOrder;
  void setCurMarket(Market market) => _curMarket = market;
  void setCurCategory(Category category) => _curCategory = category;
  void setCurProduct(Product product) => _curProduct = product;
  void setCurAd(Ad ad) => _curAd = ad;
  void setCurOrder(UserOrder order) => _curOrder = order;

  /*----- Market Operations -----*/

  Stream<Either<Failure, List<Market>>> marketsStream() async* {
    try {
      final Box<Market> marketBox = Hive.box<Market>('marketsBox');

      // **إرسال البيانات المخزنة مؤقتًا أولاً (إن وجدت)**
      if (marketBox.isNotEmpty) {
        yield Right(marketBox.values.toList());
      }

      final query = firestore.collection(ConstantManager.marketCollection);
      yield* query.snapshots().asyncMap((snapshot) async {
        try {
          List<Market> marketsList = [];
          for (var doc in snapshot.docs) {
            if (doc.data()['active'] == false) continue;
            marketsList.add(Market.fromDoc(doc.id, doc.data()));
          }

          // **تحديث الكاش في Hive**
          await marketBox.clear();
          for (var market in marketsList) {
            await marketBox.put(market.id, market);
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
      final Box<Market> marketBox = Hive.box<Market>('marketsBox');

      // **إرسال البيانات المخزنة مؤقتًا أولاً إن وجدت**
      if (marketBox.containsKey(_curMarket?.id)) {
        yield Right(marketBox.get(_curMarket?.id)!);
      }

      final docRef = firestore
          .collection(ConstantManager.marketCollection)
          .doc(_curMarket?.id);
      yield* docRef.snapshots().asyncMap((snapshot) async {
        try {
          if (!snapshot.exists) {
            return const Left(Failure('لم يتم العثور على هذا المتجر'));
          }

          final Market market = Market.fromDoc(snapshot.id, snapshot.data()!);

          // **تحديث الكاش**
          await marketBox.put(market.id, market);

          return Right(market);
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
      final Box<Market> marketBox = Hive.box<Market>('marketsBox');

      // **جلب البيانات المخزنة مؤقتًا إذا كانت موجودة**
      if (marketBox.isNotEmpty) {
        return Right(marketBox.values.toList());
      }

      final response =
          await firestore.collection(ConstantManager.marketCollection).get();
      List<Market> marketsList = [];
      for (var marketDoc in response.docs) {
        if (marketDoc.data()['active'] == false) continue;
        marketsList.add(Market.fromDoc(marketDoc.id, marketDoc.data()));
      }

      // **تحديث الكاش**
      await marketBox.clear();
      for (var market in marketsList) {
        await marketBox.put(market.id, market);
      }

      return Right(marketsList);
    } catch (e) {
      AppLogs.error('Markets Loading Error: $e');
      return Left(Failure(e.toString()));
    }
  }

  Future<bool> isMarketActive(String id, [String? pId]) async {
    try {
      final Box<Market> marketBox = Hive.box<Market>('marketsBox');

      // **التحقق من الكاش أولاً**
      if (marketBox.containsKey(id)) {
        return marketBox.get(id)!.active;
      }

      final marketDoc = await firestore
          .collection(ConstantManager.marketCollection)
          .doc(id)
          .get();
      if (!marketDoc.exists) {
        AppLogs.debug('Market $id Not Found');
        return false;
      }

      final bool isActive = marketDoc.data()?['active'] ?? false;

      // **تحديث الكاش إذا كان المتجر موجودًا**
      final Market market = Market.fromDoc(id, marketDoc.data()!);
      await marketBox.put(market.id, market);

      return isActive;
    } catch (e) {
      AppLogs.error('Error @isMarketActive: $e');
      throw const Failure("حدث خطأ أثناء جلب المتجر");
    }
  }

  /*----- Category Operations -----*/

  Stream<Either<Failure, List<Category>>> categorysStream() async* {
    try {
      final Box<Category> categoryBox = Hive.box<Category>('categoriesBox');

      // **إرسال البيانات المخزنة مؤقتًا أولًا (إن وجدت)**
      if (categoryBox.isNotEmpty) {
        yield Right(categoryBox.values.toList());
      }

      final query = firestore
          .collection(ConstantManager.categoryCollection)
          .where('marketId', isEqualTo: _curMarket?.id)
          .orderBy('orderId');

      yield* query.snapshots().asyncMap((snapshot) async {
        try {
          List<Category> categoriesList = [];
          for (var doc in snapshot.docs) {
            categoriesList.add(Category.fromDoc(doc.id, doc.data()));
          }

          // **تحديث الكاش في Hive**
          await categoryBox.clear();
          for (var category in categoriesList) {
            await categoryBox.put(category.id, category);
          }

          return Right(categoriesList);
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
      final Box<Category> categoryBox = Hive.box<Category>('categoriesBox');

      // **إرجاع البيانات المخزنة مؤقتًا إذا كانت موجودة**
      if (categoryBox.isNotEmpty) {
        return Right(categoryBox.values.toList());
      }

      final response = await firestore
          .collection(ConstantManager.categoryCollection)
          .where('marketId', isEqualTo: _curMarket?.id)
          .orderBy('orderId')
          .get();

      List<Category> categoriesList = [];
      for (var doc in response.docs) {
        categoriesList.add(Category.fromDoc(doc.id, doc.data()));
      }

      // **تحديث الكاش**
      await categoryBox.clear();
      for (var category in categoriesList) {
        await categoryBox.put(category.id, category);
      }

      return Right(categoriesList);
    } catch (e) {
      AppLogs.error('Categories Loading Error: $e');
      return Left(Failure(e.toString()));
    }
  }

  /*----- Product Operations -----*/

  Stream<Either<Failure, Product>> productDetailsStream() async* {
    try {
      final Box<Product> productBox = Hive.box<Product>('productsBox');

      // **إرسال البيانات المخزنة مؤقتًا أولًا إن وجدت**
      if (productBox.containsKey(_curProduct?.id)) {
        yield Right(productBox.get(_curProduct?.id)!);
      }

      final docRef = firestore
          .collection(ConstantManager.productCollection)
          .doc(_curProduct?.id);
      yield* docRef.snapshots().asyncMap((snapshot) async {
        try {
          if (!snapshot.exists) {
            return const Left(Failure('لم يتم العثور على المنتج'));
          }

          final Product product =
              Product.fromDoc(snapshot.id, snapshot.data()!);

          // **تحديث الكاش**
          await productBox.put(product.id, product);

          return Right(product);
        } catch (e) {
          return Left(Failure(e.toString()));
        }
      });
    } catch (e) {
      yield Left(Failure(e.toString()));
    }
  }

  Future<Either<Failure, Map<String, List<Product>>>> fetchProducts() async {
    try {
      final Box<Product> productBox = Hive.box<Product>('productsBox');

      // **إرجاع البيانات المخزنة مؤقتًا إذا كانت موجودة**
      if (productBox.isNotEmpty) {
        return Right({
          'p': productBox.values.toList(),
          'still': productBox.isNotEmpty ? [Product.empty] : [],
        });
      }

      final response = await firestore
          .collection(ConstantManager.productCollection)
          .limit(10)
          .get();

      List<Product> productsList = [];
      for (var productDoc in response.docs) {
        final marketActive =
            await isMarketActive(productDoc.data()['marketId'], productDoc.id);
        if (!marketActive) continue;
        productsList.add(Product.fromDoc(productDoc.id, productDoc.data()));
      }

      // **تحديث الكاش**
      await productBox.clear();
      for (var product in productsList) {
        await productBox.put(product.id, product);
      }

      return Right({
        'p': productsList,
        'still': productsList.isNotEmpty ? [Product.empty] : [],
      });
    } catch (e) {
      AppLogs.error('Products Loading Limiting Error: $e');
      return Left(Failure(e.toString()));
    }
  }

  Stream<Either<Failure, List<Product>>> productsStream() async* {
    try {
      final Box<Product> productBox = Hive.box<Product>('productsBox');

      // **إرسال البيانات المخزنة مؤقتًا أولًا إن وجدت**
      if (productBox.isNotEmpty) {
        yield Right(productBox.values.toList());
      }

      final query =
          firestore.collection(ConstantManager.productCollection).limit(10);

      yield* query.snapshots().asyncMap((snapshot) async {
        try {
          List<Product> productsList = [];
          for (var doc in snapshot.docs) {
            final marketActive =
                await isMarketActive(doc.data()['marketId'], doc.id);
            if (!marketActive) continue;
            productsList.add(Product.fromDoc(doc.id, doc.data()));
          }

          // **تحديث الكاش**
          await productBox.clear();
          for (var product in productsList) {
            await productBox.put(product.id, product);
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
      final Box<Product> productBox = Hive.box<Product>('productsBox');

      // **جلب المنتجات المخزنة مؤقتًا إذا كانت موجودة**
      final List<Product> cachedProducts = productBox.values
          .where((product) => product.categoryId == _curCategory?.id)
          .toList();
      if (cachedProducts.isNotEmpty) {
        return Right(cachedProducts);
      }

      final response = await firestore
          .collection(ConstantManager.productCollection)
          .where('categoryId', isEqualTo: _curCategory?.id)
          .get();

      List<Product> productsList = [];
      for (var productDoc in response.docs) {
        final marketActive =
            await isMarketActive(productDoc.data()['marketId']);
        if (!marketActive) continue;
        productsList.add(Product.fromDoc(productDoc.id, productDoc.data()));
      }

      // **تحديث الكاش**
      for (var product in productsList) {
        await productBox.put(product.id, product);
      }

      return Right(productsList);
    } catch (e) {
      AppLogs.error('Error @fetchCategoryRelatedProducts: $e');
      return Left(Failure(e.toString()));
    }
  }

  Future<Product> getProductById(String id) async {
    try {
      final Box<Product> productBox = Hive.box<Product>('productsBox');

      // **التحقق من وجود المنتج في الكاش (Hive)**
      if (productBox.containsKey(id)) {
        return productBox.get(id)!;
      }

      // **جلب المنتج من Firestore إذا لم يكن في الكاش**
      final productDoc = await firestore
          .collection(ConstantManager.productCollection)
          .doc(id)
          .get();

      if (!productDoc.exists) {
        throw const Failure("لم يتم العثور على المنتج");
      }

      final Product product =
          Product.fromDoc(productDoc.id, productDoc.data() ?? {});

      // **تحديث الكاش في Hive**
      await productBox.put(product.id, product);

      return product;
    } catch (e) {
      AppLogs.error('Error @getProductById: $e');
      throw const Failure("حدث خطأ أثناء جلب المنتج");
    }
  }

  /*----- Cart Operations -----*/

  Future<Either<Failure, Map<String, dynamic>>> fetchCart() async {
    try {
      final Box<Map> cartBox = Hive.box<Map>('cartBox');

      _price = 0;
      final storedCart =
          cartBox.get('shopping', defaultValue: {}) as Map<String, int>;
      Map<String, int> shoppingData = Map<String, int>.from(storedCart);

      if (shoppingData.isEmpty) {
        return const Right({
          'shopping': <Product, int>{},
          'price': 0.0,
        });
      }

      Map<Product, int> cartItems = {};
      for (var entry in shoppingData.entries) {
        final product = await getProductById(entry.key);
        _price += product.updatedPrice * entry.value;
        cartItems[product] = entry.value;
      }

      return Right({
        'price': _price,
        'shopping': cartItems,
      });
    } catch (e) {
      AppLogs.error('Error @fetchCart: $e');
      return const Left(Failure('حدث خطأ أثناء تحميل السلة'));
    }
  }

  Future<Either<Failure, Map<String, dynamic>>> resetCart() async {
    try {
      final Box<Map> cartBox = Hive.box<Map>('cartBox');

      _price = 0;
      _shopping = {};

      await cartBox.put('shopping', {});

      return Right({
        'price': _price,
        'shopping': const <Product, int>{},
      });
    } catch (e) {
      AppLogs.error('Error @resetCart: $e');
      return const Left(Failure('حدث خطأ أثناء إعادة تعيين السلة'));
    }
  }

  Future<Either<Failure, void>> addProductToCart(Product product) async {
    try {
      final Box<Map> cartBox = Hive.box<Map>('cartBox');

      _shopping.update(
        product.id,
        (value) => value + 1,
        ifAbsent: () => 1,
      );

      _price += product.updatedPrice;

      await cartBox.put('shopping', _shopping);

      return const Right(null);
    } catch (e) {
      AppLogs.error('Error @addProductToCart: $e');
      return const Left(Failure('حدث خطأ أثناء إضافة المنتج للسلة'));
    }
  }

  Future<Either<Failure, void>> removeProductFromCart(Product product) async {
    try {
      final Box<Map> cartBox = Hive.box<Map>('cartBox');

      if (_shopping.containsKey(product.id)) {
        _price -= product.updatedPrice * (_shopping[product.id] ?? 0);
        _shopping.remove(product.id);

        await cartBox.put('shopping', _shopping);
      }

      return const Right(null);
    } catch (e) {
      AppLogs.error('Error @removeProductFromCart: $e');
      return const Left(Failure('حدث خطأ أثناء حذف المنتج من السلة'));
    }
  }

  Future<Either<Failure, void>> increaseProductQuantityInCart(
      Product product) async {
    try {
      final Box<Map> cartBox = Hive.box<Map>('cartBox');

      _shopping.update(
        product.id,
        (value) => value + 1,
        ifAbsent: () => 1,
      );

      _price += product.updatedPrice;

      await cartBox.put('shopping', _shopping);

      return const Right(null);
    } catch (e) {
      AppLogs.error('Error @increaseProductQuantityInCart: $e');
      return const Left(Failure('حدث خطأ أثناء زيادة كمية المنتج في السلة'));
    }
  }

  Future<Either<Failure, void>> decreaseProductQuantityFromCart(
      Product product) async {
    try {
      final Box<Map> cartBox = Hive.box<Map>('cartBox');

      if (_shopping.containsKey(product.id)) {
        _price -= product.updatedPrice;
        _shopping.update(
          product.id,
          (value) => value - 1,
        );

        if (_shopping[product.id] == 0) {
          _shopping.remove(product.id);
        }

        await cartBox.put('shopping', _shopping);
      }

      return const Right(null);
    } catch (e) {
      AppLogs.error('Error @decreaseProductQuantityFromCart: $e');
      return const Left(Failure('حدث خطأ أثناء تقليل كمية المنتج من السلة'));
    }
  }

  /*----- Order Operations -----*/

  Future<List<String?>> getAdminTokens() async {
    QuerySnapshot querySnapshot = await firestore
        .collection(ConstantManager.userCollection)
        .where('userType', isEqualTo: 'admin')
        .get();
    List<String> adminTokens = [];
    for (var doc in querySnapshot.docs) {
      String? token = doc['token'];
      if (token != null) {
        adminTokens.add(token);
      }
    }
    return adminTokens;
  }

  Future<Either<Failure, Null>> placeOrder(Location location) async {
    try {
      final Box<UserOrder> ordersBox = Hive.box<UserOrder>('ordersBox');

      final seqIdDoc = firestore
          .collection(ConstantManager.ordersCollection)
          .doc(ConstantManager.orderSeqIdDoc);

      int seqIdVal = (await seqIdDoc.get()).data()?['seqId'] ?? 0;

      Map<String, List> shoppingList = {};
      for (MapEntry entry in _shopping.entries) {
        final mappedProduct = await getProductById(entry.key);
        shoppingList.putIfAbsent(
            entry.key, () => [entry.value, mappedProduct.updatedPrice]);
      }

      final orderMap = {
        'total': _price,
        'code': seqIdVal,
        'shopping': shoppingList,
        'isAd': false,
        'userId': getUserId(),
        'status': OrderStatus.pending.name,
        'createdAt': DateTime.now(),
        'location': location.toJson(),
      };

      final orderRef = await firestore.collection('orders').add(orderMap);
      await seqIdDoc.set({'seqId': seqIdVal + 1});

      _shopping.forEach((id, taken) async {
        await firestore
            .collection(ConstantManager.productCollection)
            .doc(id)
            .update({'quantity': FieldValue.increment(-taken)});
      });

      // **Store Order in Hive**
      final order = UserOrder.fromDoc(orderMap, const [], orderRef.id);
      await ordersBox.put(orderRef.id, order);

      return const Right(null);
    } catch (e) {
      AppLogs.error('Error @placeOrder: $e');
      return Left(Failure(e.toString()));
    }
  }

  Future<Either<Failure, Null>> placeAdOrder(Location location) async {
    try {
      final Box<UserOrder> ordersBox = Hive.box<UserOrder>('ordersBox');

      final seqIdDoc = firestore
          .collection(ConstantManager.ordersCollection)
          .doc(ConstantManager.orderSeqIdDoc);

      int seqIdVal = (await seqIdDoc.get()).data()?['seqId'] ?? 0;

      Map<String, List> shoppingList = {};
      for (Offer offer in _curAd!.offers) {
        shoppingList.putIfAbsent(
            offer.product.id, () => [offer.quantity, offer.price]);
      }

      final orderMap = {
        'code': seqIdVal,
        'createdAt': DateTime.now(),
        'isAd': true,
        'location': location.toJson(),
        'shopping': shoppingList,
        'status': OrderStatus.pending.name,
        'total': _curAd?.total,
        'userId': getUserId(),
      };

      final orderRef = await firestore.collection('orders').add(orderMap);
      await seqIdDoc.set({'seqId': seqIdVal + 1});

      for (var offer in _curAd!.offers) {
        await firestore
            .collection(ConstantManager.productCollection)
            .doc(offer.product.id)
            .update({'quantity': FieldValue.increment(-offer.quantity)});
      }

      // **Store Order in Hive**
      final order = UserOrder.fromDoc(orderMap, const [], orderRef.id);
      await ordersBox.put(orderRef.id, order);

      return const Right(null);
    } catch (e) {
      AppLogs.error('Error @placeAdOrder: $e');
      return Left(Failure(e.toString()));
    }
  }

  Future<Either<Failure, Null>> confirmDeliveryOrder(String orderId) async {
    try {
      final Box<UserOrder> ordersBox = Hive.box<UserOrder>('ordersBox');

      await firestore
          .collection('orders')
          .doc(orderId)
          .update({'status': OrderStatus.delivered.name});

      // **Update Order in Hive**
      if (ordersBox.containsKey(orderId)) {
        final updatedOrder = ordersBox.get(orderId)!.copyWith(
              status: OrderStatus.delivered,
            );
        await ordersBox.put(orderId, updatedOrder);
      }

      return const Right(null);
    } catch (e) {
      AppLogs.error('Error @confirmDeliveryOrder: $e');
      return Left(Failure(e.toString()));
    }
  }

  Future<Either<Failure, Null>> cancelOrder(String orderId) async {
    try {
      final Box<UserOrder> ordersBox = Hive.box<UserOrder>('ordersBox');

      final orderData =
          (await firestore.collection('orders').doc(orderId).get()).data() ??
              {};

      if (orderData['status'] == OrderStatus.shipped.name) {
        return const Left(Failure('تم شحن الطلب بالفعل'));
      }

      await firestore
          .collection('orders')
          .doc(orderId)
          .update({'status': OrderStatus.cancelled.name});

      orderData['shopping'].forEach((id, takenObj) async {
        await firestore
            .collection(ConstantManager.productCollection)
            .doc(id)
            .update({'quantity': FieldValue.increment(takenObj[0])});
      });

      // **Update Order in Hive**
      if (ordersBox.containsKey(orderId)) {
        final updatedOrder = ordersBox.get(orderId)!.copyWith(
              status: OrderStatus.cancelled,
            );
        await ordersBox.put(orderId, updatedOrder);
      }

      return const Right(null);
    } catch (e) {
      AppLogs.error('Error @cancelOrder: $e');
      return Left(Failure(e.toString()));
    }
  }

  Future<Either<Failure, Null>> refuseOrder(String orderId) async {
    try {
      final Box<UserOrder> ordersBox = Hive.box<UserOrder>('ordersBox');

      final orderData =
          (await firestore.collection('orders').doc(orderId).get()).data() ??
              {};

      await firestore
          .collection('orders')
          .doc(orderId)
          .update({'status': OrderStatus.refused.name});

      orderData['shopping'].forEach((id, takenObj) async {
        await firestore
            .collection(ConstantManager.productCollection)
            .doc(id)
            .update({'quantity': FieldValue.increment(takenObj[0])});
      });

      // **Update Order in Hive**
      if (ordersBox.containsKey(orderId)) {
        final updatedOrder = ordersBox.get(orderId)!.copyWith(
              status: OrderStatus.refused,
            );
        await ordersBox.put(orderId, updatedOrder);
      }

      return const Right(null);
    } catch (e) {
      AppLogs.error('Error @refuseOrder: $e');
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
              List<ShoppingItem> shopping = [];
              for (MapEntry entry in doc.data()['shopping'].entries) {
                final mappedProduct = await getProductById(entry.key);
                shopping.add(ShoppingItem.fromDoc(entry.value, mappedProduct));
              }
              ongoingOrderList.add(UserOrder.fromDoc(
                doc.data(),
                shopping,
                doc.id,
              ));
            }

            for (var doc in historySnapshot.docs) {
              if (doc.data()['seqId'] != null) continue;
              List<ShoppingItem> shopping = [];
              for (MapEntry entry in doc.data()['shopping'].entries) {
                final mappedProduct = await getProductById(entry.key);
                shopping.add(ShoppingItem.fromDoc(entry.value, mappedProduct));
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
      final Box<UserOrder> ordersBox = Hive.box<UserOrder>('ordersBox');

      // **Return cached orders first**
      if (ordersBox.isNotEmpty) {
        final ongoingOrders = ordersBox.values
            .where((order) =>
                order.status == OrderStatus.pending ||
                order.status == OrderStatus.shipped)
            .toList();

        final historyOrders = ordersBox.values
            .where((order) =>
                order.status == OrderStatus.cancelled ||
                order.status == OrderStatus.delivered ||
                order.status == OrderStatus.refused)
            .toList();

        return Right({
          'ongoing': ongoingOrders,
          'history': historyOrders,
        });
      }

      final results = await Future.wait([
        firestore
            .collection('orders')
            .where('userId', isEqualTo: getUserId())
            .where('status',
                whereIn: [OrderStatus.pending.name, OrderStatus.shipped.name])
            .orderBy('createdAt', descending: true)
            .get(),
        firestore
            .collection('orders')
            .where('userId', isEqualTo: getUserId())
            .where('status', whereIn: [
              OrderStatus.cancelled.name,
              OrderStatus.delivered.name,
              OrderStatus.refused.name
            ])
            .orderBy('createdAt', descending: true)
            .get(),
      ]);

      final ongoingOrders = results[0];
      final historyOrders = results[1];

      final List<UserOrder> ongoingOrderList = [];
      final List<UserOrder> historyOrderList = [];

      for (var orderDoc in ongoingOrders.docs) {
        ongoingOrderList
            .add(UserOrder.fromDoc(orderDoc.data(), const [], orderDoc.id));
      }

      for (var orderDoc in historyOrders.docs) {
        historyOrderList
            .add(UserOrder.fromDoc(orderDoc.data(), const [], orderDoc.id));
      }

      // **Update Hive Cache**
      await ordersBox.clear();
      for (var order in [...ongoingOrderList, ...historyOrderList]) {
        await ordersBox.put(order.id, order);
      }

      return Right({
        'ongoing': ongoingOrderList,
        'history': historyOrderList,
      });
    } catch (e) {
      AppLogs.error('Error @fetchOrders: $e');
      return Left(Failure(e.toString()));
    }
  }

  /*----- Ads Operations -----*/

  Stream<Either<Failure, List<Ad>>> adsStream() async* {
    try {
      final Box<Ad> adsBox = Hive.box<Ad>('adsBox');

      // **Yield cached ads first**
      if (adsBox.isNotEmpty) {
        yield Right(adsBox.values.toList());
      }

      final query = firestore.collection(ConstantManager.adsCollection);

      yield* query.snapshots().asyncMap((snapshot) async {
        try {
          List<Ad> adsList = [];
          for (var adDoc in snapshot.docs) {
            List<Offer> offers = [];
            for (var offerObj in adDoc.data()['offers']) {
              final offerProduct = await getProductById(offerObj['productId']);
              offers.add(Offer.fromDoc(offerObj, offerProduct));
            }
            adsList.add(Ad.fromDoc(adDoc.id, offers, adDoc.data()));
          }

          // **Update Hive cache**
          await adsBox.clear();
          for (var ad in adsList) {
            await adsBox.put(ad.id, ad);
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
      final Box<Ad> adsBox = Hive.box<Ad>('adsBox');

      // **Return cached ads first**
      if (adsBox.isNotEmpty) {
        return Right(adsBox.values.toList());
      }

      final response =
          await firestore.collection(ConstantManager.adsCollection).get();

      List<Ad> adsList = [];
      for (var adDoc in response.docs) {
        List<Offer> offers = [];
        for (var offerObj in adDoc.data()['offers']) {
          final offerProduct = await getProductById(offerObj['productId']);
          offers.add(Offer.fromDoc(offerObj, offerProduct));
        }
        adsList.add(Ad.fromDoc(adDoc.id, offers, adDoc.data()));
      }

      // **Update Hive cache**
      await adsBox.clear();
      for (var ad in adsList) {
        await adsBox.put(ad.id, ad);
      }

      return Right(adsList);
    } catch (e) {
      AppLogs.error('Error @fetchAds: $e');
      return Left(Failure(e.toString()));
    }
  }

  Stream<Either<Failure, Ad>> adDetailsStream() async* {
    try {
      final Box<Ad> adsBox = Hive.box<Ad>('adsBox');

      // **Yield cached ad details first**
      if (adsBox.containsKey(_curAd?.id)) {
        yield Right(adsBox.get(_curAd?.id)!);
      }

      final docRef =
          firestore.collection(ConstantManager.adsCollection).doc(_curAd?.id);

      yield* docRef.snapshots().asyncMap((snapshot) async {
        try {
          if (!snapshot.exists) {
            return const Left(Failure('لم يتم العثور على الإعلان'));
          }

          List<Offer> offers = [];
          for (var offerDoc in snapshot.data()!['offers']) {
            final offerProduct = await getProductById(offerDoc['productId']);
            offers.add(Offer.fromDoc(offerDoc, offerProduct));
          }

          final ad = Ad.fromDoc(snapshot.id, offers, snapshot.data()!);

          // **Update Hive cache**
          await adsBox.put(ad.id, ad);

          return Right(ad);
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
      final Box<Product> productsBox = Hive.box<Product>('productsBox');

      // **Check if products are already cached in Hive**
      final List<Product> cachedProducts = productsBox.values
          .where((product) =>
              product.name.toLowerCase().contains(productName.toLowerCase()))
          .toList();

      if (cachedProducts.isNotEmpty) {
        return Right(cachedProducts);
      }

      // **If not found in Hive, fetch from Firestore**
      final searchResults = await firestore
          .collection(ConstantManager.productCollection)
          .where(
            'name',
            isGreaterThanOrEqualTo: productName,
            isLessThanOrEqualTo: '$productName\uf8ff',
          )
          .get();

      final List<Product> searchProductList = [];
      for (var result in searchResults.docs) {
        final product = Product.fromDoc(result.id, result.data());
        searchProductList.add(product);

        // **Cache the product in Hive**
        await productsBox.put(product.id, product);
      }

      return Right(searchProductList);
    } catch (e) {
      AppLogs.error('Error @searchForProductByName: $e');
      return Left(Failure(e.toString()));
    }
  }
}
