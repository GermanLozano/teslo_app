// implementacion del provider para mantener el estado de la autenticacion de manera global
// es decir, saber si esta autenticado o no, si esta revisando la autenticacion o quien esta
// autenticado o cual es su token

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/features/auth/domain/domain.dart';
import 'package:teslo_shop/features/auth/insfrastructure/infrastructure.dart';
import 'package:teslo_shop/features/shared/infrastructure/services/key_value_storage_service.dart';
import 'package:teslo_shop/features/shared/infrastructure/services/key_value_storage_service_impl.dart';

// creamos el provider
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  // hacemos la implementacion de...
  final authRepository = AuthRepositoryImpl();
  final keyValueStorageService = KeyValueStorageServiceImpl();

  return AuthNotifier(
      authRepository: authRepository,
      keyValueStorageService: keyValueStorageService);
});

// implementamos el stateNotifier
class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository authRepository;
  final KeyValueStorageService keyValueStorageService;

  // contructor
  AuthNotifier({
    required this.authRepository,
    required this.keyValueStorageService,
  }) : super(AuthState()) {
    checkAuthStatus();
  }

  // metodos a implementar
  Future<void> loguinUser(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 500));

    try {
      final user = await authRepository.login(email, password);
      _setLoggedUser(user);
    } on CustomError catch (e) {
      logout(e.message);
    } catch (e) {
      logout('Error no controlado');
    }
  }

  void registerUser(String fullName, String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 300));

    try {
      final user = await authRepository.register(fullName, email, password);
      _setLoggedUser(user);
    } on WrongCredentials {
      logout('Credenciales no guadadas');
    } catch (e) {
      logout('Error no controlado');
    }
  }

  void checkAuthStatus() async {
    final token = await keyValueStorageService.getValue<String>('token');

    if (token == null) return logout();

    try {
      final user = await authRepository.checkAuthStatus(token);
      _setLoggedUser(user);
    } catch (e) {
      logout();
    }
  }

  // metodo para centralisar los demas metodos ya que los 3 metodos van a manejar un estado similar
  void _setLoggedUser(User user) async {
    // guardar el el token fisicamente
    await keyValueStorageService.setKeyValue('token', user.token);

    state = state.copyWith(
      user: user,
      authStatus: AuthStatus.authenticated,
      errorMessage: '',
    );
  }

  Future<void> logout([String? errorMessage]) async {
    // borrar el token
    await keyValueStorageService.removeKey('token');

    state = state.copyWith(
        authStatus: AuthStatus.notAuthenticated,
        user: null,
        errorMessage: errorMessage);
  }
}

// enumeracion de los 3 estados que se van a manejar
enum AuthStatus { checking, authenticated, notAuthenticated }

class AuthState {
  // implementacion de la propiedades a implementar
  final AuthStatus authStatus;
  final User? user;
  final String errorMessage;

  // implementacion del constructor
  AuthState(
      {this.authStatus = AuthStatus.checking,
      this.user,
      this.errorMessage = ''});

  // creamos el copyWhit
  AuthState copyWith({
    AuthStatus? authStatus,
    User? user,
    String? errorMessage,
  }) =>
      AuthState(
          authStatus: authStatus ?? this.authStatus,
          user: user ?? this.user,
          errorMessage: errorMessage ?? this.errorMessage);
}
