import 'package:auto_route/auto_route.dart';
import 'package:chat/controllers/notes/note_actor/note_actor_bloc.dart';
import 'package:chat/domain/notes/note.dart';
import 'package:chat/domain/notes/todo_item.dart';
import 'package:flutter/material.dart';
import 'package:kt_dart/kt.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chat/view/routes/router.gr.dart';

class NoteCard extends StatelessWidget {
  final Note note;

  const NoteCard({Key? key, required this.note}) : super(key: key);

  void _showDeletionDialog(BuildContext context, NoteActorBloc noteActorBloc) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Selected note:'),
            content: Text(
              note.body.getOrCrash(),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  noteActorBloc.add(NoteActorEvent.deleted(note));
                },
                child: const Text('Delete'),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: note.color.getOrCrash(),
      child: InkWell(
        onTap: () {
          AutoRouter.of(context).push(NoteFormRoute(editedNote: note));
        },
        onLongPress: () {
          final noteActorBloc = context.read<NoteActorBloc>();
          _showDeletionDialog(context, noteActorBloc);
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                note.body.getOrCrash(),
                style: TextStyle(fontSize: 18),
              ),
              if (note.todos.length > 0) ...[
                const SizedBox(
                  height: 4,
                ),
                Wrap(
                  spacing: 8,
                  children: [
                    ...note.todos
                        .getOrCrash()
                        .map(((todo) => TodoDisplay(todo: todo)))
                        .iter
                  ],
                )
              ]
            ],
          ),
        ),
      ),
    );
  }
}

class TodoDisplay extends StatelessWidget {
  final TodoItem todo;

  const TodoDisplay({Key? key, required this.todo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (todo.done)
          Icon(
            Icons.check_box,
            color: Theme.of(context).accentColor,
          ),
        if (!todo.done)
          Icon(
            Icons.check_box_outline_blank,
            color: Theme.of(context).disabledColor,
          ),
        Text(todo.name.getOrCrash())
      ],
    );
  }
}
