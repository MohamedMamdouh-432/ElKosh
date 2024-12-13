part of 'profile_bloc.dart';

class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

class ProfileLoadingEvent extends ProfileEvent {}

class ProfileSigningOutEvent extends ProfileEvent {}

class ProfileDeletingEvent extends ProfileEvent {}
