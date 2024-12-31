
// implementacion de la clase para la validacion del nombre 

import 'package:formz/formz.dart';

// Definir errores de validación de entrada
enum FullNameError { empty, length }

// Extender FormzInput y proporcionar el tipo de entrada y el tipo de error.
class FullName extends FormzInput<String, FullNameError> {

  // Llama a super.pure para representar una entrada de formulario sin modificar.
  const FullName.pure() : super.pure('');

  // Llama a super.dirty para representar una entrada de formulario modificada.
  const FullName.dirty( super.value ) : super.dirty();


  String? get errorMessage {
    if ( isValid || isPure ) return null;

    if ( displayError == FullNameError.empty ) return 'El campo es requerido';
    if ( displayError == FullNameError.length ) return 'Por favor, ingrese el nombre completo';

    return null;
  }


  // Anula el validador para gestionar la validación de un valor de entrada dado.
  @override
  FullNameError? validator(String value) {

    if ( value.isEmpty || value.trim().isEmpty ) return FullNameError.empty;
    
    // dividir el nombre completo (por espacio)
    List<String> parts = value.split(''); 

    if ( parts.length < 2 ) return FullNameError.length;

    return null;
  }
}