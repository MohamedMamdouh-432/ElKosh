part of 'profile_bloc.dart';

class ProfileState extends Equatable {
  final User user;
  final String errMsg;
  final ProfileStatus status;

  const ProfileState({
    required this.user,
    required this.errMsg,
    required this.status,
  });

  static ProfileState initial = const ProfileState(
    errMsg : "",
    user: User.empty,
    status : ProfileStatus.unknown,
  );

  ProfileState copyWith({
    User? user,
    String? errMsg,
    ProfileStatus? status,
  }) {
    return ProfileState(
      user: user ?? this.user,
      errMsg: errMsg ?? '',
      status: status ?? this.status,
    );
  }
  
  @override
  String toString() {
    return 'ProfileState\nUser: \n$user\nStatus: ${status.name}\nError Message: $errMsg';
  }

  @override
  List<Object> get props => [
        user,
        errMsg,
        status,
      ];
}
