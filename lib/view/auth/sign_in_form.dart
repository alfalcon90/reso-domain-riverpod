import 'package:chat/state/auth/auth_providers.dart';
import 'package:chat/state/auth/sign_in_form/sign_in_form_providers.dart';
import 'package:chat/state/auth/sign_in_form/sign_in_form_state.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SignInForm extends ConsumerWidget {
  const SignInForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(signInFormControllerProvider);

    ref.listen<SignInFormState>(signInFormControllerProvider, (state) {
      state.authFailureOrSuccessOption.fold(
        () {},
        (either) => either.fold(
          (failure) {
            final snackBar = SnackBar(
              content: Text(
                failure.map(
                    cancelledByUser: (_) => 'Cancelled',
                    serverError: (_) => 'Server error',
                    emailAlreadyInUse: (_) => 'Email already in use',
                    invalidCredentials: (_) =>
                        'Invalid email and password combination'),
              ),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          },
          (_) {
            ref.read(authControllerProvider.notifier).onAuthCheckRequested();
          },
        ),
      );
    });

    return Form(
      autovalidateMode: state.showErrorMessages,
      child: ListView(
        padding: const EdgeInsets.all(8),
        children: [
          const Text(
            '📝',
            style: TextStyle(fontSize: 120),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 8,
          ),
          TextFormField(
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.email),
              labelText: 'Email',
            ),
            autocorrect: false,
            onChanged: (val) => ref
                .read(signInFormControllerProvider.notifier)
                .onEmailChanged(val),
            validator: (_) => state.email.value.fold(
              (failure) => failure.maybeMap(
                auth: (_) => "Invalid Email",
                orElse: () => null,
              ),
              (_) => null,
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          TextFormField(
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.lock),
              labelText: 'Password',
            ),
            autocorrect: false,
            obscureText: true,
            onChanged: (val) => ref
                .read(signInFormControllerProvider.notifier)
                .onPasswordChanged(val),
            validator: (_) => state.password.value.fold(
              (failure) => failure.maybeMap(
                auth: (_) => "Short Password",
                orElse: () => null,
              ),
              (_) => null,
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () => ref
                      .read(signInFormControllerProvider.notifier)
                      .onSignInPressed(),
                  child: const Text('Sign In'),
                ),
              ),
              Expanded(
                child: TextButton(
                  onPressed: () => ref
                      .read(signInFormControllerProvider.notifier)
                      .onRegisterPressed(),
                  child: const Text('Register'),
                ),
              )
            ],
          ),
          ElevatedButton(
            onPressed: () => ref
                .read(signInFormControllerProvider.notifier)
                .onGoogleSignInPressed(),
            child: const Text('Sign in with Google'),
          ),
          if (state.isSubmitting) ...[
            const SizedBox(
              height: 8,
            ),
            const LinearProgressIndicator(
              value: null,
            )
          ]
        ],
      ),
    );
  }
}
