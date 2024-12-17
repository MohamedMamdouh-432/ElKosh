import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:either_dart/either.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:models_repository/models_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DataRepository {
  final FirebaseFirestore firestore;
  final FirebaseStorage fireStorage;
  final SharedPreferences sharedPref;
  Market? _selctedMarket;
  Category? _selectedCategory;
  Product? _selectedProduct;
  Offer? _selectedOffer;
  UserOrder? _selectedOrder;
  double _price;
  String? _marketId, _marketName;
  Map<String, int> _shopping;

  DataRepository({
    required this.firestore,
    required this.fireStorage,
    required this.sharedPref,
  })  : _marketId = '',
        _marketName = '',
        _price = 0,
        _shopping = {};

  String getUserId() => sharedPref.getString('userId') ?? '';
  Market? getCurMarket() => _selctedMarket;
  Category? getCurCategory() => _selectedCategory;
  Product? getCurProduct() => _selectedProduct;
  Offer? getCurOffer() => _selectedOffer;
  UserOrder? getCurOrder() => _selectedOrder;
  void setCurMarket(Market market) => _selctedMarket = market;
  void setCurCategory(Category category) => _selectedCategory = category;
  void setCurProduct(Product product) => _selectedProduct = product;
  void setCurOffer(Offer offer) => _selectedOffer = offer;
  void setCurOrder(UserOrder order) => _selectedOrder = order;

  Stream<Either<Failure, List<Market>>> marketsStream() async* {
    try {
      final query = firestore.collection('markets');
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
      final docRef = firestore.collection('markets').doc(_selctedMarket?.id);
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
      final response = await firestore.collection('markets').get();
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

  Stream<Either<Failure, List<Category>>> categorysStream() async* {
    try {
      final query = firestore
          .collection('categories')
          .where('marketId', isEqualTo: _selctedMarket?.id);
      yield* query.snapshots().asyncMap((snapshot) async {
        try {
          List<Category> categorysList = [];
          for (var doc in snapshot.docs) {
            if (doc.data()['active'] == false) continue;
            categorysList.add(Category.fromDoc(doc.id, doc.data()));
          }
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
          .collection('categories')
          .where('marketId', isEqualTo: _selctedMarket?.id)
          .get();
      List<Category> categoriesList = [];
      for (var categoryDoc in response.docs) {
        if (categoryDoc.data()['active'] == false) continue;
        categoriesList
            .add(Category.fromDoc(categoryDoc.id, categoryDoc.data()));
      }
      return Right(categoriesList);
    } catch (e) {
      log(e.toString());
      return Left(Failure(e.toString()));
    }
  }

  Stream<Either<Failure, Market>> productDetailsStream() async* {
    try {
      final docRef = firestore.collection('markets').doc(_selctedMarket?.id);
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

  Future<Either<Failure, List<Product>>> fetchProducts(int? limits) async {
    try {
      final response = limits != null
          ? await firestore.collection('products').limit(limits).get()
          : await firestore.collection('products').get();
      List<Product> productsList = [];
      for (var productDoc in response.docs) {
        final parentMarketActive =
            (await getMarketInfo(productDoc.data()['marketId'])).value;
        if (!parentMarketActive ||
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
      final query = firestore.collection('products');
      yield* query.snapshots().asyncMap((snapshot) async {
        try {
          List<Product> productsList = [];
          for (var doc in snapshot.docs) {
            final parentMarketActive =
                (await getMarketInfo(doc.data()['marketId'])).value;
            if (!parentMarketActive ||
                doc.data()['quantity'].toDouble().floor() == 0) {
              continue;
            }
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
          .collection('products')
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

  Future<Product> fetchProductById(String id) async {
    try {
      final productDoc = await firestore.collection('products').doc(id).get();
      return Product.fromDoc(productDoc.id, productDoc.data() ?? {});
    } catch (e) {
      log(e.toString());
      throw const Failure("حدث خطأ أثناء جلب المنتج");
    }
  }

  Future<MapEntry<String, bool>> getMarketInfo(String id) async {
    try {
      final marketDoc = await firestore.collection('markets').doc(id).get();
      return MapEntry(marketDoc.data()?['name'], marketDoc.data()?['active']);
    } catch (e) {
      log(e.toString());
      throw const Failure("حدث خطأ أثناء جلب المتجر");
    }
  }

  Future<Either<Failure, Map<String, dynamic>>> fetchCart() async {
    try {
      String? cartMap = sharedPref.getString('shopping');
      if (cartMap == null) {
        _price = 0;
        _shopping = {};
        await sharedPref.setDouble('price', _price);
        await sharedPref.setString('shopping', json.encode(_shopping));
        await sharedPref.setString('marketId', '');
        await sharedPref.setString('marketName', '');
        return const Right({
          'shopping': <Product, int>{},
          'price': 0.0,
          'marketId': '',
          'marketName': '',
        });
      }
      _price = sharedPref.getDouble('price') ?? 0;
      _marketId = sharedPref.getString('marketId');
      _marketName = sharedPref.getString('marketName');
      Map<String, dynamic> decShopping = json.decode(cartMap);
      Map<Product, int> shoppingData = {};
      _shopping = decShopping.map((id, cnt) => MapEntry(id, cnt as int));
      for (MapEntry<String, int> entry in _shopping.entries) {
        final mappedProduct = await fetchProductById(entry.key);
        shoppingData.putIfAbsent(mappedProduct, () => entry.value);
      }
      return Right({
        'price': _price,
        'shopping': shoppingData,
        'marketId': _marketId,
        'marketName': _marketName,
      });
    } catch (e) {
      log(e.toString());
      return const Left(Failure('حدث خطأ أثناء تحميل السله'));
    }
  }

  Future<Either<Failure, Map<String, dynamic>>> resetCart() async {
    _price = 0;
    _shopping = {};
    _marketId = _marketName = '';
    try {
      await sharedPref.setDouble('price', _price);
      await sharedPref.setString('shopping', json.encode(_shopping));
      await sharedPref.setString('marketId', '');
      await sharedPref.setString('marketName', '');
      return Right({
        'price': _price,
        'shopping': const <Product, int>{},
        'marketId': _marketId,
        'marketName': _marketName,
      });
    } catch (e) {
      log(e.toString());
      return const Left(Failure('حدث خطأ أثناء اعادة السله'));
    }
  }

  Future<Either<Failure, Map<String, String>>> addProductToCart(
    Product product,
  ) async {
    try {
      if (_shopping.isEmpty) {
        _marketId = product.marketId;
        _marketName = (await getMarketInfo(_marketId ?? '')).key;
      } else if (_marketId != product.marketId)
        return const Left(Failure("يجب ان تشترى من نفس المتجر"));
      _price +=
          product.updatedPrice == 0 ? product.price : product.updatedPrice;
      _shopping.update(
        product.id,
        (value) => value + 1,
        ifAbsent: () => 1,
      );
      await sharedPref.setDouble('price', _price);
      await sharedPref.setString('shopping', json.encode(_shopping));
      await sharedPref.setString('marketId', _marketId ?? '');
      await sharedPref.setString('marketName', _marketName ?? '');
      return Right({
        'marketId': _marketId ?? '',
        'marketName': _marketName ?? '',
      });
    } catch (e) {
      log(e.toString());
      return const Left(Failure('حدث خطأ أثناء اضافة المنتج للسله'));
    }
  }

  Future<Either<Failure, Map<String, String>>> removeProductFromCart(
    Product product,
  ) async {
    try {
      if (_shopping.containsKey(product.id)) {
        _price -=
            (product.updatedPrice == 0 ? product.price : product.updatedPrice) *
                (_shopping[product.id] ?? 0);
        _shopping.remove(product.id);
        if (_shopping.isEmpty) {
          _marketId = '';
          _marketName = '';
        }
        await sharedPref.setDouble('price', _price);
        await sharedPref.setString('shopping', json.encode(_shopping));
        await sharedPref.setString('marketId', _marketId ?? '');
        await sharedPref.setString('marketName', _marketName ?? '');
      }
      return Right({
        'marketId': _marketId ?? '',
        'marketName': _marketName ?? '',
      });
    } catch (e) {
      log(e.toString());
      return const Left(Failure('حدث خطأ أثناء حذف المنتج من السله'));
    }
  }

  Future<Either<Failure, Map<String, String>>> increaseProductQuantityInCart(
    Product product,
  ) async {
    try {
      if (_shopping.isEmpty) {
        _marketId = product.marketId;
        _marketName = (await getMarketInfo(_marketId ?? '')).key;
      } else if (_marketId != product.marketId)
        return const Left(Failure("يجب ان تشترى من نفس المتجر"));
      _price +=
          product.updatedPrice == 0 ? product.price : product.updatedPrice;
      _shopping.update(
        product.id,
        (value) => value + 1,
        ifAbsent: () => 1,
      );
      await sharedPref.setDouble('price', _price);
      await sharedPref.setString('shopping', json.encode(_shopping));
      await sharedPref.setString('marketId', _marketId ?? '');
      await sharedPref.setString('marketName', _marketName ?? '');
      return Right({
        'marketId': _marketId ?? '',
        'marketName': _marketName ?? '',
      });
    } catch (e) {
      log(e.toString());
      return const Left(Failure('حدث خطأ أثناء زيادة كمية المنتج فى السله'));
    }
  }

  Future<Either<Failure, Map<String, String>>> decreaseProductQuantityFromCart(
    Product product,
  ) async {
    try {
      if (_shopping.containsKey(product.id)) {
        _price -=
            product.updatedPrice == 0 ? product.price : product.updatedPrice;
        _shopping.update(
          product.id,
          (value) => value - 1,
          ifAbsent: null,
        );
        if (_shopping[product.id] == 0) {
          _shopping.remove(product.id);
        }
        if (_shopping.isEmpty) {
          _marketId = '';
          _marketName = '';
        }
        await sharedPref.setDouble('price', _price);
        await sharedPref.setString('shopping', json.encode(_shopping));
        await sharedPref.setString('marketId', _marketId ?? '');
        await sharedPref.setString('marketName', _marketName ?? '');
      }
      return Right({
        'marketId': _marketId ?? '',
        'marketName': _marketName ?? '',
      });
    } catch (e) {
      log(e.toString());
      return const Left(Failure('حدث خطأ أثناء تقليل كمية المنتج من السله'));
    }
  }

  Future<Either<Failure, Null>> placeOrder({
    required User user,
    required Location location,
  }) async {
    try {
      final seqIdDoc =
          firestore.collection('orders').doc(ConstantManager.orderSeqIdDoc);
      int seqIdVal = (await seqIdDoc.get()).data()?['seqId'];
      final orderMap = {
        'total': _price + 10,
        'code': seqIdVal,
        'shopping': _shopping,
        'userName': user.name,
        'userPhone': user.phone,
        'userId': user.id,
        'marketId': _marketId ?? '',
        'marketName': _marketName ?? '',
        'status': OrderStatus.pending.name,
        'createdAt': DateTime.now(),
        'location': location.toJson(),
      };
      await firestore.collection('orders').add(orderMap);
      await seqIdDoc.set({'seqId': seqIdVal + 1});
      _shopping.forEach((id, taken) async {
        await firestore
            .collection('products')
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
            .collection('products')
            .doc(id)
            .update({'quantity': FieldValue.increment(taken)});
      });
      return const Right(null);
    } catch (e) {
      log(e.toString());
      return Left(Failure(e.toString()));
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

  Stream<Either<Failure, List<Offer>>> offersStream() async* {
    try {
      final query = firestore.collection('offers');
      yield* query.snapshots().asyncMap((snapshot) async {
        try {
          List<Offer> offersList = [];
          for (var doc in snapshot.docs)
            offersList.add(Offer.fromDoc(doc.id, doc.data()));
          return Right(offersList);
        } catch (e) {
          return Left(Failure(e.toString()));
        }
      });
    } catch (e) {
      yield Left(Failure(e.toString()));
    }
  }

  Future<Either<Failure, List<Offer>>> fetchOffers() async {
    try {
      final response = await firestore.collection('offers').get();
      List<Offer> offersList = [];
      for (var offerDoc in response.docs)
        offersList.add(Offer.fromDoc(offerDoc.id, offerDoc.data()));
      return Right(offersList);
    } catch (e) {
      log(e.toString());
      return const Left(Failure('حدث خطأ أثناء جلب العروض'));
    }
  }

  Future<Either<Failure, List<Product>>> searchForProductByName(
    String productName,
  ) async {
    try {
      final searchResults = await firestore
          .collection('products')
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
