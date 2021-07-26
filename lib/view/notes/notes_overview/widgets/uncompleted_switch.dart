import 'package:chat/state/notes/notes_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class UncompletedSwitch extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final toggleState = useState(false);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: InkResponse(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 100),
          transitionBuilder: (child, animation) => ScaleTransition(
            scale: animation,
            child: child,
          ),
          child: toggleState.value
              ? Icon(
                  Icons.check_box_outline_blank,
                  key: const Key('outline'),
                )
              : Icon(Icons.indeterminate_check_box,
                  key: const Key('indeterminate')),
        ),
        onTap: () {
          toggleState.value = !toggleState.value;
          toggleState.value
              ? ref.read(noteWatcherProvider.notifier).watchUncompletedStarted()
              : ref.read(noteWatcherProvider.notifier).watchAllStarted();
        },
      ),
    );
  }
}
