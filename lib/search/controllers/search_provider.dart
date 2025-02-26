import 'package:flutter/foundation.dart';
import 'package:data_repository/data_repository.dart';
import 'package:elkosh/shared/services/service_locator.dart';
import 'package:models_repository/models_repository.dart';

class SearchProvider extends ChangeNotifier {
  String _query = '';
  List<Product> _products = [];
  LoadStatus _status = LoadStatus.initial;
  String _errMsg = '';

  String get query => _query;
  List<Product> get products => _products;
  LoadStatus get status => _status;
  String get errMsg => _errMsg;

  void updateQuery(String newQuery) {
    _query = newQuery;
    _status = LoadStatus.inProgress;
    notifyListeners();

    if (newQuery.isEmpty) {
      _products = [];
      _status = LoadStatus.success;
      notifyListeners();
      return;
    }

    _searchProducts();
  }

  Future<void> submitQuery() async {
    _status = LoadStatus.inProgress;
    notifyListeners();

    if (_query.isEmpty) {
      _products = [];
      _status = LoadStatus.success;
      notifyListeners();
      return;
    }

    await _searchProducts();
  }

  Future<void> _searchProducts() async {
    try {
      final queryResults =
          await sl.get<DataRepository>().searchForProduct(_query);
      queryResults.fold(
        (l) {
          _errMsg = l.message;
          _status = LoadStatus.failure;
        },
        (r) {
          _products = r;
          _status = LoadStatus.success;
        },
      );
    } catch (e) {
      _errMsg = e.toString();
      _status = LoadStatus.failure;
    }
    notifyListeners();
  }
}
