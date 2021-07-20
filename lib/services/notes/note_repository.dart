import 'package:chat/domain/notes/note_failure.dart';
import 'package:chat/domain/notes/note.dart';
import 'package:chat/domain/notes/note_interface.dart';
import 'package:chat/services/notes/note_dtos.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:dartz/dartz.dart';
import 'package:chat/services/core/firestore_helpers.dart';
import 'package:kt_dart/kt.dart';
import 'package:rxdart/rxdart.dart';

@LazySingleton(as: INoteRepository)
class NoteRepository implements INoteRepository {
  final FirebaseFirestore _firestore;

  NoteRepository(this._firestore);

  @override
  Stream<Either<NoteFailure, KtList<Note>>> watchAll() async* {
    final userDoc = await _firestore.userDocument();
    yield* userDoc.noteCollection
        .orderBy('serverTimeStamp', descending: true)
        .snapshots()
        .map(
          (snapshot) => right<NoteFailure, KtList<Note>>(
            snapshot.docs
                .map((doc) => NoteDTO.fromFirestore(doc).toDomain())
                .toImmutableList(),
          ),
        )
        .onErrorReturnWith((err, _) {
      if (err is FirebaseException &&
          err.message!.contains('PERMISSION_DENIED')) {
        return left(NoteFailure.insufficientPermission());
      } else {
        return left(NoteFailure.unexpected());
      }
    });
  }

  @override
  Stream<Either<NoteFailure, KtList<Note>>> watchUncompleted() async* {
    final userDoc = await _firestore.userDocument();
    yield* userDoc.noteCollection
        .orderBy('serverTimeStamp', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => NoteDTO.fromFirestore(doc).toDomain()))
        .map((notes) => right<NoteFailure, KtList<Note>>(
              notes
                  .where((note) =>
                      note.todos.getOrCrash().any((todoItem) => !todoItem.done))
                  .toImmutableList(),
            ))
        .onErrorReturnWith((err, _) {
      if (err is FirebaseException &&
          err.message!.contains('PERMISSION_DENIED')) {
        return left(NoteFailure.insufficientPermission());
      } else {
        return left(NoteFailure.unexpected());
      }
    });
  }

  @override
  Future<Either<NoteFailure, Unit>> create(Note note) async {
    try {
      final userDoc = await _firestore.userDocument();
      final noteDTO = NoteDTO.fromDomain(note);

      await userDoc.noteCollection.doc(noteDTO.id).set(noteDTO.toJson());

      return right(unit);
    } on FirebaseException catch (err) {
      if (err.message!.contains('PERMISSION_DENIED')) {
        return left(NoteFailure.insufficientPermission());
      } else {
        return left(NoteFailure.unexpected());
      }
    }
  }

  @override
  Future<Either<NoteFailure, Unit>> update(Note note) async {
    try {
      final userDoc = await _firestore.userDocument();
      final noteDTO = NoteDTO.fromDomain(note);

      await userDoc.noteCollection.doc(noteDTO.id).update(noteDTO.toJson());

      return right(unit);
    } on FirebaseException catch (err) {
      if (err.message!.contains('PERMISSION_DENIED')) {
        return left(NoteFailure.insufficientPermission());
      } else if (err.message!.contains('NOT_FOUND')) {
        return left(NoteFailure.unableToUpdate());
      } else {
        return left(NoteFailure.unexpected());
      }
    }
  }

  @override
  Future<Either<NoteFailure, Unit>> delete(Note note) async {
    try {
      final userDoc = await _firestore.userDocument();
      final noteId = note.id.getOrCrash();

      await userDoc.noteCollection.doc(noteId).delete();

      return right(unit);
    } on FirebaseException catch (err) {
      if (err.message!.contains('PERMISSION_DENIED')) {
        return left(NoteFailure.insufficientPermission());
      } else if (err.message!.contains('NOT_FOUND')) {
        return left(NoteFailure.unableToUpdate());
      } else {
        return left(NoteFailure.unexpected());
      }
    }
  }
}
