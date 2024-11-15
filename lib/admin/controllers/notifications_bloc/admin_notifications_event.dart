part of 'admin_notifications_bloc.dart';

class AdminNotificationsEvent extends Equatable {
  const AdminNotificationsEvent();

  @override
  List<Object> get props => [];
}

class AdminNotificationsFetchingEvent extends AdminNotificationsEvent {}

class AdminOrderSelectedEvent extends AdminNotificationsEvent {
  final UserOrder order;
  const AdminOrderSelectedEvent(this.order);

  @override
  List<Object> get props => [order];
}
