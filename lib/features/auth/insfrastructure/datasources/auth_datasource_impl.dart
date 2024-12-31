// clase para la implementacion del origen de datos "datasource"
// se intala Dio para las peticiones https

import 'package:dio/dio.dart';
import 'package:teslo_shop/config/config.dart';
import 'package:teslo_shop/features/auth/domain/domain.dart';
import 'package:teslo_shop/features/auth/insfrastructure/infrastructure.dart';

class AuthDatasourceImpl extends AuthDataSource {
  // implementacion de Dio
  final dio = Dio(BaseOptions(
    baseUrl: Environment.apiUrl,
  ));

  @override
  Future<User> checkAuthStatus(String token) async {
    try {
      final response = await dio.get('/auth/check-status',
        options: Options(headers: {'Authorization': 'Bearer $token'}));

      final user = UserMapper.userJsonToEntity(response.data);
      return user;

    } on DioException catch (e) {
      // cualdo algo sale mal en la peticion
      if (e.response?.statusCode == 401) {
        throw CustomError('Token incorrecto');
      }
      
      throw Exception();
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future<User> login(String email, String password) async {
    try {
      // peticion en la que todo sale bien
      final response = await dio
          .post('/auth/login', data: {'email': email, 'password': password});

      final user = UserMapper.userJsonToEntity(response.data);
      return user;

    } on DioException catch (e) {
      // cualdo algo sale mal en la peticion
      if (e.response?.statusCode == 401) {
        throw CustomError(
            e.response?.data['message'] ?? 'Credenciales incorrectas');
      }

      if (e.type == DioExceptionType.connectionTimeout) {
        throw CustomError('Revisar conexion a internet');
      }
      throw Exception();
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future<User> register(String email, String password, String fullName) {
    // TODO: implement register
    throw UnimplementedError();
  }
}
