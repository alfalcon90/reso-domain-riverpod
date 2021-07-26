import 'package:chat/state/notes/notes_providers.dart';
import 'package:chat/view/notes/notes_overview/widgets/card.dart';
import 'package:chat/view/notes/notes_overview/widgets/critical_failure.dart';
import 'package:chat/view/notes/notes_overview/widgets/error_card.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class NotesOverviewBody extends ConsumerWidget {
  const NotesOverviewBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(noteWatcherProvider);

    return state.map(
        initial: (_) => Container(),
        loading: (_) => const Center(child: CircularProgressIndicator()),
        data: (state) {
          return ListView.builder(
            itemBuilder: (context, index) {
              final note = state.notes[index];
              if (note.failureOption.isSome()) {
                return ErrorNoteCard(note: note);
              } else {
                return NoteCard(note: note);
              }
            },
            itemCount: state.notes.size,
          );
        },
        error: (state) {
          return CriticalFailure(failure: state.noteFailure);
        });
  }
}
