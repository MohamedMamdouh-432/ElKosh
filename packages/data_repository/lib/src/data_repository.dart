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
  Market? _market;
  Product? _product;
  double price;
  Map<String, int> shoppings;

  DataRepository({
    required this.firestore,
    required this.fireStorage,
    required this.sharedPref,
  })  : price = 0,
        shoppings = {};

  Market? getCurMarket() => _market;
  Product? getCurProduct() => _product;
  void setCurMarket(Market market) => _market = market;
  void setCurProduct(Product product) => _product = product;

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
          .where('marketId', isEqualTo: _market?.id)
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
      for (var element in orders.docs) {
        final elementData = element.data();
        Map<Product, int> elementProducts = {};
        elementData['shoppings'].forEach((productId, productCount) async {
          final mappedProduct = await fetchProductById(productId);
          elementProducts.putIfAbsent(mappedProduct, () => productCount);
          orderList
              .add(UserOrder.fromDoc(elementData, elementProducts, element.id));
        });
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
          .where('status', whereIn: ['Cancelled', 'Delivered']).get();

      final List<UserOrder> orderList = [];
      for (var element in orders.docs) {
        final elementData = element.data();
        Map<Product, int> elementProducts = {};
        elementData['shoppings'].forEach((id, countVal) async {
          final mappedProduct = await fetchProductById(id);
          elementProducts.putIfAbsent(mappedProduct, () => countVal);
        });
        orderList
            .add(UserOrder.fromDoc(elementData, elementProducts, element.id));
      }

      return Right(orderList);
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
        'shoppings': orderData['shoppings'],
        'status': OrderStatus.cancelled.name,
      });
      return const Right(null);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  Future<Either<Failure, Map<String, dynamic>>> fetchCart() async {
    try {
      String? cartMap = sharedPref.getString('shoppings');
      if (cartMap == null) {
        price = 0;
        shoppings = {};
        await sharedPref.setDouble('price', price);
        await sharedPref.setString('shoppings', json.encode(shoppings));
        return const Right({
          'shopping': {},
          'price': 0,
        });
      }
      shoppings = {};
      price = sharedPref.getDouble('price')!;
      final shoppingMap = json.decode(cartMap);
      Map<Product, int> shoppingList = {};
      shoppingMap.forEach((id, countVal) async {
        shoppings.putIfAbsent(id, () => countVal);
        final mappedProduct = await fetchProductById(id);
        shoppingList.putIfAbsent(mappedProduct, () => countVal);
      });
      return Right({
        'price': price,
        'shopping': shoppingList,
      });
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  Future<Either<Failure, Map<String, dynamic>>> resetCart() async {
    price = 0;
    shoppings = {};
    try {
      await sharedPref.setDouble('price', price);
      await sharedPref.setString('shoppings', json.encode(shoppings));
      return Right({
        'price': price,
        'shopping': const {},
      });
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  Future<Either<Failure, Null>> addProductToCart(
    Product product,
  ) async {
    try {
      price += product.price;
      shoppings.update(
        product.id,
        (value) => value + 1,
        ifAbsent: () => 1,
      );
      await sharedPref.setDouble('price', price);
      await sharedPref.setString('shoppings', json.encode(shoppings));
      return const Right(null);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  Future<Either<Failure, Null>> removeProductFromCart(
    Product product,
  ) async {
    try {
      if (shoppings.containsKey(product.id)) {
        price -= product.price * shoppings[product.id]!;
        shoppings.remove(product.id);
        await sharedPref.setDouble('price', price);
        await sharedPref.setString('shoppings', json.encode(shoppings));
      }
      return const Right(null);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  Future<Either<Failure, Null>> increaseProductQuantityInCart(
    Product product,
  ) async {
    try {
      price += product.price;
      shoppings.update(
        product.id,
        (value) => value + 1,
        ifAbsent: () => 1,
      );
      await sharedPref.setDouble('price', price);
      await sharedPref.setString('shoppings', json.encode(shoppings));
      return const Right(null);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  Future<Either<Failure, Null>> decreaseProductQuantityFromCart(
    Product product,
  ) async {
    try {
      if (shoppings.containsKey(product.id)) {
        price -= product.price;
        shoppings.update(
          product.id,
          (value) => value - 1,
          ifAbsent: null,
        );
        if (shoppings[product.id] == 0) {
          shoppings.remove(product.id);
        }
        await sharedPref.setDouble('price', price);
        await sharedPref.setString('shoppings', json.encode(shoppings));
      }
      return const Right(null);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  Future<Either<Failure, Null>> placeOrder(
    // double lat,
    // double long,
    String userName,
    String imgUrl,
  ) async {
    try {
      Map<String, dynamic> orderData = {
        'price': price,
        'shoppings': shoppings,
        // 'location': GeoPoint(lat, long),
        'status': OrderStatus.pending.name,
        'userId': sharedPref.getString('userId'),
        'createdDate': DateTime.now().toString(),
        'imgUrl': imgUrl,
        'userName': userName,
      };
      await firestore.collection('orders').add(orderData);
      log('Order Succeesed');
      price = 0;
      shoppings = {};
      await sharedPref.setDouble('price', price);
      await sharedPref.setString('shoppings', json.encode(shoppings));
      return const Right(null);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}
