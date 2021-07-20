import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:chat/domain/auth/auth_failure.dart';
import 'package:chat/domain/auth/auth_interface.dart';
import 'package:chat/domain/auth/value_objects.dart';
import 'package:injectable/injectable.dart';

part 'sign_in_form_bloc.freezed.dart';
part 'sign_in_form_event.dart';
part 'sign_in_form_state.dart';

@injectable
class SignInFormBloc extends Bloc<SignInFormEvent, SignInFormState> {
  final IAuthService _authService;

  SignInFormBloc(
    this._authService,
  ) : super(SignInFormState.initial());

  @override
  Stream<SignInFormState> mapEventToState(
    SignInFormEvent event,
  ) async* {
    yield* event.map(
      onEmailChanged: (e) async* {
        yield state.copyWith(
          email: EmailAddress(e.emailStr),
          authFailureOrSuccessOption: none(),
        );
      },
      onPasswordChanged: (e) async* {
        yield state.copyWith(
          password: Password(e.password),
          authFailureOrSuccessOption: none(),
        );
      },
      onRegisterPressed: (e) async* {
        yield* _authWithEmailAndPassword(
            _authService.registerWithEmailAndPassword);
      },
      onSignInPressed: (e) async* {
        yield* _authWithEmailAndPassword(
            _authService.signInWithEmailAndPassword);
      },
      onGooglePressed: (e) async* {
        yield state.copyWith(
          isSubmitting: true,
          authFailureOrSuccessOption: none(),
        );
        final failureOrSuccess = await _authService.signInWithGoogle();
        yield state.copyWith(
          isSubmitting: false,
          authFailureOrSuccessOption: some(failureOrSuccess),
        );
      },
    );
  }

  Stream<SignInFormState> _authWithEmailAndPassword(
      Future<Either<AuthFailure, Unit>> Function({
    required EmailAddress email,
    required Password password,
  })
          forwardedCall) async* {
    final isEmailValid = state.email.isValid();
    final isPasswordValid = state.password.isValid();
    Either<AuthFailure, Unit>? failureOrSuccess;

    if (isEmailValid && isPasswordValid) {
      yield state.copyWith(
        isSubmitting: true,
        authFailureOrSuccessOption: none(),
      );
      failureOrSuccess =
          await forwardedCall(email: state.email, password: state.password);
    }

    yield state.copyWith(
      isSubmitting: false,
      showErrorMessages: AutovalidateMode.always,
      authFailureOrSuccessOption: optionOf(failureOrSuccess),
    );
  }
}
