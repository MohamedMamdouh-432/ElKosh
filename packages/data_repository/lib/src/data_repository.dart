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
  bool isThereOtherThread;

  DataRepository({
    required this.firestore,
    required this.fireStorage,
    required this.sharedPref,
  })  : _price = 0,
        _shopping = {},
        isThereOtherThread = false;

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
      if (marketBox.isNotEmpty) {
        AppLogs.debug('Fetching Markets from Cache ...');
        yield Right(marketBox.values.toList());
      }
      AppLogs.debug('Fetching Markets from Firebase ...');
      final query = firestore.collection(ConstantManager.marketCollection);
      yield* query.snapshots().asyncMap((snapshot) async {
        try {
          List<Market> marketsList = [];
          for (var doc in snapshot.docs) {
            if (doc.data()['active'] == false) continue;
            marketsList.add(Market.fromDoc(doc.id, doc.data()));
          }
          await marketBox.clear();
          for (Market market in marketsList)
            await marketBox.put(market.id, market);
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
      if (marketBox.containsKey(_curMarket?.id)) {
        AppLogs.debug('Fetching Market Details from Cache ...');
        yield Right(marketBox.get(_curMarket?.id)!);
      }
      AppLogs.debug('Fetching Market Details from Firebase ...');
      final docRef = firestore
          .doc('${ConstantManager.marketCollection}/${_curMarket?.id}');
      yield* docRef.snapshots().asyncMap((snapshot) async {
        try {
          if (!snapshot.exists)
            return const Left(Failure('لم يتم العثور على هذا المتجر'));
          final Market market = Market.fromDoc(snapshot.id, snapshot.data()!);
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
      if (marketBox.isNotEmpty) {
        AppLogs.debug('Fetching Markets from Cache ...');
        return Right(marketBox.values.toList());
      }
      AppLogs.debug('Fetching Markets from Firebase ...');
      final response =
          await firestore.collection(ConstantManager.marketCollection).get();
      List<Market> marketsList = [];
      for (var marketDoc in response.docs) {
        if (marketDoc.data()['active'] == false) continue;
        marketsList.add(Market.fromDoc(marketDoc.id, marketDoc.data()));
      }

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
      if (marketBox.containsKey(id)) {
        return marketBox.get(id)!.active;
      }
      final marketDoc =
          await firestore.doc('${ConstantManager.marketCollection}/$id').get();
      if (!marketDoc.exists) {
        AppLogs.debug('Market $id Not Found');
        return false;
      }
      final Market market = Market.fromDoc(id, marketDoc.data()!);
      await marketBox.put(market.id, market);
      return marketDoc.data()?['active'] ?? false;
    } catch (e) {
      AppLogs.error('Error @isMarketActive: $e');
      throw const Failure("حدث خطأ أثناء جلب المتجر");
    }
  }

  /*----- Category Operations -----*/

  Stream<Either<Failure, List<Category>>> categorysStream() async* {
    try {
      final Box<Category> categoryBox = Hive.box<Category>('categoriesBox');
      if (categoryBox.isNotEmpty) {
        AppLogs.debug('Fetching Categories from Cache ...');
        List<Category> categories = categoryBox.values
            .where((cat) => cat.marketId == _curMarket?.id)
            .toList();
        yield Right(categories);
      }
      AppLogs.debug('Fetching Categories from Firebase ...');
      final query = firestore
          .collection(ConstantManager.categoryCollection)
          .where('marketId', isEqualTo: _curMarket?.id)
          .orderBy('orderId');

      yield* query.snapshots().asyncMap((snapshot) async {
        try {
          List<Category> categoriesList = [];
          for (var doc in snapshot.docs)
            categoriesList.add(Category.fromDoc(doc.id, doc.data()));
          await categoryBox.clear();
          for (var category in categoriesList)
            await categoryBox.put(category.id, category);
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
      if (categoryBox.isNotEmpty) {
        AppLogs.debug('Fetching Categories from Cache ...');
        List<Category> categories = categoryBox.values
            .where((cat) => cat.marketId == _curMarket?.id)
            .toList();
        return Right(categories);
      }
      AppLogs.debug('Fetching Categories from Firebase ...');
      final response = await firestore
          .collection(ConstantManager.categoryCollection)
          .where('marketId', isEqualTo: _curMarket?.id)
          .orderBy('orderId')
          .get();

      List<Category> categoriesList = [];
      for (var doc in response.docs)
        categoriesList.add(Category.fromDoc(doc.id, doc.data()));
      await categoryBox.clear();
      for (var category in categoriesList)
        await categoryBox.put(category.id, category);
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
      if (productBox.containsKey(_curProduct?.id)) {
        AppLogs.debug('Fetching Product from Cache ...');
        yield Right(productBox.get(_curProduct?.id)!);
      }
      AppLogs.debug('Fetching Product from Firebase ...');
      final docRef = firestore
          .doc('${ConstantManager.productCollection}/${_curProduct?.id}');
      yield* docRef.snapshots().asyncMap((snapshot) async {
        try {
          if (!snapshot.exists)
            return const Left(Failure('لم يتم العثور على المنتج'));
          final Product product =
              Product.fromDoc(snapshot.id, snapshot.data()!);
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

  Future<Either<Failure, Map<String, dynamic>>> fetchProducts(
      int curLength) async {
    if (isThereOtherThread) {
      AppLogs.debug('fetchProducts already in progress, skipping...');
      return Right({
        'skip': true,
        'data': List<Product>.from([]),
      });
    }

    isThereOtherThread = true;

    try {
      final Box<Product> productBox = Hive.box<Product>('productsBox');
      // await productBox.clear();
      if (productBox.length > curLength) {
        AppLogs.debug('Fetching ${productBox.length} Products from Cache...');
        return Right({
          'skip': false,
          'data': productBox.values.toList(),
        });
      }

      AppLogs.debug('Fetching Products from Firebase...');
      Query query =
          firestore.collection(ConstantManager.productCollection).limit(10);

      if (productBox.isNotEmpty) {
        final lastProduct = productBox.values.last;
        final lastDocSnapshot = await firestore
            .collection(ConstantManager.productCollection)
            .doc(lastProduct.id)
            .get();
        if (lastDocSnapshot.exists) {
          query = query.startAfterDocument(lastDocSnapshot);
        }
      }

      final response = await query.get();

      if (response.docs.isEmpty) {
        AppLogs.debug('No more products to load.');
        return Right({
          'skip': false,
          'data': List<Product>.from([]),
        });
      }

      List<Product> productsList = [];
      for (var productDoc in response.docs) {
        final data = productDoc.data();
        if (data == null) continue;

        final marketActive = await isMarketActive(
            (data as Map<String, dynamic>)['marketId'], productDoc.id);
        if (!marketActive) continue;

        final product = Product.fromDoc(productDoc.id, data);
        productsList.add(product);
        await productBox.put(product.id, product);
      }

      return Right({
        'skip': false,
        'data': productsList,
      });
    } catch (e, stackTrace) {
      AppLogs.error('Error @fetching products: $e\n$stackTrace');
      return Left(Failure(e.toString()));
    } finally {
      isThereOtherThread = false;
    }
  }

  Stream<Either<Failure, Map<String, dynamic>>> productsStream(
      int curLength) async* {
    if (isThereOtherThread) {
      AppLogs.debug('@productsStream: There is another thread in progress, skipping...');
      yield Right({
        'skip': true,
        'data': List<Product>.from([]),
      });
    }

    isThereOtherThread = true;

    try {
      final Box<Product> productBox = Hive.box<Product>('productsBox');
      // await productBox.clear();
      if (productBox.length > curLength) {
        AppLogs.debug('Fetching ${productBox.length} Products from Cache ...');
        yield Right({
          'skip': false,
          'data': productBox.values.toList(),
        });
      }
      AppLogs.debug('Fetching Products from Firebase ...');
      Query query =
          firestore.collection(ConstantManager.productCollection).limit(10);
      if (productBox.isNotEmpty) {
        final lastProduct = productBox.values.last;
        final lastDocSnapshot = await firestore
            .collection(ConstantManager.productCollection)
            .doc(lastProduct.id)
            .get();
        if (lastDocSnapshot.exists) {
          query = query.startAfterDocument(lastDocSnapshot);
        }
      }

      yield* query.snapshots().asyncMap((snapshot) async {
        try {
          if (snapshot.docs.isEmpty) {
            AppLogs.debug('No more products to load.');
            return Right({
              'skip': false,
              'data': List<Product>.from([]),
            });
          }
          List<Product> productsList = [];
          for (var productDoc in snapshot.docs) {
            final data = productDoc.data();
            if (data == null) continue;

            final marketActive = await isMarketActive(
                (data as Map<String, dynamic>)['marketId'], productDoc.id);
            if (!marketActive) continue;

            final product = Product.fromDoc(productDoc.id, data);
            productsList.add(product);
            await productBox.put(product.id, product);
          }

          return Right({
            'skip': false,
            'data': productsList,
          });
        } catch (e) {
          return Left(Failure(e.toString()));
        }
      });
    } catch (e, stackTrace) {
      AppLogs.error('Error @fetching products: $e\n$stackTrace');
      yield Left(Failure(e.toString()));
    } finally {
      isThereOtherThread = false;
    }
  }

  Future<Either<Failure, List<Product>>> fetchCategoryRelatedProducts() async {
    try {
      final Box<Product> productBox = Hive.box<Product>('productsBox');
      final productsCount = await firestore
          .collection(ConstantManager.productCollection)
          .count()
          .get();
      if (productBox.values.length == productsCount.count) {
        final List<Product> products = productBox.values
            .where((product) => product.categoryId == _curCategory?.id)
            .toList();
        return Right(products);
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
      for (var product in productsList)
        await productBox.put(product.id, product);
      return Right(productsList);
    } catch (e) {
      AppLogs.error('Error @fetchCategoryRelatedProducts: $e');
      return Left(Failure(e.toString()));
    }
  }

  Future<Product> getProductById(String id) async {
    try {
      final Box<Product> productBox = Hive.box<Product>('productsBox');
      if (productBox.containsKey(id)) {
        AppLogs.debug('Fetching Product from Cache ...');
        return productBox.get(id)!;
      }
      AppLogs.debug('Fetching Product from Firebase ...');
      final productDoc =
          await firestore.doc('${ConstantManager.productCollection}/$id').get();
      if (!productDoc.exists) return Product.empty;
      final Product product =
          Product.fromDoc(productDoc.id, productDoc.data() ?? {});
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
      final rawShoppingData = cartBox.get('shopping', defaultValue: {});
      final Map<String, int> shoppingData = rawShoppingData?.map(
            (key, value) => MapEntry(key.toString(), (value as num).toInt()),
          ) ??
          {};

      if (shoppingData.isEmpty) {
        _shopping = {};
        return const Right({
          'shopping': <Product, int>{},
          'price': 0.0,
        });
      }

      Map<Product, int> cartItems = {};
      for (MapEntry<String, int> entry in shoppingData.entries) {
        final product = await getProductById(entry.key);
        _price += product.updatedPrice * entry.value;
        cartItems.putIfAbsent(product, () => entry.value);
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
      _price = 0;
      _shopping = {};
      final Box<Map> cartBox = Hive.box<Map>('cartBox');
      await cartBox.put('shopping', _shopping);
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
      _price += product.updatedPrice;
      _shopping.update(
        product.id,
        (value) => value + 1,
        ifAbsent: () => 1,
      );
      final Box<Map> cartBox = Hive.box<Map>('cartBox');
      await cartBox.put('shopping', _shopping);
      return const Right(null);
    } catch (e) {
      AppLogs.error('Error @addProductToCart: $e');
      return const Left(Failure('حدث خطأ أثناء إضافة المنتج للسلة'));
    }
  }

  Future<Either<Failure, void>> removeProductFromCart(Product product) async {
    try {
      if (_shopping.containsKey(product.id)) {
        _price -= product.updatedPrice * (_shopping[product.id] ?? 0);
        _shopping.remove(product.id);
        final Box<Map> cartBox = Hive.box<Map>('cartBox');
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
      _price += product.updatedPrice;
      _shopping.update(
        product.id,
        (value) => value + 1,
        ifAbsent: () => 1,
      );
      final Box<Map> cartBox = Hive.box<Map>('cartBox');
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
      if (_shopping.containsKey(product.id)) {
        _price -= product.updatedPrice;
        _shopping.update(
          product.id,
          (value) => value - 1,
        );
        if (_shopping[product.id] == 0) _shopping.remove(product.id);
        final Box<Map> cartBox = Hive.box<Map>('cartBox');
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
      final seqIdDoc = firestore.doc(
          '${ConstantManager.ordersCollection}/${ConstantManager.orderSeqIdDoc}');
      final seqIdDocData = await seqIdDoc.get();
      int seqIdVal = 1;
      if (seqIdDocData.exists) seqIdVal = seqIdDocData.data()?['seqId'];
      Map<String, List> shoppingList = {};
      for (MapEntry<String, int> entry in _shopping.entries) {
        final product = await getProductById(entry.key);
        shoppingList.putIfAbsent(
            entry.key, () => [entry.value, product.updatedPrice]);
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
      await firestore
          .collection(ConstantManager.ordersCollection)
          .add(orderMap);
      await seqIdDoc.set({'seqId': seqIdVal + 1});
      _shopping.forEach((id, taken) async {
        await firestore
            .doc('${ConstantManager.productCollection}/$id')
            .update({'quantity': FieldValue.increment(-taken)});
      });
      return const Right(null);
    } catch (e) {
      AppLogs.error('Error @placeOrder: $e');
      return Left(Failure(e.toString()));
    }
  }

  Future<Either<Failure, Null>> placeAdOrder(Location location) async {
    try {
      final seqIdDoc = firestore.doc(
          '${ConstantManager.ordersCollection}/${ConstantManager.orderSeqIdDoc}');
      final seqIdDocData = await seqIdDoc.get();
      int seqIdVal = 1;
      if (seqIdDocData.exists) seqIdVal = seqIdDocData.data()?['seqId'];
      Map<String, List> shoppingList = {};
      for (Offer offer in _curAd!.offers)
        shoppingList.putIfAbsent(
          offer.product.id,
          () => [offer.quantity, offer.price],
        );
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
      await firestore
          .collection(ConstantManager.ordersCollection)
          .add(orderMap);
      await seqIdDoc.set({'seqId': seqIdVal + 1});
      for (var offer in _curAd!.offers)
        await firestore
            .doc('${ConstantManager.productCollection}/${offer.product.id}')
            .update({'quantity': FieldValue.increment(-offer.quantity)});
      return const Right(null);
    } catch (e) {
      AppLogs.error('Error @placeAdOrder: $e');
      return Left(Failure(e.toString()));
    }
  }

  Stream<Either<Failure, Map<String, List<UserOrder>>>> ordersStream() async* {
    try {
      final Box<UserOrder> ordersBox = Hive.box<UserOrder>('ordersBox');
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

        yield Right({
          'ongoing': ongoingOrders,
          'history': historyOrders,
        });
      }

      final userId = getUserId();
      final ongoingOrdersStream = firestore
          .collection(ConstantManager.ordersCollection)
          .where('userId', isEqualTo: userId)
          .where('status', whereIn: ['pending', 'shipped'])
          .orderBy('createdAt', descending: true)
          .snapshots();

      final historyOrdersStream = firestore
          .collection(ConstantManager.ordersCollection)
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
                final product = await getProductById(entry.key);
                shopping.add(ShoppingItem.fromDoc(entry.value, product));
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
                final product = await getProductById(entry.key);
                if (product == Product.empty) continue;
                shopping.add(ShoppingItem.fromDoc(entry.value, product));
              }
              historyOrderList.add(UserOrder.fromDoc(
                doc.data(),
                shopping,
                doc.id,
              ));
            }

            await ordersBox.clear();
            for (var order in [...ongoingOrderList, ...historyOrderList])
              await ordersBox.put(order.id, order);

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
            .collection(ConstantManager.ordersCollection)
            .where('userId', isEqualTo: getUserId())
            .where('status',
                whereIn: [OrderStatus.pending.name, OrderStatus.shipped.name])
            .orderBy('createdAt', descending: true)
            .get(),
        firestore
            .collection(ConstantManager.ordersCollection)
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

      for (var doc in ongoingOrders.docs) {
        if (doc.data()['seqId'] != null) continue;
        List<ShoppingItem> shopping = [];
        for (MapEntry entry in doc.data()['shopping'].entries) {
          final product = await getProductById(entry.key);
          shopping.add(ShoppingItem.fromDoc(entry.value, product));
        }
        ongoingOrderList.add(UserOrder.fromDoc(
          doc.data(),
          shopping,
          doc.id,
        ));
      }
      for (var doc in historyOrders.docs) {
        if (doc.data()['seqId'] != null) continue;
        List<ShoppingItem> shopping = [];
        for (MapEntry entry in doc.data()['shopping'].entries) {
          final product = await getProductById(entry.key);
          if (product == Product.empty) continue;
          shopping.add(ShoppingItem.fromDoc(entry.value, product));
        }
        historyOrderList.add(UserOrder.fromDoc(
          doc.data(),
          shopping,
          doc.id,
        ));
      }

      await ordersBox.clear();
      for (var order in [...ongoingOrderList, ...historyOrderList])
        await ordersBox.put(order.id, order);

      return Right({
        'ongoing': ongoingOrderList,
        'history': historyOrderList,
      });
    } catch (e) {
      AppLogs.error('Error @fetchOrders: $e');
      return Left(Failure(e.toString()));
    }
  }

  Future<Either<Failure, Null>> confirmDeliveryOrder(String orderId) async {
    try {
      final Box<UserOrder> ordersBox = Hive.box<UserOrder>('ordersBox');
      await firestore
          .doc('${ConstantManager.ordersCollection}/$orderId')
          .update({'status': OrderStatus.delivered.name});
      if (ordersBox.containsKey(orderId)) {
        final updatedOrder =
            ordersBox.get(orderId)!.copyWith(status: OrderStatus.delivered);
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
      if (ordersBox.containsKey(orderId)) {
        final order = ordersBox.get(orderId)!;
        if (order.status == OrderStatus.shipped)
          return const Left(Failure('تم شحن الطلب بالفعل'));
        await ordersBox.put(
            orderId, order.copyWith(status: OrderStatus.cancelled));
        await firestore
            .doc('${ConstantManager.ordersCollection}/$orderId')
            .update({'status': OrderStatus.cancelled.name});
        final Box<Product> productsBox = Hive.box<Product>('productsBox');
        order.shopping.forEach((shopItem) async {
          final p = productsBox.get(shopItem.product.id)!;
          await productsBox.put(shopItem.product.id,
              p.copyWith(quantity: p.quantity + shopItem.quantity));
          await firestore
              .collection(ConstantManager.productCollection)
              .doc(shopItem.product.id)
              .update({'quantity': FieldValue.increment(shopItem.quantity)});
        });
      } else {
        final orderData = await firestore
            .doc('${ConstantManager.ordersCollection}/$orderId')
            .get();
        if (orderData.data()?['status'] == OrderStatus.shipped.name)
          return const Left(Failure('تم شحن الطلب بالفعل'));
        List<ShoppingItem> shoppingItems = [];
        for (MapEntry entry in orderData.data()?['shopping'].entries) {
          final product = await getProductById(entry.key);
          shoppingItems.add(ShoppingItem.fromDoc(entry.value, product));
        }
        final order = UserOrder.fromDoc(
          orderData.data()!,
          shoppingItems,
          orderData.id,
        ).copyWith(status: OrderStatus.cancelled);
        await ordersBox.put(order.id, order);
        await firestore
            .doc('${ConstantManager.ordersCollection}/$orderId')
            .update({'status': OrderStatus.cancelled.name});
        final Box<Product> productsBox = Hive.box<Product>('productsBox');
        orderData['shopping'].forEach((id, takenObj) async {
          final p = productsBox.get(id)!;
          await productsBox.put(
              id, p.copyWith(quantity: p.quantity + takenObj[0]));
          await firestore
              .doc('${ConstantManager.productCollection}/$id')
              .update({'quantity': FieldValue.increment(takenObj[0])});
        });
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
      if (ordersBox.containsKey(orderId)) {
        final order = ordersBox.get(orderId)!;
        await ordersBox.put(
            orderId, order.copyWith(status: OrderStatus.refused));
        await firestore
            .doc('${ConstantManager.ordersCollection}/$orderId')
            .update({'status': OrderStatus.refused.name});
        final Box<Product> productsBox = Hive.box<Product>('productsBox');
        order.shopping.forEach((shopItem) async {
          final p = productsBox.get(shopItem.product.id)!;
          await productsBox.put(shopItem.product.id,
              p.copyWith(quantity: p.quantity + shopItem.quantity));
          await firestore
              .doc(
                  '${ConstantManager.productCollection}/${shopItem.product.id}')
              .update({'quantity': FieldValue.increment(shopItem.quantity)});
        });
      } else {
        final orderData = await firestore
            .doc('${ConstantManager.ordersCollection}/$orderId')
            .get();
        List<ShoppingItem> shoppingItems = [];
        for (MapEntry entry in orderData.data()?['shopping'].entries) {
          final product = await getProductById(entry.key);
          shoppingItems.add(ShoppingItem.fromDoc(entry.value, product));
        }
        final order = UserOrder.fromDoc(
          orderData.data()!,
          shoppingItems,
          orderData.id,
        ).copyWith(status: OrderStatus.refused);
        await ordersBox.put(order.id, order);
        await firestore
            .doc('${ConstantManager.ordersCollection}/$orderId')
            .update({'status': OrderStatus.refused.name});
        final Box<Product> productsBox = Hive.box<Product>('productsBox');
        orderData['shopping'].forEach((id, takenObj) async {
          final p = productsBox.get(id)!;
          await productsBox.put(
              id, p.copyWith(quantity: p.quantity + takenObj[0]));
          await firestore
              .doc('${ConstantManager.productCollection}/$id')
              .update({'quantity': FieldValue.increment(takenObj[0])});
        });
      }
      return const Right(null);
    } catch (e) {
      AppLogs.error('Error @cancelOrder: $e');
      return Left(Failure(e.toString()));
    }
  }

  /*----- Ads Operations -----*/

  Stream<Either<Failure, List<Ad>>> adsStream() async* {
    try {
      final Box<Ad> adsBox = Hive.box<Ad>('adsBox');
      if (adsBox.isNotEmpty) {
        AppLogs.debug('Fetching Ads from Cache ...');
        yield Right(adsBox.values.toList());
      }
      AppLogs.debug('Fetching Ads from Firebase ...');
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
          await adsBox.clear();
          for (var ad in adsList) await adsBox.put(ad.id, ad);
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
      if (adsBox.isNotEmpty) {
        AppLogs.debug('Fetching Ads from Cache ...');
        return Right(adsBox.values.toList());
      }
      AppLogs.debug('Fetching Ads from Firebase ...');
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
      await adsBox.clear();
      for (var ad in adsList) await adsBox.put(ad.id, ad);
      return Right(adsList);
    } catch (e) {
      AppLogs.error('Error @fetchAds: $e');
      return Left(Failure(e.toString()));
    }
  }

  Stream<Either<Failure, Ad>> adDetailsStream() async* {
    try {
      final Box<Ad> adsBox = Hive.box<Ad>('adsBox');
      if (adsBox.containsKey(_curAd?.id)) {
        AppLogs.debug('Fetching Ad from Cache ...');
        yield Right(adsBox.get(_curAd?.id)!);
      }
      AppLogs.debug('Fetching Ad from Firebase ...');
      final docRef =
          firestore.doc('${ConstantManager.adsCollection}/${_curAd?.id}');

      yield* docRef.snapshots().asyncMap((snapshot) async {
        try {
          if (!snapshot.exists)
            return const Left(Failure('لم يتم العثور على الإعلان'));
          List<Offer> offers = [];
          for (var offerDoc in snapshot.data()!['offers']) {
            final offerProduct = await getProductById(offerDoc['productId']);
            offers.add(Offer.fromDoc(offerDoc, offerProduct));
          }
          final ad = Ad.fromDoc(snapshot.id, offers, snapshot.data()!);
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

  Future<Either<Failure, List<Product>>> searchForProduct(
      String productName) async {
    try {
      final Box<Product> productsBox = Hive.box<Product>('productsBox');
      final List<Product> cachedProducts = productsBox.values
          .where((product) =>
              product.name.toLowerCase().contains(productName.toLowerCase()))
          .toList();
      if (cachedProducts.isNotEmpty) {
        AppLogs.debug('Fetching Products from Cache ...');
        return Right(cachedProducts);
      }
      AppLogs.debug('Fetching Products from Firebase ...');
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
        await productsBox.put(product.id, product);
      }
      return Right(searchProductList);
    } catch (e) {
      AppLogs.error('Error @searchForProductByName: $e');
      return Left(Failure(e.toString()));
    }
  }
}
