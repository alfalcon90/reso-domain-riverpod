import 'package:auto_route/auto_route.dart';
import 'package:chat/state/notes/notes_providers.dart';
import 'package:flutter/material.dart';
import 'package:chat/view/routes/app_router.gr.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class NotesRouter extends ConsumerWidget {
  const NotesRouter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final openedNote = ref.watch(openedNoteProvider);

    return AutoRouter.declarative(routes: (_) {
      return [
        NotesOverviewRoute(),
        if (openedNote.state.isSome()) NoteFormRoute()
      ];
    });
  }
}
