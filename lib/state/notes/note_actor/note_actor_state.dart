import 'package:chat/domain/notes/note_failure.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'note_actor_state.freezed.dart';

@freezed
class NoteActorState with _$NoteActorState {
  const factory NoteActorState.initial() = _Initial;
  const factory NoteActorState.loading() = _Loading;
  const factory NoteActorState.deleteFailure(NoteFailure noteFailure) =
      _DeleteFailure;
  const factory NoteActorState.deleteSuccess() = _DeleteSuccess;
}
