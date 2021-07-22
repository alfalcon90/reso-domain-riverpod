import 'package:auto_route/auto_route.dart';
import 'package:chat/state/auth/auth_providers.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:chat/view/routes/app_router.gr.dart';

class AuthRouter extends ConsumerWidget {
  const AuthRouter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);

    return AutoRouter.declarative(
      routes: (_) {
        return [
          authState.maybeMap(
              orElse: () => SignInRoute(), authenticated: (_) => HomeRouter())
        ];
      },
    );
  }
}
