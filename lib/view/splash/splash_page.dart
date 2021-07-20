import 'package:auto_route/auto_route.dart';
import 'package:chat/controllers/auth/auth_bloc.dart';
import 'package:chat/view/routes/router.gr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
        child: const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
        listener: (context, state) {
          state.map(
            initial: (_) {},
            authenticated: (_) =>
                AutoRouter.of(context).replace(NotesOverviewRoute()),
            onauthenticated: (_) =>
                AutoRouter.of(context).replace(SignInRoute()),
          );
        });
  }
}
