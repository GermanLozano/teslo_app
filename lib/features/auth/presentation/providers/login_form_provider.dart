
// clase para la implementacion del formulario para el login con provider

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';
import 'package:teslo_shop/features/auth/presentation/providers/auth_provider.dart';
import 'package:teslo_shop/features/shared/shared.dart';


// stateNotifierProvider para el login - consume afuera 
final loginFormProvider = StateNotifierProvider.autoDispose<LoginFormNotifier, LoginFormState>((ref) {
  final loginUserCallback = ref.watch(authProvider.notifier).loguinUser;  
  return LoginFormNotifier(
    loginUserCallback: loginUserCallback
  );
});


// implementacon del notifier 
class LoginFormNotifier extends StateNotifier<LoginFormState> {

  // definicion de la funion con el caso de uno que vamos a mandar a llamar para reaizar la autenticacion
  final Function(String, String ) loginUserCallback;

  LoginFormNotifier({ 
    required this.loginUserCallback,
  }): super( LoginFormState() );

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

    // cambianos el estado del isPosting
    state = state.copyWith(isPosting: true);

    // mandamos a llamar la funcon del login
    await loginUserCallback(state.email.value, state.password.value);

    // volvemos a cambiar el estado del posteo se cumpla la linea anterioro o no
    state = state.copyWith(isPosting: false);
    
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
class LoginFormState{

  // Definicion de variables a ocupar 
  final bool isPosting;
  final bool isFormPosted;
  final bool isValid;
  final Email email;
  final Password password;

  // implementacion del costructor
  LoginFormState({
    this.isPosting = false, 
    this.isFormPosted = false, 
    this.isValid = false, 
    this.email = const Email.pure(), 
    this.password = const Password.pure()
  });

  
  // creamos el copyWith
  LoginFormState copyWith({

    bool? isPosting,
    bool? isFormPosted,
    bool? isValid,
    Email? email,
    Password? password,

  }) => LoginFormState(

    isPosting: isPosting ?? this.isPosting,
    isFormPosted: isFormPosted ?? this.isFormPosted,
    isValid: isValid ?? this.isValid,
    email: email ?? this.email,
    password: password ?? this.password,

  );

 @override
  String toString() {
    return """
    isPosting: $isPosting
    isFormPosted: $isFormPosted
    isValid: $isValid
    email: $email
    password: $password
    """;
  }

}

