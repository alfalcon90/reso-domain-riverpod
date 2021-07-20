import 'package:chat/domain/auth/auth_failure.dart';
import 'package:chat/domain/auth/user.dart';
import 'package:chat/domain/auth/value_objects.dart';
import 'package:dartz/dartz.dart';

abstract class IAuthService {
  Future<Either<AuthFailure, Unit>> registerWithEmailAndPassword({
    required EmailAddress email,
    required Password password,
  });

  Future<Either<AuthFailure, Unit>> signInWithEmailAndPassword({
    required EmailAddress email,
    required Password password,
  });

  Future<Either<AuthFailure, Unit>> signInWithGoogle();

  Future<Option<User>> getSignedInUser();

  Future<void> signOut();
}
