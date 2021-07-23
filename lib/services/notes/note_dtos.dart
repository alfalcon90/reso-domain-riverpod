// ignore_for_file: invalid_annotation_target

import 'package:chat/domain/core/value_objects.dart';
import 'package:chat/domain/notes/note.dart';
import 'package:chat/domain/notes/todo_item.dart';
import 'package:chat/domain/notes/value_objects.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kt_dart/kt.dart';

part 'note_dtos.freezed.dart';
part 'note_dtos.g.dart';

@freezed
class NoteDTO with _$NoteDTO {
  const NoteDTO._();

  const factory NoteDTO({
    @JsonKey(ignore: true) String? id,
    required String body,
    required int color,
    required List<TodoItemDTO> todos,
    @ServerTimeStampConverter() required FieldValue serverTimeStamp,
  }) = _NoteDTO;

  factory NoteDTO.fromDomain(Note note) {
    return NoteDTO(
      id: note.id.getOrCrash(),
      body: note.body.getOrCrash(),
      color: note.color.getOrCrash().value,
      todos: note.todos
          .getOrCrash()
          .map((todoItem) => TodoItemDTO.fromDomain(todoItem))
          .asList(),
      serverTimeStamp: FieldValue.serverTimestamp(),
    );
  }

  Note toDomain() {
    return Note(
      id: UniqueId.fromUniqueString(id!),
      body: NoteBody(body),
      color: NoteColor(Color(color)),
      todos: List3(todos.map((dto) => dto.toDomain()).toImmutableList()),
    );
  }

  factory NoteDTO.fromJson(Map<String, dynamic> json) =>
      _$NoteDTOFromJson(json);

  factory NoteDTO.fromFirestore(DocumentSnapshot doc) {
    return NoteDTO.fromJson(doc.data() as Map<String, dynamic>)
        .copyWith(id: doc.id);
  }
}

class ServerTimeStampConverter implements JsonConverter<FieldValue, Object?> {
  const ServerTimeStampConverter();

  @override
  FieldValue fromJson(Object? json) {
    return FieldValue.serverTimestamp();
  }

  @override
  Object toJson(FieldValue fieldValue) => fieldValue;
}

@freezed
class TodoItemDTO with _$TodoItemDTO {
  const TodoItemDTO._();

  const factory TodoItemDTO({
    required String id,
    required String name,
    required bool done,
  }) = _TodoItemDTO;

  factory TodoItemDTO.fromDomain(TodoItem todoItem) {
    return TodoItemDTO(
      id: todoItem.id.getOrCrash(),
      name: todoItem.name.getOrCrash(),
      done: todoItem.done,
    );
  }

  TodoItem toDomain() {
    return TodoItem(
      id: UniqueId.fromUniqueString(id),
      name: TodoName(name),
      done: done,
    );
  }

  factory TodoItemDTO.fromJson(Map<String, dynamic> json) =>
      _$TodoItemDTOFromJson(json);
}
