import 'package:chat/domain/core/value_failures.dart';
import 'package:chat/domain/core/value_objects.dart';
import 'package:chat/domain/notes/value_objects.dart';
import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'todo_item.freezed.dart';

@freezed
class TodoItem with _$TodoItem {
  const TodoItem._();

  const factory TodoItem({
    required UniqueId id,
    required TodoName name,
    required bool done,
  }) = _TodoItem;

  factory TodoItem.empty() =>
      TodoItem(id: UniqueId(), name: TodoName(''), done: false);

  Option<ValueFailure<dynamic>> get failureOption {
    return name.value.fold((f) => some(f), (_) => none());
  }
}
