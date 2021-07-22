import 'dart:ui';
import 'package:chat/state/notes/note_form/note_form_bloc.dart';
import 'package:chat/domain/notes/value_objects.dart';
import 'package:chat/view/notes/note_form/todo_item_view_classes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:implicitly_animated_reorderable_list/implicitly_animated_reorderable_list.dart';
import 'package:provider/provider.dart';
import 'package:chat/view/notes/note_form/build_context_x.dart';
import 'package:kt_dart/kt.dart';

class TodoList extends StatelessWidget {
  const TodoList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<NoteFormBloc, NoteFormState>(
      listenWhen: (p, c) => p.note.todos.isFull != c.note.todos.isFull,
      listener: (context, state) {
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
      },
      child: Consumer<FormTodos>(
        builder: (context, formTodos, _) {
          return ImplicitlyAnimatedReorderableList<TodoItemPrimitive>(
            items: formTodos.value.asList(),
            areItemsTheSame: (oldItem, newItem) => oldItem.id == newItem.id,
            onReorderFinished: (item, from, to, newItems) {
              context.formTodos = newItems.toImmutableList();
              context
                  .read<NoteFormBloc>()
                  .add(NoteFormEvent.todosChanged(context.formTodos));
            },
            shrinkWrap: true,
            itemBuilder: (ctx, animation, todo, idx) {
              return Reorderable(
                key: ValueKey(todo.id),
                builder: (context, dragAnimation, inDrag) {
                  final t = dragAnimation.value;
                  final elevation = lerpDouble(0, 4, t);
                  return ScaleTransition(
                    scale: Tween<double>(begin: 1, end: 1.02)
                        .animate(dragAnimation),
                    child: TodoTile(
                      index: idx,
                      elevation: elevation,
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

class TodoTile extends HookWidget {
  final int index;
  final double elevation;

  const TodoTile({Key? key, required this.index, double? elevation})
      : elevation = elevation ?? 0,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final todo =
        context.formTodos.getOrElse(index, (_) => TodoItemPrimitive.empty());

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
            context.formTodos = context.formTodos.minusElement(todo);
            context
                .read<NoteFormBloc>()
                .add(NoteFormEvent.todosChanged(context.formTodos));
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
                  context.formTodos = context.formTodos.map((listTodo) =>
                      listTodo == todo ? todo.copyWith(done: val!) : listTodo);
                  context
                      .read<NoteFormBloc>()
                      .add(NoteFormEvent.todosChanged(context.formTodos));
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
                  context.formTodos = context.formTodos.map((listTodo) =>
                      listTodo == todo ? todo.copyWith(name: val) : listTodo);
                  context
                      .read<NoteFormBloc>()
                      .add(NoteFormEvent.todosChanged(context.formTodos));
                },
                autovalidateMode: AutovalidateMode.always,
                validator: (_) {
                  return context
                      .read<NoteFormBloc>()
                      .state
                      .note
                      .todos
                      .value
                      .fold(
                          (_) => null,
                          (todoList) => todoList[index].name.value.fold(
                              (f) => f.maybeMap(
                                  orElse: () {},
                                  notes: (noteFailure) => noteFailure.f
                                      .maybeMap(
                                          exceedingLength: (_) => 'Too long',
                                          empty: (_) => 'Cannot be empty',
                                          multiline: (_) =>
                                              'Has to be in a single line',
                                          orElse: () {})),
                              (_) => null));
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
