import 'package:auto_route/auto_route.dart';
import 'package:chat/view/auth/sign_in_page.dart';
import 'package:chat/view/core/splash_page.dart';
import 'package:chat/view/notes/note_form/note_form_page.dart';
import 'package:chat/view/notes/notes_overview/notes_overview_page.dart';

@MaterialAutoRouter(
  replaceInRouteName: 'Page,Route',
  routes: <AutoRoute>[
    MaterialRoute(page: SplashPage, initial: true),
    MaterialRoute(page: NotesOverviewPage),
    MaterialRoute(page: SignInPage),
    MaterialRoute(page: NoteFormPage, fullscreenDialog: true),
  ],
)
class $AppRouter {}
