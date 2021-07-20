import 'package:chat/domain/notes/note_failure.dart';
import 'package:flutter/material.dart';

class CriticalFailure extends StatelessWidget {
  final NoteFailure failure;

  const CriticalFailure({Key? key, required this.failure}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            '😱',
            style: TextStyle(fontSize: 100),
          ),
          const SizedBox(
            height: 16,
          ),
          Text(
            failure.maybeMap(
                orElse: () => 'Unexpected error',
                insufficientPermission: (_) => 'Insufficient permission'),
            style: const TextStyle(fontSize: 24),
            textAlign: TextAlign.center,
          ),
          TextButton.icon(
              onPressed: () {},
              icon: Icon(Icons.mail),
              label: const Text('I need help'))
        ],
      ),
    );
  }
}
