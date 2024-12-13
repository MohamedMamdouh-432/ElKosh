part of 'categorys_bloc.dart';

sealed class CategorysEvent extends Equatable {
  const CategorysEvent();

  @override
  List<Object> get props => [];
}

class CategorysLoadingEvent extends CategorysEvent {
  final int? limit;
  const CategorysLoadingEvent([this.limit]);

  @override
  List<Object> get props => [limit ?? 0];
}

class CategorySelectedEvent extends CategorysEvent {
  final Category category;
  const CategorySelectedEvent(this.category);

  @override
  List<Object> get props => [category];
}
