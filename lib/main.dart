import 'package:chat/config/injection.dart';
import 'package:chat/utils/logger.dart';
import 'package:chat/view/core/app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:injectable/injectable.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  configureDependencies(Environment.prod);
  await Firebase.initializeApp();
  runApp(ProviderScope(
    observers: [Logger()],
    child: App(),
  ));
}
