import 'package:chat/controllers/auth/auth_providers.dart';
import 'package:chat/view/auth/sign_in_page.dart';
import 'package:chat/view/notes/notes_overview/notes_overview_page.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AuthCheck extends ConsumerWidget {
  const AuthCheck({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);

    return authState.map(
      initial: (_) => const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
      authenticated: (_) => NotesOverviewPage(),
      unauthenticated: (_) => SignInPage(),
    );
  }
}
