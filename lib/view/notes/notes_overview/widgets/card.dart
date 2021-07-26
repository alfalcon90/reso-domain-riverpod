import 'package:chat/domain/notes/note.dart';
import 'package:chat/domain/notes/todo_item.dart';
import 'package:chat/state/notes/notes_providers.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kt_dart/kt.dart';

class NoteCard extends ConsumerWidget {
  final Note note;

  const NoteCard({Key? key, required this.note}) : super(key: key);

  void _showDeletionDialog(BuildContext context, WidgetRef ref) {
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
                  ref.read(noteActorProvider.notifier).deleted(note);
                },
                child: const Text('Delete'),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      color: note.color.getOrCrash(),
      child: InkWell(
        onTap: () {
          ref.read(noteFormProvider.notifier).edited(note);
        },
        onLongPress: () {
          _showDeletionDialog(context, ref);
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
