import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:models_repository/models_repository.dart';

class DataRepository {
  final FirebaseFirestore firestore;
  final FirebaseStorage fireStorage;
  Market? _market;
  Product? _product;

  DataRepository({
    required this.fireStorage,
    required this.firestore,
  });
  
  Market? getCurMarket() => _market;
  Product? getCurProduct() => _product;
  void setCurMarket(Market market) => _market = market;
  void setCurProduct(Product product) => _product = product;
}
