import 'package:chat/domain/notes/value_objects.dart';
import 'package:chat/state/notes/notes_providers.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ColorField extends ConsumerWidget {
  const ColorField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(noteFormProvider);

    return Container(
      height: 80,
      child: ListView.separated(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemBuilder: (ctx, idx) {
          final itemColor = NoteColor.predefinedColors[idx];
          return GestureDetector(
            onTap: () {
              ref.read(noteFormProvider.notifier).colorChanged(itemColor);
            },
            child: Material(
              color: itemColor,
              elevation: 4,
              shape: CircleBorder(
                side: state.note.color.value.fold(
                  (_) => BorderSide.none,
                  (color) => color == itemColor
                      ? BorderSide(width: 1.5)
                      : BorderSide.none,
                ),
              ),
              child: Container(
                width: 48,
                height: 48,
              ),
            ),
          );
        },
        separatorBuilder: (ctx, idx) => const SizedBox(
          width: 12,
        ),
        itemCount: NoteColor.predefinedColors.length,
      ),
    );
  }
}
