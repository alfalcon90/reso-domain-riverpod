import 'package:chat/config/injection.dart';
import 'package:chat/domain/core/value_objects.dart';
import 'package:chat/domain/notes/note_interface.dart';
import 'package:chat/state/notes/note_actor/note_actor_notifier.dart';
import 'package:chat/state/notes/note_actor/note_actor_state.dart';
import 'package:chat/state/notes/note_form/note_form_notifier.dart';
import 'package:chat/state/notes/note_form/note_form_state.dart';
import 'package:chat/state/notes/note_watcher/note_watcher_state.dart';
import 'package:chat/state/notes/note_watcher/note_watcher_notifier.dart';
import 'package:chat/view/notes/note_form/todo_item_view_classes.dart';
import 'package:dartz/dartz.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kt_dart/kt.dart';

final openedNoteProvider = StateProvider<Option<UniqueId>>((ref) => none());

final noteFormProvider = StateNotifierProvider<NoteFormNotifier, NoteFormState>(
    (ref) =>
        NoteFormNotifier(noteRepository: getIt<INoteRepository>(), ref: ref));

final noteActorProvider =
    StateNotifierProvider<NoteActorNotifier, NoteActorState>(
        (_) => NoteActorNotifier(getIt<INoteRepository>()));

final noteWatcherProvider =
    StateNotifierProvider<NoteWatcherNotifier, NoteWatcherState>(
        (_) => NoteWatcherNotifier(getIt<INoteRepository>()));

final formTodosProvider =
    StateProvider<KtList<TodoItemPrimitive>>((_) => throw UnimplementedError());
