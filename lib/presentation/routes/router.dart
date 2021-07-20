import 'package:auto_route/auto_route.dart';
import 'package:chat/presentation/auth/sign_in_page.dart';
import 'package:chat/presentation/notes/note_form/note_form_page.dart';
import 'package:chat/presentation/notes/notes_overview/notes_overview_page.dart';
import 'package:chat/presentation/splash/splash_page.dart';

@MaterialAutoRouter(
  replaceInRouteName: 'Page,Route',
  routes: <AutoRoute>[
    MaterialRoute(page: SplashPage, initial: true),
    MaterialRoute(page: SignInPage),
    MaterialRoute(page: NotesOverviewPage),
    MaterialRoute(page: NoteFormPage, fullscreenDialog: true),
  ],
)
class $AppRouter {}
