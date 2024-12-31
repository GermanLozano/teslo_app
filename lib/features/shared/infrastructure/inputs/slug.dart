
// implementacion de la clase para la valdacion del email 

import 'package:formz/formz.dart';

// Definir errores de validación de entrada
enum SlugError { empty, format }

// Extender FormzInput y proporcionar el tipo de entrada y el tipo de error.
class Slug extends FormzInput<String, SlugError> {

  // Llama a super.pure para representar una entrada de formulario sin modificar.
  const Slug.pure() : super.pure('');

  // Llama a super.dirty para representar una entrada de formulario modificada.
   const Slug.dirty( super.value ) : super.dirty();



  String? get errorMessage {
    if ( isValid || isPure ) return null;

    if ( displayError == SlugError.empty ) return 'El campo es requerido';
    if ( displayError == SlugError.format ) return 'El campo no tiene el formato esperado';

    return null;
  }

  // Anula el validador para gestionar la validación de un valor de entrada dado.
 @override
  SlugError? validator(String value) {
    
    if ( value.isEmpty || value.trim().isEmpty ) return SlugError.empty;
    if ( value.contains("'") || value.contains(' ') ) return SlugError.format;

    return null;
  }
}