import 'package:chat/state/auth/auth_providers.dart';
import 'package:chat/state/notes/note_actor/note_actor_bloc.dart';
import 'package:chat/state/notes/note_watcher/note_watcher_bloc.dart';
import 'package:chat/config/injection.dart';
import 'package:chat/state/notes/notes_providers.dart';
import 'package:chat/view/notes/notes_overview/widgets/overview_body.dart';
import 'package:chat/view/notes/notes_overview/widgets/uncompleted_switch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class NotesOverviewPage extends ConsumerWidget {
  const NotesOverviewPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                  ref.read(authProvider.notifier).onSignOutPressed();
                }),
            actions: [UncompletedSwitch()],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              ref.read(noteFormProvider.notifier).created();
            },
            child: Icon(Icons.add),
          ),
          body: NotesOverviewBody(),
        ),
      ),
    );
  }
}
