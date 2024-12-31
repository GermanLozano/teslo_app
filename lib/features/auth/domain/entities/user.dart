
// implementacion de la clase para el usuario a manejar en toda app 

class User {

  // definicion de variables 
  final String id;
  final String email;
  final String fullName;
  final List<String> roles;
  final String token;

  // contructor 
  User({
    required this.id, 
    required this.email, 
    required this.fullName, 
    required this.roles, 
    required this.token
  });

  // propiedad para determinar si es admin o no
  bool get isAdmin {
    return roles.contains('admin');
  }


}