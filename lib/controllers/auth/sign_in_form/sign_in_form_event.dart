part of 'sign_in_form_bloc.dart';

@freezed
class SignInFormEvent with _$SignInFormEvent {
  const factory SignInFormEvent.onEmailChanged(String emailStr) = OnEmailChange;
  const factory SignInFormEvent.onPasswordChanged(String password) =
      OnPasswordChange;
  const factory SignInFormEvent.onRegisterPressed() = OnRegisterPress;
  const factory SignInFormEvent.onSignInPressed() = OnSignInPress;
  const factory SignInFormEvent.onGooglePressed() = OnGooglePress;
}
