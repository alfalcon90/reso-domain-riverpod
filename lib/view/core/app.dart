import 'package:auto_route/auto_route.dart';
import 'package:chat/state/auth/auth_providers.dart';
import 'package:chat/state/core/app_launch_providers.dart';
import 'package:flutter/material.dart';
import 'package:chat/view/routes/app_router.gr.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class App extends ConsumerWidget {
  final _appRouter = AppRouter();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final launchState = ref.watch(appLaunchProvider);
    final authState = ref.watch(authProvider);

    return MaterialApp.router(
      title: 'Notes',
      routerDelegate: AutoRouterDelegate.declarative(
        _appRouter,
        routes: (_) => [
          launchState.maybeMap(
              orElse: () => SplashRoute(),
              data: (_) => authState.maybeMap(
                  orElse: () => SignInRoute(),
                  authenticated: (_) => NotesRouter()))
        ],
      ),
      routeInformationParser: _appRouter.defaultRouteParser(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light().copyWith(
          primaryColor: Colors.green[800],
          accentColor: Colors.blueAccent,
          inputDecorationTheme: InputDecorationTheme(
              border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ))),
    );
  }
}
