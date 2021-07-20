import 'package:chat/controllers/notes/note_watcher/note_watcher_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UncompletedSwitch extends HookWidget {
  @override
  Widget build(BuildContext context) {
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
          context.read<NoteWatcherBloc>().add(toggleState.value
              ? NoteWatcherEvent.watchUncompletedStarted()
              : NoteWatcherEvent.watchAllStarted());
        },
      ),
    );
  }
}
