import 'package:chat/state/auth/auth_providers.dart';
import 'package:chat/state/notes/note_actor/note_actor_state.dart';
import 'package:chat/state/notes/notes_providers.dart';
import 'package:chat/view/notes/notes_overview/widgets/overview_body.dart';
import 'package:chat/view/notes/notes_overview/widgets/uncompleted_switch.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class NotesOverviewPage extends ConsumerWidget {
  const NotesOverviewPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<NoteActorState>(noteActorProvider, (state) {
      state.maybeMap(
          orElse: () {},
          deleteFailure: (state) {
            final snackBar = SnackBar(
              content: Text(
                state.noteFailure.map(
                    unexpected: (_) => 'Unexpected error occured',
                    insufficientPermission: (_) => 'Insufficient permissions',
                    unableToUpdate: (_) => 'Impossible error'),
              ),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          });
    });

    return Scaffold(
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
    );
  }
}
