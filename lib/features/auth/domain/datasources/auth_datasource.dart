
// domain/ implementacion de la reglas de negocio 
// auth_datasouerce/ definicion de como quiero que sean los sistemas de auth que puede manejar la app

import '../entities/user.dart';

abstract class AuthDataSource{
  Future<User> login( String email, String password);
  Future<User> register( String email, String password, String fullName);
  Future<User> checkAuthStatus( String token);
}