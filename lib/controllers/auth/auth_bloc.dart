import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:chat/domain/auth/auth_interface.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'auth_event.dart';
part 'auth_state.dart';
part 'auth_bloc.freezed.dart';

@injectable
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final IAuthService _authService;

  AuthBloc(this._authService) : super(const AuthState.initial());

  @override
  Stream<AuthState> mapEventToState(
    AuthEvent event,
  ) async* {
    yield* event.map(onAuthCheckRequested: (e) async* {
      final userOption = await _authService.getSignedInUser();
      yield userOption.fold(
        () => const AuthState.onauthenticated(),
        (_) => const AuthState.authenticated(),
      );
    }, onSignedOut: (e) async* {
      await _authService.signOut();
      yield const AuthState.onauthenticated();
    });
  }
}
