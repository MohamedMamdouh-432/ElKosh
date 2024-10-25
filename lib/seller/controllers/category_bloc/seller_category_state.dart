part of 'seller_category_bloc.dart';

class SellerCategoryState extends Equatable {
  final List<Category> categorys;
  final Category curCategory;
  final String errMsg;
  final LoadingStatus loadingStatus;
  final AddingStatus addingStatus;

  const SellerCategoryState({
    required this.categorys,
    required this.curCategory,
    required this.errMsg,
    required this.loadingStatus,
    required this.addingStatus,
  });

  static SellerCategoryState initial = SellerCategoryState(
    categorys: const [],
    curCategory: Category.empty,
    errMsg: '',
    loadingStatus: LoadingStatus.initial,
    addingStatus: AddingStatus.initial,
  );

  SellerCategoryState copyWith({
    List<Category>? categorys,
    Category? curCategory,
    String? errMsg,
    LoadingStatus? loadingStatus,
    AddingStatus? addingStatus,
  }) {
    return SellerCategoryState(
      categorys: categorys ?? this.categorys,
      curCategory: curCategory ?? this.curCategory,
      errMsg: errMsg ?? this.errMsg,
      loadingStatus: loadingStatus ?? this.loadingStatus,
      addingStatus: addingStatus ?? this.addingStatus,
    );
  }

  @override
  String toString() {
    return 'Seller Categorys State ::\nCurrent Category: $curCategory\nLoading Status: ${loadingStatus.name}\nAdding Status: ${addingStatus.name}\nError: $errMsg\nCategorys: ${categorys.length}\n';
  }

  @override
  List<Object> get props => [categorys, curCategory, errMsg, loadingStatus, addingStatus];
}
