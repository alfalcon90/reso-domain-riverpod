import 'package:chat/domain/core/value_objects.dart';
import 'package:chat/domain/notes/todo_item.dart';
import 'package:chat/domain/notes/value_objects.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kt_dart/kt.dart';

part 'todo_item_presentation_classes.freezed.dart';

@freezed
class TodoItemPrimitive with _$TodoItemPrimitive {
  const TodoItemPrimitive._();

  const factory TodoItemPrimitive({
    required UniqueId id,
    required String name,
    required bool done,
  }) = _TodoItemPrimitive;

  factory TodoItemPrimitive.empty() =>
      TodoItemPrimitive(id: UniqueId(), name: '', done: false);

  factory TodoItemPrimitive.fromDomain(TodoItem todoItem) {
    return TodoItemPrimitive(
      id: todoItem.id,
      name: todoItem.name.getOrCrash(),
      done: todoItem.done,
    );
  }

  TodoItem toDomain() {
    return TodoItem(
      id: id,
      name: TodoName(name),
      done: done,
    );
  }
}

class FormTodos extends ValueNotifier<KtList<TodoItemPrimitive>> {
  FormTodos() : super(emptyList<TodoItemPrimitive>());
}
