part of 'authentication_bloc.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

class _AuthenticationStatusChanged extends AuthenticationEvent {
  const _AuthenticationStatusChanged(this.status);

  final AuthenticationStatus status;
}

class AuthenticationLogoutRequested extends AuthenticationEvent {
  final User user;

  const AuthenticationLogoutRequested({
    required this.user,
  });

  @override
  List<Object> get props => [user];
}
