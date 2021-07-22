import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:chat/domain/notes/note.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:chat/domain/notes/note_failure.dart';
import 'package:chat/domain/notes/note_interface.dart';
import 'package:injectable/injectable.dart';

part 'note_actor_bloc.freezed.dart';
part 'note_actor_event.dart';
part 'note_actor_state.dart';

@injectable
class NoteActorBloc extends Bloc<NoteActorEvent, NoteActorState> {
  final INoteRepository _noteRepository;

  NoteActorBloc(
    this._noteRepository,
  ) : super(const NoteActorState.initial());

  @override
  Stream<NoteActorState> mapEventToState(
    NoteActorEvent event,
  ) async* {
    yield const NoteActorState.loading();
    final possibleFailure = await _noteRepository.delete(event.note);
    yield possibleFailure.fold((f) => NoteActorState.deleteFailure(f),
        (_) => NoteActorState.deleteSuccess());
  }
}
