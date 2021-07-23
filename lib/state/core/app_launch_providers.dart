import 'package:chat/state/auth/auth_providers.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final appLaunchProvider = FutureProvider<void>((ref) async {
  final authNotifier = ref.read(authProvider.notifier);
  await authNotifier.onAuthCheckRequested();
  return;
});
