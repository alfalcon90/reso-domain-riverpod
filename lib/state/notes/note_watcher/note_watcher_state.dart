import 'package:chat/domain/notes/note.dart';
import 'package:chat/domain/notes/note_failure.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kt_dart/kt.dart';

part 'note_watcher_state.freezed.dart';

@freezed
class NoteWatcherState with _$NoteWatcherState {
  const factory NoteWatcherState.initial() = _Initial;
  const factory NoteWatcherState.loading() = _Loading;
  const factory NoteWatcherState.data(KtList<Note> notes) = _Data;
  const factory NoteWatcherState.error(NoteFailure noteFailure) = _Error;
}
