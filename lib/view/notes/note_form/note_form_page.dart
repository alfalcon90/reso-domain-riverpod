import 'package:auto_route/auto_route.dart';
import 'package:chat/state/notes/note_form/note_form_bloc.dart';
import 'package:chat/domain/notes/note.dart';
import 'package:chat/config/injection.dart';
import 'package:chat/view/notes/note_form/todo_item_view_classes.dart';
import 'package:chat/view/notes/note_form/widgets/add_todo_tile.dart';
import 'package:chat/view/notes/note_form/widgets/body_field.dart';
import 'package:chat/view/notes/note_form/widgets/color_field.dart';
import 'package:chat/view/notes/note_form/widgets/todo_list.dart';
import 'package:chat/view/routes/app_router.gr.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class NoteFormPage extends StatelessWidget {
  final Note? editedNote;

  const NoteFormPage({Key? key, required this.editedNote}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<NoteFormBloc>()
        ..add(NoteFormEvent.initialized(optionOf(editedNote))),
      child: BlocConsumer<NoteFormBloc, NoteFormState>(
        listenWhen: (p, c) =>
            p.saveFailureOrSuccessOption != c.saveFailureOrSuccessOption,
        listener: (context, state) {
          state.saveFailureOrSuccessOption.fold(() {}, (either) {
            either.fold((f) {
              final snackBar = SnackBar(
                content: Text(
                  f.map(
                      unexpected: (_) => 'Unexpected error occured',
                      insufficientPermission: (_) => 'Insufficient permissions',
                      unableToUpdate: (_) => 'Couldn\'t update the note'),
                ),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }, (_) {
              context.replaceRoute(NotesOverviewRoute());
            });
          });
        },
        buildWhen: (p, c) => p.isSaving != c.isSaving,
        builder: (context, state) => Stack(
          children: [
            const NoteFormPageScaffold(),
            Overlay(
              isSaving: state.isSaving,
            )
          ],
        ),
      ),
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

class NoteFormPageScaffold extends StatelessWidget {
  const NoteFormPageScaffold({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<NoteFormBloc, NoteFormState>(
          buildWhen: (p, c) => p.isEditing != c.isEditing,
          builder: (context, state) {
            return Text(state.isEditing ? 'Edit a note' : 'Create a note');
          },
        ),
        actions: [
          IconButton(
            onPressed: () {
              context.read<NoteFormBloc>().add(const NoteFormEvent.saved());
            },
            icon: Icon(Icons.check),
          )
        ],
      ),
      body: BlocBuilder<NoteFormBloc, NoteFormState>(
          buildWhen: (p, c) => p.showErrorMessages != c.showErrorMessages,
          builder: (context, state) {
            return ChangeNotifierProvider(
              create: (_) => FormTodos(),
              child: Form(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const BodyField(),
                      const ColorField(),
                      const TodoList(),
                      const AddTodoTile()
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }
}
