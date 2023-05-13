import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/features/auth/domain/domain.dart';
import 'package:teslo_shop/features/auth/infrasctructure/infrasctructure.dart';
import 'package:teslo_shop/features/auth/infrasctructure/repositories/auth_repository_impl.dart';

enum AuthStatus { checking, authenticated, notAuthenticated }

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authReposiroty = AuthRepositoryImpl();
  return AuthNotifier(repository: authReposiroty);
});

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository repository;
  AuthNotifier({required this.repository}) : super(AuthState());

  Future<void> loginUser(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 500));

    try {
      final user = await repository.login(email, password);
      _setLoggedUser(user);
    } on WrongCredentials {
      logout('Credenciales no son correctas');
    } on CustomError catch (e) {
      logout(e.message);
    } on ConnectionTimeout {
      logout('timeout');
    } catch (_) {
      logout('error no controlado');
    }
  }

  void registerUser(String email, String password, String fullName) async {}
  void checkAuthStatus() async {}

  void _setLoggedUser(User user) {
    //TODO: necesitamos guardar el token fisicamente
    state = state.copyWith(user: user, authStatus: AuthStatus.authenticated);
  }

  Future<void> logout([String? errorMessage]) async {
    state = state.copyWith(
        authStatus: AuthStatus.notAuthenticated,
        user: null,
        errorMessage: errorMessage);
  }
}

class AuthState {
  final AuthStatus authStatus;
  final User? user;
  final String errorMessage;

  AuthState(
      {this.authStatus = AuthStatus.checking,
      this.user,
      this.errorMessage = ''});

  AuthState copyWith({
    AuthStatus? authStatus,
    User? user,
    String? errorMessage,
  }) =>
      AuthState(
          authStatus: authStatus ?? this.authStatus,
          errorMessage: errorMessage ?? this.errorMessage,
          user: user ?? this.user);
}
