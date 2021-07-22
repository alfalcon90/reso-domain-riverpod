import 'package:chat/state/auth/sign_in_form/sign_in_form_controller.dart';
import 'package:chat/state/auth/sign_in_form/sign_in_form_state.dart';
import 'package:chat/domain/auth/auth_interface.dart';
import 'package:chat/config/injection.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final signInFormControllerProvider =
    StateNotifierProvider<SignInFormController, SignInFormState>(
        (ref) => SignInFormController(getIt<IAuthService>()));
