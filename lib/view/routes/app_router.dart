import 'package:auto_route/auto_route.dart';
import 'package:chat/view/auth/sign_in_page.dart';
import 'package:chat/view/core/splash_page.dart';
import 'package:chat/view/notes/note_form/note_form_page.dart';
import 'package:chat/view/notes/notes_overview/notes_overview_page.dart';
import 'package:chat/view/routes/notes_router.dart';
import 'package:chat/view/routes/root_router.dart';

@AdaptiveAutoRouter(
  replaceInRouteName: 'Page,Route',
  routes: <AutoRoute>[
    AutoRoute(path: '/', page: RootRouter, initial: true, children: [
      // Splash Page
      AutoRoute(
        path: '',
        page: SplashPage,
      ),

      // Note Routes
      AutoRoute(path: '', page: NotesRouter, children: [
        AutoRoute(path: '', page: NotesOverviewPage),
        AutoRoute(
          path: 'note/*',
          page: NoteFormPage,
          fullscreenDialog: true,
        ),
      ]),

      // Sign In Route
      AutoRoute(path: 'signin/', page: SignInPage),
    ]),
  ],
)
class $AppRouter {}
