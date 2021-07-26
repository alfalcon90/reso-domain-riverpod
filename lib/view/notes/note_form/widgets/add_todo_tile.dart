import 'package:chat/state/notes/notes_providers.dart';
import 'package:chat/view/notes/note_form/todo_item_view_classes.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kt_dart/kt.dart';

class AddTodoTile extends ConsumerWidget {
  const AddTodoTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formTodos = ref.watch(formTodosProvider);
    final state = ref.watch(noteFormProvider);

    return ListTile(
      enabled: !state.note.todos.isFull,
      title: const Text('Add a todo'),
      leading: const Padding(
        padding: EdgeInsets.all(12.0),
        child: Icon(Icons.add),
      ),
      onTap: () {
        formTodos.state =
            formTodos.state.plusElement(TodoItemPrimitive.empty());
        ref.read(noteFormProvider.notifier).todosChanged(formTodos.state);
      },
    );
  }
}
