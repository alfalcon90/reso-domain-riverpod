import 'package:chat/state/core/app_launch_providers.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:auto_route/auto_route.dart';
import 'package:chat/view/routes/app_router.gr.dart';

class SplashPage extends ConsumerWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AsyncValue>(appLaunchProvider, (state) {
      state.when(
        loading: () {},
        data: (_) => context.replaceRoute(AuthRouter()),
        error: (err, stack) {
          final snackBar = SnackBar(
            content: Text(err.toString()),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        },
      );
    });

    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
