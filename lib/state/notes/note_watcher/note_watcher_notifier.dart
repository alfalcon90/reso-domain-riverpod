import 'dart:async';

import 'package:chat/domain/notes/note.dart';
import 'package:chat/domain/notes/note_failure.dart';
import 'package:chat/domain/notes/note_interface.dart';
import 'package:chat/state/notes/note_watcher/note_watcher_state.dart';
import 'package:dartz/dartz.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kt_dart/kt.dart';

class NoteWatcherNotifier extends StateNotifier<NoteWatcherState> {
  final INoteRepository _noteRepository;
  StreamSubscription<Either<NoteFailure, KtList<Note>>>? _noteSubscription;

  NoteWatcherNotifier(this._noteRepository)
      : super(const NoteWatcherState.initial());

  void watchAllStarted() async {
    state = const NoteWatcherState.loading();
    await _noteSubscription?.cancel();

    _noteSubscription =
        _noteRepository.watchAll().listen((notes) => notesReceived(notes));
  }

  void watchUncompletedStarted() async {
    state = const NoteWatcherState.loading();
    await _noteSubscription?.cancel();
    _noteSubscription = _noteRepository
        .watchUncompleted()
        .listen((notes) => notesReceived(notes));
  }

  void notesReceived(Either<NoteFailure, KtList<Note>> failureOrNotes) {
    state = failureOrNotes.fold((f) => NoteWatcherState.error(f),
        (notes) => NoteWatcherState.data(notes));
  }

  @override
  void dispose() async {
    await _noteSubscription?.cancel();
    super.dispose();
  }
}
