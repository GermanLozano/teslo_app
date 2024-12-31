
// implementacion de la clase para la validacion de la contraseña 

import 'package:formz/formz.dart';

// Definir errores de validación de entrada
enum PasswordError { empty, length, format }

// Extender FormzInput y proporcionar el tipo de entrada y el tipo de error.
class Password extends FormzInput<String, PasswordError> {

  // Expresion que valida Mayusculas, letras, numeros en la contraseña
  static final RegExp passwordRegExp = RegExp(
    r'(?:(?=.*\d)|(?=.*\W+))(?![.\n])(?=.*[A-Z])(?=.*[a-z]).*$',
  );

  // Llama a super.pure para representar una entrada de formulario sin modificar.
  const Password.pure() : super.pure('');

  // Llama a super.dirty para representar una entrada de formulario modificada.
  const Password.dirty( super.value ) : super.dirty();


  String? get errorMessage {
    if ( isValid || isPure ) return null;

    if ( displayError == PasswordError.empty ) return 'El campo es requerido';
    if ( displayError == PasswordError.length ) return 'Mínimo 6 caracteres';
    if ( displayError == PasswordError.format ) return 'Debe de tener Mayúscula, letras y un número';

    return null;
  }


  // Anula el validador para gestionar la validación de un valor de entrada dado.
  @override
  PasswordError? validator(String value) {

    if ( value.isEmpty || value.trim().isEmpty ) return PasswordError.empty;
    if ( value.length < 6 ) return PasswordError.length;
    if ( !passwordRegExp.hasMatch(value) ) return PasswordError.format;

    return null;
  }
}