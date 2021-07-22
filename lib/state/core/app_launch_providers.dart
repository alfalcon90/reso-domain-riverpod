import 'package:chat/state/auth/auth_providers.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final appLaunchProvider = FutureProvider<void>((ref) async {
  final authProvider = ref.read(authControllerProvider.notifier);
  await authProvider.onAuthCheckRequested();
  return;
});
