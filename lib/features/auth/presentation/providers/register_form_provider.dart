
// clase para la implementacion del formulario para el login con provider

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';
import 'package:teslo_shop/features/auth/presentation/providers/auth_provider.dart';
import 'package:teslo_shop/features/shared/shared.dart';


// stateNotifierProvider para el registro - consume afuera 
final registerFormProvider = StateNotifierProvider.autoDispose<RegisterFormNotifier, RegisterFormState>((ref) {
  final registerUserCallback = ref.watch(authProvider.notifier).registerUser;  
  return RegisterFormNotifier(
    registerUserCallback: registerUserCallback
  );
});


// implementacon del notifier 
class RegisterFormNotifier extends StateNotifier<RegisterFormState> {

  // definicion de la funion con el caso de uno que vamos a mandar a llamar para reaizar la autenticacion
  final Function(String, String, String ) registerUserCallback;
  
  RegisterFormNotifier({ 
    required this.registerUserCallback,
  }): super( RegisterFormState() );

  // metodo para validar el nombre completo 
  onFullNameChange(String value){
    final newFullName = FullName.dirty(value);

    state = state.copyWith(
      fullName: newFullName,
      isValid: Formz.validate([newFullName, state.password, state.email])
    );
  }


  // sobre el cambio de correo electrónico
  onEmailChange( String value ){
    final newEmail = Email.dirty(value);

    state = state.copyWith(
      email: newEmail,
      isValid: Formz.validate([newEmail, state.password])
    );
  }


  // sobre el cambio de contraseña
  onPasswordChange( String value ){
    final newPassword = Password.dirty(value);

    state = state.copyWith(
      password: newPassword,
      isValid: Formz.validate([newPassword, state.email])
    );
  }


  // implementacon del metodo al enviar el formulario
  onFormSubmit() async{

    _touchEveryField();

    // preguntamos si el estado es valido no hace nada
    if( !state.isValid) return; 

    // mandamos a llamar la funcon del login
    //await loginUserCallback(state.email.value, state.password.value);

    // mandamos a llamar la funcion del register 
    await registerUserCallback(state.fullName.value, state.email.value, state.password.value);

  }

  // metodo para verificar si toca todos los campos
  _touchEveryField(){

    final email = Email.dirty(state.email.value);
    final password = Password.dirty(state.password.value);

    state = state.copyWith(
      isFormPosted: true,
      email: email,
      password: password,
      isValid: Formz.validate([email, password])
    );

  }

}


// estado del privider
class RegisterFormState{

  // Definicion de variables a ocupar 
  final bool isPosting;
  final bool isFormPosted;
  final bool isValid;
  final FullName fullName;
  final Email email;
  final Password password;

  // implementacion del costructor
  RegisterFormState({
    this.isPosting = false, 
    this.isFormPosted = false, 
    this.isValid = false, 
    this.fullName = const FullName.pure(),
    this.email = const Email.pure(), 
    this.password = const Password.pure()
  });

  
  // creamos el copyWith
  RegisterFormState copyWith({

    bool? isPosting,
    bool? isFormPosted,
    bool? isValid,
    FullName? fullName,
    Email? email,
    Password? password,

  }) => RegisterFormState(

    isPosting: isPosting ?? this.isPosting,
    isFormPosted: isFormPosted ?? this.isFormPosted,
    isValid: isValid ?? this.isValid,
    fullName: fullName ?? this.fullName,
    email: email ?? this.email,
    password: password ?? this.password,

  );

 @override
  String toString() {
    return """
    isPosting: $isPosting
    isFormPosted: $isFormPosted
    isValid: $isValid
    fullName: $fullName
    email: $email
    password: $password
    """;
  }

}

