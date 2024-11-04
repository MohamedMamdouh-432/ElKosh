part of 'categorys_bloc.dart';

class CategorysState extends Equatable {
  final List<Category> categorys;
  final Category curCategory;
  final String errMsg;
  final LoadingStatus status;

  const CategorysState({
    required this.categorys,
    required this.curCategory,
    required this.errMsg,
    required this.status,
  });

  static CategorysState initial = CategorysState(
    categorys: const [],
    curCategory: Category.empty,
    errMsg: '',
    status: LoadingStatus.initial,
  );

  CategorysState copyWith({
    List<Category>? categorys,
    Category? curCategory,
    String? errMsg,
    LoadingStatus? status,
  }) {
    return CategorysState(
      categorys: categorys ?? this.categorys,
      curCategory: curCategory ?? this.curCategory,
      errMsg: errMsg ?? this.errMsg,
      status: status ?? this.status,
    );
  }

  @override
  String toString() {
    return 'Categorys State ::\nCurrent Category: $curCategory\nStatus: $status\nError: $errMsg\nCategories: ${categorys.length}\n';
  }

  @override
  List<Object> get props => [categorys, curCategory, errMsg, status];
}
