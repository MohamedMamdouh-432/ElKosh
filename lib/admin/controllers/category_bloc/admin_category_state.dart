part of 'admin_category_bloc.dart';

class AdminCategoryState extends Equatable {
  final List<Category> categorys;
  final Category curCategory;
  final String errMsg;
  final LoadingStatus loadingStatus;
  final AddingStatus addingStatus;

  const AdminCategoryState({
    required this.categorys,
    required this.curCategory,
    required this.errMsg,
    required this.loadingStatus,
    required this.addingStatus,
  });

  static AdminCategoryState initial = AdminCategoryState(
    categorys: const [],
    curCategory: Category.empty,
    errMsg: '',
    loadingStatus: LoadingStatus.initial,
    addingStatus: AddingStatus.initial,
  );

  AdminCategoryState copyWith({
    List<Category>? categorys,
    Category? curCategory,
    String? errMsg,
    LoadingStatus? loadingStatus,
    AddingStatus? addingStatus,
  }) {
    return AdminCategoryState(
      categorys: categorys ?? this.categorys,
      curCategory: curCategory ?? this.curCategory,
      errMsg: errMsg ?? this.errMsg,
      loadingStatus: loadingStatus ?? this.loadingStatus,
      addingStatus: addingStatus ?? this.addingStatus,
    );
  }

  @override
  String toString() {
    return 'Admin Categorys State ::\nCurrent Category: $curCategory\nLoading Status: ${loadingStatus.name}\nAdding Status: ${addingStatus.name}\nError: $errMsg\nCategorys: ${categorys.length}\n';
  }

  @override
  List<Object> get props =>
      [categorys, curCategory, errMsg, loadingStatus, addingStatus];
}
