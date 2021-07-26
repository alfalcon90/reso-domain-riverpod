import 'package:chat/domain/notes/note.dart';
import 'package:chat/domain/notes/note_failure.dart';
import 'package:chat/domain/notes/note_interface.dart';
import 'package:chat/domain/notes/value_objects.dart';
import 'package:chat/state/notes/note_form/note_form_state.dart';
import 'package:chat/state/notes/notes_providers.dart';
import 'package:chat/view/notes/note_form/todo_item_view_classes.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kt_dart/kt.dart';

class NoteFormNotifier extends StateNotifier<NoteFormState> {
  final INoteRepository noteRepository;
  final ProviderRefBase ref;

  NoteFormNotifier({
    required this.noteRepository,
    required this.ref,
  }) : super(NoteFormState.initial());

  void created() {
    state = NoteFormState.initial();
    ref.read(openedNoteProvider).state = optionOf(state.note.id);
  }

  void edited(Note note) {
    state = state.copyWith(
      note: note,
      isEditing: true,
    );

    ref.read(openedNoteProvider).state = optionOf(note.id);
  }

  void bodyChanged(String bodyStr) {
    state = state.copyWith(
      note: state.note.copyWith(
        body: NoteBody(bodyStr),
      ),
      saveFailureOrSuccessOption: none(),
    );
  }

  void colorChanged(Color color) {
    state = state.copyWith(
      note: state.note.copyWith(color: NoteColor(color)),
      saveFailureOrSuccessOption: none(),
    );
  }

  void todosChanged(KtList<TodoItemPrimitive> todos) {
    state = state.copyWith(
      note: state.note.copyWith(
        todos: List3(todos.map((primitive) => primitive.toDomain())),
      ),
      saveFailureOrSuccessOption: none(),
    );
  }

  void saved() async {
    Either<NoteFailure, Unit>? failureOrSuccess;

    state = state.copyWith(
      isSaving: true,
      saveFailureOrSuccessOption: none(),
    );

    if (state.note.failureOption.isNone()) {
      failureOrSuccess = state.isEditing
          ? await noteRepository.update(state.note)
          : await noteRepository.create(state.note);
    }

    state = state.copyWith(
        isSaving: false,
        showErrorMessages: true,
        saveFailureOrSuccessOption: optionOf(failureOrSuccess));
  }
}
