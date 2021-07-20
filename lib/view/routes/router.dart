import 'package:auto_route/auto_route.dart';
import 'package:chat/view/auth/auth_check.dart';
import 'package:chat/view/notes/note_form/note_form_page.dart';
import 'package:chat/view/notes/notes_overview/notes_overview_page.dart';

@MaterialAutoRouter(
  replaceInRouteName: 'Page,Route',
  routes: <AutoRoute>[
    MaterialRoute(page: AuthCheck, initial: true),
    MaterialRoute(page: NotesOverviewPage),
    MaterialRoute(page: NoteFormPage, fullscreenDialog: true),
  ],
)
class $AppRouter {}
