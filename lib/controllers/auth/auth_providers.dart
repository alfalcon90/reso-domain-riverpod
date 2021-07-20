import 'package:chat/controllers/auth/auth_state.dart';
import 'package:chat/controllers/auth/auth_controller.dart';
import 'package:chat/domain/auth/auth_interface.dart';
import 'package:chat/injection.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final authControllerProvider = StateNotifierProvider<AuthController, AuthState>(
    (ref) => AuthController(getIt<IAuthService>()));
