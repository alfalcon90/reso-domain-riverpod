import 'package:auto_route/auto_route.dart';
import 'package:chat/state/auth/auth_providers.dart';
import 'package:chat/state/core/app_launch_providers.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:chat/view/routes/app_router.gr.dart';

class RootRouter extends ConsumerWidget {
  const RootRouter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final launchState = ref.watch(appLaunchProvider);
    final authState = ref.watch(authControllerProvider);

    return AutoRouter.declarative(
      routes: (_) {
        return [
          launchState.maybeMap(
              orElse: () => SplashRoute(),
              data: (_) => authState.maybeMap(
                  orElse: () => SignInRoute(),
                  authenticated: (_) => NotesRouter()))
        ];
      },
    );
  }
}
