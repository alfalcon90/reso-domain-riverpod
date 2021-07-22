import 'package:chat/state/auth/auth_state.dart';
import 'package:chat/domain/auth/auth_interface.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AuthController extends StateNotifier<AuthState> {
  final IAuthService _authService;

  AuthController(this._authService) : super(const AuthState.initial());

  Future<void> onAuthCheckRequested() async {
    final userOption = await _authService.getSignedInUser();
    state = userOption.fold(
      () => const AuthState.unauthenticated(),
      (_) => const AuthState.authenticated(),
    );
  }

  void onSignOutPressed() async {
    await _authService.signOut();
    state = const AuthState.unauthenticated();
  }
}
