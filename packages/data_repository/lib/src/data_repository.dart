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
  Product? _selectedProduct;
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

  Market? getCurMarket() => _selctedMarket;
  Product? getCurProduct() => _selectedProduct;
  void setCurMarket(Market market) => _selctedMarket = market;
  void setCurProduct(Product product) => _selectedProduct = product;

  Future<Either<Failure, List<Market>>> fetchMarkets(int? limits) async {
    try {
      final response = limits != null
          ? await firestore.collection('markets').limit(limits).get()
          : await firestore.collection('markets').get();
      List<Market> marketsList = [];
      for (var marketDoc in response.docs)
        marketsList.add(Market.fromDoc(marketDoc.id, marketDoc.data()));
      return Right(marketsList);
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

  Future<Either<Failure, List<Product>>> fetchRelatedProducts() async {
    try {
      final response = await firestore
          .collection('products')
          .where('marketId', isEqualTo: _selctedMarket?.id)
          .get();
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

  Future<String> getMarketName(String id) async {
    try {
      final marketDoc = await firestore.collection('markets').doc(id).get();
      return marketDoc.data()!['name'];
    } catch (e) {
      throw const Failure("حدث خطأ أثناء جلب المتجر");
    }
  }

  Future<Either<Failure, Map<String, dynamic>>> fetchCart() async {
    try {
      String? cartMap = sharedPref.getString('shopping');
      _price = sharedPref.getDouble('price')!;
      if (cartMap == null || _price == 0) {
        _price = 0;
        _shopping = {};
        await sharedPref.setDouble('price', _price);
        await sharedPref.setString('shopping', json.encode(_shopping));

        return const Right({
          'shopping': {},
          'price': 0,
          'marketId': '',
          'marketName': '',
        });
      }
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
      return Left(Failure(e.toString()));
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
      return Left(Failure(e.toString()));
    }
  }

  Future<Either<Failure, Map<String, String>>> addProductToCart(
    Product product,
  ) async {
    try {
      if (_shopping.isEmpty) {
        _marketId = product.marketId;
        _marketName = await getMarketName(_marketId!);
      } else if (_marketId != product.marketId)
        return const Left(Failure("يجب ان تشترى من نفس المتجر"));
      _price += product.price;
      _shopping.update(
        product.id,
        (value) => value + 1,
        ifAbsent: () => 1,
      );
      await sharedPref.setDouble('price', _price);
      await sharedPref.setString('shopping', json.encode(_shopping));
      await sharedPref.setString('marketId', _marketId!);
      await sharedPref.setString('marketName', _marketName!);
      return Right({
        'marketId': _marketId!,
        'marketName': _marketName!,
      });
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  Future<Either<Failure, Map<String, String>>> removeProductFromCart(
    Product product,
  ) async {
    try {
      if (_shopping.containsKey(product.id)) {
        _price -= product.price * _shopping[product.id]!;
        _shopping.remove(product.id);
        if (_shopping.isEmpty) {
          _marketId = '';
          _marketName = '';
        }
        await sharedPref.setDouble('price', _price);
        await sharedPref.setString('shopping', json.encode(_shopping));
        await sharedPref.setString('marketId', _marketId!);
        await sharedPref.setString('marketName', _marketName!);
      }
      return Right({
        'marketId': _marketId!,
        'marketName': _marketName!,
      });
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  Future<Either<Failure, Map<String, String>>> increaseProductQuantityInCart(
    Product product,
  ) async {
    try {
      if (_shopping.isEmpty) {
        _marketId = product.marketId;
        _marketName = await getMarketName(_marketId!);
      } else if (_marketId != product.marketId)
        return const Left(Failure("يجب ان تشترى من نفس المتجر"));
      _price += product.price;
      _shopping.update(
        product.id,
        (value) => value + 1,
        ifAbsent: () => 1,
      );
      await sharedPref.setDouble('price', _price);
      await sharedPref.setString('shopping', json.encode(_shopping));
      await sharedPref.setString('marketId', _marketId!);
      await sharedPref.setString('marketName', _marketName!);
      return Right({
        'marketId': _marketId!,
        'marketName': _marketName!,
      });
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  Future<Either<Failure, Map<String, String>>> decreaseProductQuantityFromCart(
    Product product,
  ) async {
    try {
      if (_shopping.containsKey(product.id)) {
        _price -= product.price;
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
        await sharedPref.setString('marketId', _marketId!);
        await sharedPref.setString('marketName', _marketName!);
      }
      return Right({
        'marketId': _marketId!,
        'marketName': _marketName!,
      });
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  Future<Either<Failure, Null>> placeOrder({
    required String userId,
    required String userName,
    required DeliveryLocation location,
  }) async {
    try {
      final orderMap = {
        'total': _price + ((_price / 100).ceil()),
        'shopping': _shopping,
        'userId': userId,
        'marketId': _marketId!,
        'deliveryId': "",
        'marketName': _marketName!,
        'status': OrderStatus.pending.name,
        'createdAt': DateTime.now(),
        'location': location.toJson(),
      };
      await firestore.collection('orders').add(orderMap);
      // add 2 egp one from seller and one from delivery
      log('Order Succeesed');
      _price = 0;
      _shopping = {};
      _marketId = _marketName = '';
      await sharedPref.setDouble('price', _price);
      await sharedPref.setString('shopping', json.encode(_shopping));
      await sharedPref.setString('marketId', '');
      await sharedPref.setString('marketName', '');
      return const Right(null);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  Future<Either<Failure, Null>> cancelOrder(String orderId) async {
    try {
      final orderData =
          (await firestore.collection('orders').doc(orderId).get()).data()!;
      if (orderData['status'] == OrderStatus.shipped.name)
        return const Left(Failure('Order Already Shipped and in the road'));
      await firestore.collection('orders').doc(orderId).set({
        'createdDate': orderData['createdDate'],
        'price': orderData['price'],
        'userId': orderData['userId'],
        'location': orderData['location'],
        'shopping': orderData['shopping'],
        'status': OrderStatus.cancelled.name,
      });
      return const Right(null);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  Future<Either<Failure, List<Product>>> searchForProductByName(
      String productName) async {
    try {
      final searchResults = await firestore
          .collection('products')
          .where('name', isEqualTo: productName)
          .get();

      final List<Product> searchProductList = [];
      for (var result in searchResults.docs)
        searchProductList.add(Product.fromDoc(result.id, result.data()));
      return Right(searchProductList);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  Future<Either<Failure, List<UserOrder>>> fetchOngoingOrders() async {
    try {
      final orders = await firestore
          .collection('orders')
          .where('userId', isEqualTo: sharedPref.getString('userId'))
          .where('status', whereIn: ['pending', 'shipped']).get();

      final List<UserOrder> orderList = [];
      for (var orderDoc in orders.docs) {
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
      log('Final Orders Size: ${orderList.length}');
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
          .where('status', whereIn: ['cancelled', 'delivered']).get();

      final List<UserOrder> orderList = [];
      for (var orderDoc in orders.docs) {
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
