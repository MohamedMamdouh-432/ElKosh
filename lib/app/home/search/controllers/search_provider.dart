import 'package:data_repository/data_repository.dart';
import 'package:elkosh/shared/services/service_locator.dart';
import 'package:flutter/foundation.dart';
import 'package:models_repository/models_repository.dart';

class SearchProvider extends ChangeNotifier {
  List<Product> _products = [];
  LoadStatus _status = LoadStatus.initial;
  String _errMsg = '';

  List<Product> get products => _products;
  LoadStatus get status => _status;
  String get errMsg => _errMsg;

  Future<void> submitQuery(String query) async {
    try {
      _status = LoadStatus.inProgress;
      notifyListeners();

      if (query.isEmpty) {
        _products = [];
        _status = LoadStatus.success;
        notifyListeners();
        return;
      }

      final result = await sl.get<DataRepository>().searchForProduct(query);
      result.fold(
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
