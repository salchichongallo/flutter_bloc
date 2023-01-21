import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:login/auth_repo/auth_repo.dart';
import 'package:login/user_repo/models/user.dart';
import 'package:login/user_repo/user_repo.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthenticationRepo _authRepo;
  final UserRepository _userRepo;

  late StreamSubscription<AuthStatus> _authStatusSubscription;

  AuthBloc({
    required AuthenticationRepo authRepo,
    required UserRepository userRepo,
  })  : _authRepo = authRepo,
        _userRepo = userRepo,
        super(const AuthState.unknown()) {
    on<_AuthStatusChanged>(_onAuthStatusChanged);
    on<_AuthLogoutRequested>(_onAuthLogoutRequested);
    _authStatusSubscription =
        _authRepo.status.listen((status) => add(_AuthStatusChanged(status)));
  }

  @override
  Future<void> close() {
    _authStatusSubscription.cancel();
    return super.close();
  }

  Future<void> _onAuthStatusChanged(
      _AuthStatusChanged event, Emitter<AuthState> emit) async {
    switch (event.status) {
      case AuthStatus.guess:
        return emit(const AuthState.guess());
      case AuthStatus.authenticated:
        final user = await _tryGetUser();
        return emit(
          user != null
              ? AuthState.authenticated(user)
              : const AuthState.guess(),
        );
      case AuthStatus.unknown:
        return emit(const AuthState.unknown());
    }
  }

  Future<User?> _tryGetUser() async {
    try {
      final user = await _userRepo.getUser();
      return user;
    } catch (_) {
      return null;
    }
  }

  void _onAuthLogoutRequested(
      _AuthLogoutRequested event, Emitter<AuthState> emit) {
    _authRepo.logOut();
  }
}
