import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:either_dart/either.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:models_repository/models_repository.dart';

class DataRepository {
  final FirebaseFirestore firestore;
  final FirebaseStorage fireStorage;
  Market? _market;
  Product? _product;

  DataRepository({
    required this.firestore,
    required this.fireStorage,
  });

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
}
