import 'package:auto_route/auto_route.dart';
import 'package:chat/controllers/auth/auth_bloc.dart';
import 'package:chat/injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chat/view/routes/router.gr.dart';

class App extends StatelessWidget {
  final _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) =>
                getIt<AuthBloc>()..add(const AuthEvent.onAuthCheckRequested()))
      ],
      child: MaterialApp.router(
        routerDelegate: AutoRouterDelegate(_appRouter,
            navigatorObservers: () => [AutoRouteObserver()]),
        routeInformationParser: _appRouter.defaultRouteParser(),
        title: 'Notes',
        debugShowCheckedModeBanner: false,
        theme: ThemeData.light().copyWith(
            primaryColor: Colors.green[800],
            accentColor: Colors.blueAccent,
            inputDecorationTheme: InputDecorationTheme(
                border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ))),
      ),
    );
  }
}
