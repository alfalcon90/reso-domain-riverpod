import 'package:auto_route/auto_route.dart';
import 'package:chat/application/auth/auth_bloc.dart';
import 'package:chat/application/auth/sign_in_form/sign_in_form_bloc.dart';
import 'package:flutter/material.dart';
import 'package:chat/presentation/routes/router.gr.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignInForm extends StatelessWidget {
  const SignInForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignInFormBloc, SignInFormState>(
        builder: (context, state) {
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
              onChanged: (val) => context
                  .read<SignInFormBloc>()
                  .add(SignInFormEvent.onEmailChanged(val)),
              validator: (_) =>
                  context.read<SignInFormBloc>().state.email.value.fold(
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
              onChanged: (val) => context
                  .read<SignInFormBloc>()
                  .add(SignInFormEvent.onPasswordChanged(val)),
              validator: (_) =>
                  context.read<SignInFormBloc>().state.password.value.fold(
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
                    onPressed: () {
                      context
                          .read<SignInFormBloc>()
                          .add(const SignInFormEvent.onSignInPressed());
                    },
                    child: const Text('Sign In'),
                  ),
                ),
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      context
                          .read<SignInFormBloc>()
                          .add(const SignInFormEvent.onRegisterPressed());
                    },
                    child: const Text('Register'),
                  ),
                )
              ],
            ),
            ElevatedButton(
              onPressed: () {
                context
                    .read<SignInFormBloc>()
                    .add(const SignInFormEvent.onGooglePressed());
              },
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
    }, listener: (context, state) {
      state.authFailureOrSuccessOption.fold(
          () {},
          (either) => either.fold((failure) {
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
              }, (_) {
                AutoRouter.of(context).replace(NotesOverviewRoute());
                context
                    .read<AuthBloc>()
                    .add(const AuthEvent.onAuthCheckRequested());
              }));
    });
  }
}
