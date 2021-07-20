part of 'auth_bloc.dart';

@freezed
class AuthEvent with _$AuthEvent {
  const factory AuthEvent.onAuthCheckRequested() = OnAuthCheckRequested;
  const factory AuthEvent.onSignedOut() = OnSignedOut;
}
