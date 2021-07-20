import 'package:chat/application/auth/sign_in_form/sign_in_form_bloc.dart';
import 'package:chat/injection.dart';
import 'package:chat/presentation/auth/sign_in_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign In'),
      ),
      body: BlocProvider(
        child: const SignInForm(),
        create: (context) => getIt<SignInFormBloc>(),
      ),
    );
  }
}
