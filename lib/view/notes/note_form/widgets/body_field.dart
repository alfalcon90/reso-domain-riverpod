import 'package:chat/domain/notes/value_objects.dart';
import 'package:chat/state/notes/notes_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class BodyField extends HookConsumerWidget {
  const BodyField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(noteFormProvider);

    final textEditingController = useTextEditingController(
        text: state.isEditing ? state.note.body.getOrCrash() : '');

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: textEditingController,
        decoration: InputDecoration(labelText: 'Note', counterText: ''),
        maxLength: NoteBody.maxLength,
        maxLines: null,
        minLines: 5,
        onChanged: (value) =>
            ref.read(noteFormProvider.notifier).bodyChanged(value),
        validator: (_) => state.note.body.value.fold(
            (f) => f.maybeMap(
                  orElse: () {},
                  notes: (noteFailure) => noteFailure.f.maybeMap(
                    empty: (_) => 'Cannot be empty',
                    exceedingLength: (f) => 'Exceeding length, max: ${f.max}',
                    orElse: () {},
                  ),
                ),
            (_) {}),
      ),
    );
  }
}
