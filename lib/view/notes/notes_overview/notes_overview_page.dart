import 'package:auto_route/auto_route.dart';
import 'package:chat/controllers/auth/auth_bloc.dart';
import 'package:chat/controllers/notes/note_actor/note_actor_bloc.dart';
import 'package:chat/controllers/notes/note_watcher/note_watcher_bloc.dart';
import 'package:chat/injection.dart';
import 'package:chat/view/notes/notes_overview/widgets/overview_body.dart';
import 'package:chat/view/notes/notes_overview/widgets/uncompleted_switch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chat/view/routes/router.gr.dart';

class NotesOverviewPage extends StatelessWidget {
  const NotesOverviewPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<NoteWatcherBloc>(
          create: (context) =>
              getIt<NoteWatcherBloc>()..add(NoteWatcherEvent.watchAllStarted()),
        ),
        BlocProvider<NoteActorBloc>(
          create: (context) => getIt<NoteActorBloc>(),
        )
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<AuthBloc, AuthState>(listener: (context, state) {
            state.maybeMap(
              orElse: () {},
              onauthenticated: (_) =>
                  AutoRouter.of(context).replace(SignInRoute()),
            );
          }),
          BlocListener<NoteActorBloc, NoteActorState>(
              listener: (context, state) {
            state.maybeMap(
                orElse: () {},
                deleteFailure: (state) {
                  final snackBar = SnackBar(
                    content: Text(
                      state.noteFailure.map(
                          unexpected: (_) => 'Unexpected error occured',
                          insufficientPermission: (_) =>
                              'Insufficient permissions',
                          unableToUpdate: (_) => 'Impossible error'),
                    ),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                });
          })
        ],
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Notes'),
            leading: IconButton(
                icon: Icon(Icons.exit_to_app),
                onPressed: () {
                  context.read<AuthBloc>().add(const AuthEvent.onSignedOut());
                }),
            actions: [UncompletedSwitch()],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              AutoRouter.of(context).push(NoteFormRoute(editedNote: null));
            },
            child: Icon(Icons.add),
          ),
          body: NotesOverviewBody(),
        ),
      ),
    );
  }
}
