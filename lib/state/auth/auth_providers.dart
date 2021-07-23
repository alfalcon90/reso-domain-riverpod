import 'package:chat/state/auth/auth_state.dart';
import 'package:chat/state/auth/auth_notifier.dart';
import 'package:chat/domain/auth/auth_interface.dart';
import 'package:chat/config/injection.dart';
import 'package:chat/state/auth/sign_in_form_notifier.dart';
import 'package:chat/state/auth/sign_in_form_state.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>(
    (ref) => AuthNotifier(getIt<IAuthService>()));

final signInFormProvider =
    StateNotifierProvider<SignInFormNotifier, SignInFormState>(
        (ref) => SignInFormNotifier(getIt<IAuthService>()));
