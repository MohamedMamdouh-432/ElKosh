part of 'admin_users_bloc.dart';

class AdminUsersState extends Equatable {
  final List<User> users;
  final String errMsg;
  final LoadingStatus status;

  const AdminUsersState({
    required this.users,
    required this.errMsg,
    required this.status,
  });

  static AdminUsersState initial = const AdminUsersState(
    users: [],
    errMsg: '',
    status: LoadingStatus.initial,
  );

  AdminUsersState copyWith({
    List<User>? users,
    String? errMsg,
    LoadingStatus? status,
  }) {
    return AdminUsersState(
      users: users ?? this.users,
      errMsg: errMsg ?? this.errMsg,
      status: status ?? this.status,
    );
  }

  @override
  String toString() {
    return 'UsersState\nUsers: ${users.length}\nLoading Status: ${status.name}\nError: $errMsg';
  }

  @override
  List<Object> get props => [users, errMsg, status];
}
