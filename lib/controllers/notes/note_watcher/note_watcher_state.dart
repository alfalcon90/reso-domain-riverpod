part of 'note_watcher_bloc.dart';

@freezed
class NoteWatcherState with _$NoteWatcherState {
  const factory NoteWatcherState.initial() = _Initial;
  const factory NoteWatcherState.loading() = _Loading;
  const factory NoteWatcherState.data(KtList<Note> notes) = _Data;
  const factory NoteWatcherState.error(NoteFailure noteFailure) = _Error;
}
