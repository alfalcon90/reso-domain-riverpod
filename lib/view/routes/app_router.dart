import 'package:auto_route/auto_route.dart';
import 'package:chat/view/routes/auth_router.dart';
import 'package:chat/view/auth/sign_in_page.dart';
import 'package:chat/view/core/splash_page.dart';
import 'package:chat/view/notes/note_form/note_form_page.dart';
import 'package:chat/view/notes/notes_overview/notes_overview_page.dart';
import 'package:chat/view/routes/home_router.dart';

@MaterialAutoRouter(
  replaceInRouteName: 'Page,Route',
  routes: <AutoRoute>[
    MaterialRoute(path: 'splash/', page: SplashPage, initial: true),
    MaterialRoute(path: 'auth/', page: AuthRouter, children: [
      MaterialRoute(path: 'home/', page: HomeRouter, children: [
        MaterialRoute(path: '', page: NotesOverviewPage),
        MaterialRoute(
          path: 'note/*',
          page: NoteFormPage,
          fullscreenDialog: true,
        ),
        RedirectRoute(path: '*', redirectTo: ''),
      ]),
      MaterialRoute(path: 'signin/', page: SignInPage),
    ]),
  ],
)
class $AppRouter {}
