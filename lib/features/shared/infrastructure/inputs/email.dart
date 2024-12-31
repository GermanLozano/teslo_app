
// implementacion de la clase para la valdacion del email 

import 'package:formz/formz.dart';

// Definir errores de validación de entrada
enum EmailError { empty, format }

// Extender FormzInput y proporcionar el tipo de entrada y el tipo de error.
class Email extends FormzInput<String, EmailError> {

  static final RegExp emailRegExp = RegExp(
    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
  );

  // Llama a super.pure para representar una entrada de formulario sin modificar.
  const Email.pure() : super.pure('');

  // Llama a super.dirty para representar una entrada de formulario modificada.
  const Email.dirty( super.value ) : super.dirty();



  String? get errorMessage {
    if ( isValid || isPure ) return null;

    if ( displayError == EmailError.empty ) return 'El campo es requerido';
    if ( displayError == EmailError.format ) return 'No tiene formato de correo electrónico';

    return null;
  }

  // Anula el validador para gestionar la validación de un valor de entrada dado.
  @override
  EmailError? validator(String value) {
    
    if ( value.isEmpty || value.trim().isEmpty ) return EmailError.empty;
    if ( !emailRegExp.hasMatch(value) ) return EmailError.format;

    return null;
  }
} 