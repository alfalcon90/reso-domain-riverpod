import 'package:chat/state/notes/note_form/note_form_state.dart';
import 'package:chat/state/notes/notes_providers.dart';
import 'package:chat/view/notes/note_form/todo_item_view_classes.dart';
import 'package:chat/view/notes/note_form/widgets/add_todo_tile.dart';
import 'package:chat/view/notes/note_form/widgets/body_field.dart';
import 'package:chat/view/notes/note_form/widgets/color_field.dart';
import 'package:chat/view/notes/note_form/widgets/todo_list.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kt_dart/kt.dart';

class NoteFormPage extends ConsumerWidget {
  const NoteFormPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.read(noteFormProvider);

    ref.listen<NoteFormState>(noteFormProvider, (state) {
      state.saveFailureOrSuccessOption.fold(() {}, (either) {
        either.fold((f) {
          final snackBar = SnackBar(
            content: Text(
              f.map(
                unexpected: (_) => 'Unexpected error occured',
                insufficientPermission: (_) => 'Insufficient permissions',
                unableToUpdate: (_) => 'Couldn\'t update the note',
              ),
            ),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }, (_) {
          ref.read(openedNoteProvider).state = none();
        });
      });
    });

    return Stack(
      children: [
        NoteFormPageScaffold(state),
        Overlay(
          isSaving: state.isSaving,
        )
      ],
    );
  }
}

class Overlay extends StatelessWidget {
  final bool isSaving;

  const Overlay({
    Key? key,
    required this.isSaving,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: !isSaving,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        color: isSaving ? Colors.black.withOpacity(0.8) : Colors.transparent,
        width: double.infinity,
        child: Visibility(
          visible: isSaving,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 8),
              Text(
                'Saving',
                style: Theme.of(context)
                    .textTheme
                    .bodyText2!
                    .copyWith(color: Colors.white, fontSize: 16),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class NoteFormPageScaffold extends ConsumerWidget {
  final NoteFormState state;

  const NoteFormPageScaffold(
    this.state, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(state.isEditing ? 'Edit a note' : 'Create a note'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            ref.read(openedNoteProvider).state = none();
          },
        ),
        actions: [
          IconButton(
            onPressed: () {
              ref.read(noteFormProvider.notifier).saved();
            },
            icon: Icon(Icons.check),
          )
        ],
      ),
      body: Form(
        child: SingleChildScrollView(
          child: ProviderScope(
            overrides: [
              formTodosProvider.overrideWithValue(StateController(
                  state.note.todos.value.fold(
                      (_) => emptyList<TodoItemPrimitive>(),
                      (todoItemList) => todoItemList
                          .map((todo) => TodoItemPrimitive.fromDomain(todo))))),
            ],
            child: Column(
              children: [
                const BodyField(),
                const ColorField(),
                const TodoList(),
                const AddTodoTile(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
