
// implementacion de la clase para la valdacion del email 

import 'package:formz/formz.dart';

// Definir errores de validación de entrada
enum PriceError { empty, value }

// Extender FormzInput y proporcionar el tipo de entrada y el tipo de error.
class Price extends FormzInput<double, PriceError> {

  // Llama a super.pure para representar una entrada de formulario sin modificar.
  const Price.pure() : super.pure(0.0);

  // Llama a super.dirty para representar una entrada de formulario modificada.
  const Price.dirty( super.value ) : super.dirty();



  String? get errorMessage {
    if ( isValid || isPure ) return null;

    if ( displayError == PriceError.empty ) return 'El campo es requerido';
    if ( displayError == PriceError.value ) return 'Debe ser mayor o igual a cero';
    
    return null;
  }

  // Anula el validador para gestionar la validación de un valor de entrada dado.
  @override
  PriceError? validator(double value) {
    
    if ( value.toString().isEmpty || value.toString().trim().isEmpty ) return PriceError.empty;
    if ( value < 0) return PriceError.value;


    return null;
  }
} 