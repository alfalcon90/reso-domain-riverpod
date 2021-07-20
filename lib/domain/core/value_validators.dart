import 'package:chat/domain/core/value_failures.dart';
import 'package:dartz/dartz.dart';
import 'package:kt_dart/kt.dart';

Either<ValueFailure<String>, String> validateEmailAddress(String input) {
  const emailRegex =
      r"""^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+""";

  if (RegExp(emailRegex).hasMatch(input)) {
    return right(input);
  } else {
    return left(
        ValueFailure.auth(AuthValueFailure.invalidEmail(failedValue: input)));
  }
}

Either<ValueFailure<String>, String> validatePassword(String input) {
  if (input.length >= 6) {
    return right(input);
  } else {
    return left(
        ValueFailure.auth(AuthValueFailure.shortPassword(failedValue: input)));
  }
}

Either<ValueFailure<String>, String> validateMaxStringLength(
    String input, int maxLength) {
  if (input.length <= maxLength) {
    return right(input);
  } else {
    return left(ValueFailure.notes(
        NotesValueFailure.exceedingLength(failedValue: input, max: maxLength)));
  }
}

Either<ValueFailure<String>, String> validateStringNotEmpty(String input) {
  if (input.isNotEmpty) {
    return right(input);
  } else {
    return left(
        ValueFailure.notes(NotesValueFailure.empty(failedValue: input)));
  }
}

Either<ValueFailure<String>, String> validateSingleLine(String input) {
  if (!input.contains('\n')) {
    return right(input);
  } else {
    return left(
        ValueFailure.notes(NotesValueFailure.empty(failedValue: input)));
  }
}

Either<ValueFailure<KtList<T>>, KtList<T>> validateMaxListLength<T>(
    KtList<T> input, int maxLength) {
  if (input.size <= maxLength) {
    return right(input);
  } else {
    return left(
        ValueFailure.notes(NotesValueFailure.empty(failedValue: input)));
  }
}
