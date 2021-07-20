import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:chat/domain/notes/note.dart';
import 'package:chat/domain/notes/note_failure.dart';
import 'package:chat/domain/notes/note_interface.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:kt_dart/collection.dart';
import 'package:dartz/dartz.dart';

part 'note_watcher_event.dart';
part 'note_watcher_state.dart';
part 'note_watcher_bloc.freezed.dart';

@injectable
class NoteWatcherBloc extends Bloc<NoteWatcherEvent, NoteWatcherState> {
  final INoteRepository _noteRepository;
  StreamSubscription<Either<NoteFailure, KtList<Note>>>? _noteSubscription;

  NoteWatcherBloc(this._noteRepository)
      : super(const NoteWatcherState.initial());

  @override
  Stream<NoteWatcherState> mapEventToState(
    NoteWatcherEvent event,
  ) async* {
    yield* event.map(
      watchAllStarted: (e) async* {
        yield const NoteWatcherState.loading();
        await _noteSubscription?.cancel();
        _noteSubscription = _noteRepository
            .watchAll()
            .listen((notes) => add(NoteWatcherEvent.notesReceived(notes)));
      },
      watchUncompletedStarted: (e) async* {
        yield const NoteWatcherState.loading();
        await _noteSubscription?.cancel();
        _noteSubscription = _noteRepository
            .watchUncompleted()
            .listen((notes) => add(NoteWatcherEvent.notesReceived(notes)));
      },
      notesReceived: (e) async* {
        yield e.failureOrNotes.fold((f) => NoteWatcherState.error(f),
            (notes) => NoteWatcherState.data(notes));
      },
    );
  }

  @override
  Future<void> close() async {
    await _noteSubscription?.cancel();
    return super.close();
  }
}
