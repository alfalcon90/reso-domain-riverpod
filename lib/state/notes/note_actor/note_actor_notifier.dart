import 'package:chat/domain/notes/note.dart';
import 'package:chat/domain/notes/note_interface.dart';
import 'package:chat/state/notes/note_actor/note_actor_state.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class NoteActorNotifier extends StateNotifier<NoteActorState> {
  final INoteRepository _noteRepository;

  NoteActorNotifier(this._noteRepository) : super(NoteActorState.initial());

  void deleted(Note note) async {
    state = const NoteActorState.loading();
    final possibleFailure = await _noteRepository.delete(note);
    state = possibleFailure.fold((f) => NoteActorState.deleteFailure(f),
        (_) => NoteActorState.deleteSuccess());
  }
}
