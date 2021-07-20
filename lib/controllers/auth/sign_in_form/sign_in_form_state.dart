part of 'sign_in_form_bloc.dart';

@freezed
class SignInFormState with _$SignInFormState {
  const factory SignInFormState({
    required EmailAddress email,
    required Password password,
    required AutovalidateMode showErrorMessages,
    required bool isSubmitting,
    required Option<Either<AuthFailure, Unit>> authFailureOrSuccessOption,
  }) = _SignInFormState;

  factory SignInFormState.initial() => SignInFormState(
        email: EmailAddress(''),
        password: Password(''),
        showErrorMessages: AutovalidateMode.disabled,
        isSubmitting: false,
        authFailureOrSuccessOption: none(),
      );
}
