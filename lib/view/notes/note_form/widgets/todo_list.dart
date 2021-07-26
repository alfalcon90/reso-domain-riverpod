import 'dart:ui';
import 'package:chat/domain/notes/value_objects.dart';
import 'package:chat/state/notes/note_form/note_form_state.dart';
import 'package:chat/state/notes/notes_providers.dart';
import 'package:chat/view/notes/note_form/todo_item_view_classes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:implicitly_animated_reorderable_list/implicitly_animated_reorderable_list.dart';
import 'package:kt_dart/kt.dart';

class TodoList extends ConsumerWidget {
  const TodoList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formTodos = ref.watch(formTodosProvider);

    ref.listen<NoteFormState>(noteFormProvider, (state) {
      if (state.note.todos.isFull) {
        final snackBar = SnackBar(
          content: Text('Want longer lists? \nActivate premium 🤩'),
          action: SnackBarAction(
            label: 'Buy now',
            onPressed: () {},
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    });

    return ImplicitlyAnimatedReorderableList<TodoItemPrimitive>(
      items: formTodos.state.asList(),
      areItemsTheSame: (oldItem, newItem) => oldItem.id == newItem.id,
      onReorderFinished: (item, from, to, newItems) {
        formTodos.state = newItems.toImmutableList();
        ref.read(noteFormProvider.notifier).todosChanged(formTodos.state);
      },
      shrinkWrap: true,
      itemBuilder: (ctx, animation, todo, idx) {
        return Reorderable(
          key: ValueKey(todo.id),
          builder: (context, dragAnimation, inDrag) {
            final t = dragAnimation.value;
            final elevation = lerpDouble(0, 4, t);
            return ScaleTransition(
              scale: Tween<double>(begin: 1, end: 1.02).animate(dragAnimation),
              child: TodoTile(
                index: idx,
                elevation: elevation,
              ),
            );
          },
        );
      },
    );
  }
}

class TodoTile extends HookConsumerWidget {
  final int index;
  final double elevation;

  const TodoTile({Key? key, required this.index, double? elevation})
      : elevation = elevation ?? 0,
        super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formTodos = ref.watch(formTodosProvider);
    final state = ref.read(noteFormProvider);

    final todo =
        formTodos.state.getOrElse(index, (_) => TodoItemPrimitive.empty());

    final textEditingController = useTextEditingController(text: todo.name);

    return Slidable(
      actionPane: const SlidableDrawerActionPane(),
      actionExtentRatio: 0.2,
      secondaryActions: [
        IconSlideAction(
          caption: 'Delete',
          icon: Icons.delete,
          color: Colors.red,
          onTap: () {
            formTodos.state = formTodos.state.minusElement(todo);
            ref.read(noteFormProvider.notifier).todosChanged(formTodos.state);
          },
        )
      ],
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        child: Material(
          elevation: elevation,
          animationDuration: const Duration(milliseconds: 50),
          borderRadius: BorderRadius.circular(8),
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8)),
            child: ListTile(
              trailing: const Handle(
                child: Icon(Icons.list),
              ),
              leading: Checkbox(
                value: todo.done,
                onChanged: (val) {
                  formTodos.state = formTodos.state.map((listTodo) =>
                      listTodo == todo ? todo.copyWith(done: val!) : listTodo);
                  ref
                      .read(noteFormProvider.notifier)
                      .todosChanged(formTodos.state);
                },
              ),
              title: TextFormField(
                controller: textEditingController,
                decoration: InputDecoration(
                  hintText: 'Todo',
                  border: InputBorder.none,
                  counterText: '',
                ),
                maxLength: TodoName.maxLength,
                onChanged: (val) {
                  formTodos.state = formTodos.state.map((listTodo) =>
                      listTodo == todo ? todo.copyWith(name: val) : listTodo);
                  ref
                      .read(noteFormProvider.notifier)
                      .todosChanged(formTodos.state);
                },
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (_) {
                  return state.note.todos.value.fold(
                      (_) {},
                      (todoList) => todoList[index].name.value.fold(
                          (f) => f.maybeMap(
                              orElse: () {},
                              notes: (noteFailure) => noteFailure.f.maybeMap(
                                  exceedingLength: (_) => 'Too long',
                                  empty: (_) => 'Cannot be empty',
                                  multiline: (_) =>
                                      'Has to be in a single line',
                                  orElse: () {})),
                          (_) {}));
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
