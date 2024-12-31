// clase para la implementacion de errores personalizados en caso de el try-casht falle

// errores a manejar
// ... credenciales incorrectas
class WrongCredentials implements Exception {}

// token no valido
class InvalidToken implements Exception {}

// error de tiempo de espera de conexion
class ConnectionTimeout implements Exception{}

// error de conexion y otros personalizados
class CustomError implements Exception {
  final String message;
  //final int erroCode;

  CustomError(this.message);
}
