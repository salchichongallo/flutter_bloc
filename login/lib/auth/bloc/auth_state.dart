part of 'auth_bloc.dart';

class AuthState extends Equatable {
  final AuthStatus status;
  final User user;

  const AuthState._({
    this.status = AuthStatus.unknown,
    this.user = User.empty,
  });

  const AuthState.unknown() : this._();

  const AuthState.authenticated(User user)
      : this._(status: AuthStatus.authenticated, user: user);

  const AuthState.guess() : this._(status: AuthStatus.guess);

  @override
  List<Object> get props => [status, user];
}
