import 'package:auto_route/auto_route.dart';
import 'package:chat/controllers/auth/auth_providers.dart';
import 'package:chat/controllers/auth/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:chat/view/routes/router.gr.dart';

class SplashPage extends ConsumerWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AuthState>(authControllerProvider, (state) {
      state.maybeMap(
        orElse: () {},
        authenticated: (_) {
          AutoRouter.of(context).pushAndPopUntil(
            const NotesOverviewRoute(),
            predicate: (route) => false,
          );
        },
        unauthenticated: (_) {
          AutoRouter.of(context).pushAndPopUntil(
            const SignInRoute(),
            predicate: (route) => false,
          );
        },
      );
    });

    return Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
