import 'package:chat/state/auth/sign_in_form_state.dart';
import 'package:chat/domain/auth/auth_failure.dart';
import 'package:chat/domain/auth/auth_interface.dart';
import 'package:chat/domain/auth/value_objects.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SignInFormNotifier extends StateNotifier<SignInFormState> {
  final IAuthService _authService;

  SignInFormNotifier(
    this._authService,
  ) : super(SignInFormState.initial());

  void onEmailChanged(String emailStr) {
    state = state.copyWith(
      email: EmailAddress(emailStr),
      authFailureOrSuccessOption: none(),
    );
  }

  void onPasswordChanged(String password) {
    state = state.copyWith(
      password: Password(password),
      authFailureOrSuccessOption: none(),
    );
  }

  void onRegisterPressed() {
    _authWithEmailAndPassword(_authService.registerWithEmailAndPassword);
  }

  void onSignInPressed() {
    _authWithEmailAndPassword(_authService.signInWithEmailAndPassword);
  }

  void onGoogleSignInPressed() async {
    state = state.copyWith(
      isSubmitting: true,
      authFailureOrSuccessOption: none(),
    );
    final failureOrSuccess = await _authService.signInWithGoogle();
    state = state.copyWith(
      isSubmitting: false,
      authFailureOrSuccessOption: some(failureOrSuccess),
    );
  }

  void _authWithEmailAndPassword(
      Future<Either<AuthFailure, Unit>> Function({
    required EmailAddress email,
    required Password password,
  })
          forwardedCall) async {
    final isEmailValid = state.email.isValid();
    final isPasswordValid = state.password.isValid();
    Either<AuthFailure, Unit>? failureOrSuccess;

    if (isEmailValid && isPasswordValid) {
      state = state.copyWith(
        isSubmitting: true,
        authFailureOrSuccessOption: none(),
      );
      failureOrSuccess =
          await forwardedCall(email: state.email, password: state.password);
    }

    state = state.copyWith(
      isSubmitting: false,
      showErrorMessages: AutovalidateMode.always,
      authFailureOrSuccessOption: optionOf(failureOrSuccess),
    );
  }
}
