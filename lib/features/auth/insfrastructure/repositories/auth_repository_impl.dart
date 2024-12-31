
// clase para la implementacion de los repositorios 
// la idea de los repositorios es que permta facilmente mandar a hacer los cambios en el origen de datros "Datasourde"

import 'package:teslo_shop/features/auth/domain/domain.dart';
import '../infrastructure.dart';

class AuthRepositoryImpl extends AuthRepository{

  // referencia al datasource 
  final AuthDataSource dataSource;
  
  // contructor para resivirlo
  AuthRepositoryImpl({
    AuthDataSource? dataSource
  }) : dataSource = dataSource ?? AuthDatasourceImpl();


  @override
  Future<User> checkAuthStatus(String token) {
    return dataSource.checkAuthStatus(token);
  }

  @override
  Future<User> login(String email, String password) {
    return dataSource.login(email, password);
  }

  @override
  Future<User> register(String email, String password, String fullName) {
    return dataSource.register(email, password, fullName);
  }

}