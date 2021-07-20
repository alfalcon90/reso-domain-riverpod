import 'package:chat/injection.dart';
import 'package:chat/presentation/core/app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  configureDependencies(Environment.prod);
  await Firebase.initializeApp();
  runApp(App());
}
