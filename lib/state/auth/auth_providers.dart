import 'package:chat/state/auth/auth_state.dart';
import 'package:chat/state/auth/auth_controller.dart';
import 'package:chat/domain/auth/auth_interface.dart';
import 'package:chat/config/injection.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final authControllerProvider = StateNotifierProvider<AuthController, AuthState>(
    (ref) => AuthController(getIt<IAuthService>()));
