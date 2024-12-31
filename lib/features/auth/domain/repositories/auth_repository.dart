
// implementacion de la clase para los repositorios
// el repositorio es la definicion de la fuente de datos "datasource" a usar para autenticarnos

import '../entities/user.dart';

abstract class AuthRepository{
  Future<User> login( String email, String password);
  Future<User> register( String email, String password, String fullName);
  Future<User> checkAuthStatus( String token);
}