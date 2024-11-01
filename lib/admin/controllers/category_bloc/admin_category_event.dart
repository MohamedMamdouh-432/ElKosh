part of 'admin_category_bloc.dart';

sealed class AdminCategoryEvent extends Equatable {
  const AdminCategoryEvent();

  @override
  List<Object> get props => [];
}

class AdminCategorysLoadingEvent extends AdminCategoryEvent {}

class AdminCategorySelectedEvent extends AdminCategoryEvent {
  final Category category;
  const AdminCategorySelectedEvent(this.category);

  @override
  List<Object> get props => [category];
}

class AdminCategoryAddingEvent extends AdminCategoryEvent {
  final MapEntry categoryItem;
  const AdminCategoryAddingEvent(this.categoryItem);

  @override
  List<Object> get props => [categoryItem];
}

class AdminCategoryDeletingEvent extends AdminCategoryEvent {
  final String categoryId;
  const AdminCategoryDeletingEvent(this.categoryId);

  @override
  List<Object> get props => [categoryId];
}

class AdminCategoryResetEvent extends AdminCategoryEvent {}
