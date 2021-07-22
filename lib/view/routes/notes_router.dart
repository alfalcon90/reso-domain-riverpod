import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:chat/view/routes/app_router.gr.dart';

class NotesRouter extends StatelessWidget {
  const NotesRouter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AutoRouter.declarative(routes: (_) {
      return [NotesOverviewRoute()];
    });
  }
}
