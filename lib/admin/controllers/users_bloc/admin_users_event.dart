part of 'admin_users_bloc.dart';

sealed class AdminUsersEvent extends Equatable {
  const AdminUsersEvent();

  @override
  List<Object> get props => [];
}

class AdminUsersLoadingEvent extends AdminUsersEvent {}

class AdminUserBlockingEvent extends AdminUsersEvent {
  final String userId;
  const AdminUserBlockingEvent(this.userId);

  @override
  List<Object> get props => [userId];
}

class AdminUserUnBlockingEvent extends AdminUsersEvent {
  final String userId;
  const AdminUserUnBlockingEvent(this.userId);

  @override
  List<Object> get props => [userId];
}
