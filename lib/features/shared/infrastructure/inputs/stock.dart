
// implementacion de la clase para la valdacion del email 

import 'package:formz/formz.dart';

// Definir errores de validación de entrada
enum StockError { empty, value, format }

// Extender FormzInput y proporcionar el tipo de entrada y el tipo de error.
class Stock extends FormzInput<int, StockError> {

  // Llama a super.pure para representar una entrada de formulario sin modificar.
  const Stock.pure() : super.pure(0);

  // Llama a super.dirty para representar una entrada de formulario modificada.
  const Stock.dirty( super.value ) : super.dirty();



  String? get errorMessage {
    if ( isValid || isPure ) return null;

    if ( displayError == StockError.empty ) return 'El campo es requerido';
    if ( displayError == StockError.value ) return 'Debe ser mayor o igual a cero';
    if ( displayError == StockError.format) return 'No tiene formato de numero';
    
    return null;
  }

  // Anula el validador para gestionar la validación de un valor de entrada dado.
  @override
  StockError? validator(int value) {
    
    if ( value.toString().isEmpty || value.toString().trim().isEmpty ) return StockError.empty;
    
    final isInteger = int.tryParse(value.toString()) ??  -1;
    if (isInteger == -1 ) return StockError.format;

    if ( value < 0) return StockError.value;


    return null;
  }
} 