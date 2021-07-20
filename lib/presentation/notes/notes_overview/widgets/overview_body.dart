import 'package:chat/application/notes/note_watcher/note_watcher_bloc.dart';
import 'package:chat/presentation/notes/notes_overview/widgets/card.dart';
import 'package:chat/presentation/notes/notes_overview/widgets/critical_failure.dart';
import 'package:chat/presentation/notes/notes_overview/widgets/error_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotesOverviewBody extends StatelessWidget {
  const NotesOverviewBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NoteWatcherBloc, NoteWatcherState>(
        builder: (context, state) {
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
    });
  }
}
