
// implementacion de la clase para la valdacion del email 

import 'package:formz/formz.dart';

// Definir errores de validación de entrada
enum TitleError { empty }

// Extender FormzInput y proporcionar el tipo de entrada y el tipo de error.
class Title extends FormzInput<String, TitleError> {

  // Llama a super.pure para representar una entrada de formulario sin modificar.
  const Title.pure() : super.pure('');

  // Llama a super.dirty para representar una entrada de formulario modificada.
  const Title.dirty( super.value ) : super.dirty();



  String? get errorMessage {
    if ( isValid || isPure ) return null;

    if ( displayError == TitleError.empty ) return 'El campo es requerido';

    return null;
  }

  // Anula el validador para gestionar la validación de un valor de entrada dado.
  @override
  TitleError? validator(String value) {
    
    if ( value.isEmpty || value.trim().isEmpty ) return TitleError.empty;

    return null;
  }
} 