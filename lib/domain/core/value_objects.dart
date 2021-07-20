import 'package:chat/domain/core/errors.dart';
import 'package:chat/domain/core/value_failures.dart';
import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uuid/uuid.dart';

@immutable
abstract class ValueObject<T> {
  const ValueObject();

  Either<ValueFailure<T>, T> get value;

  bool isValid() => value.isRight();

  Either<ValueFailure<dynamic>, Unit> get failureOrUnit {
    return value.fold((l) => left(l), (r) => right(unit));
  }

  T getOrCrash() {
    return value.fold((f) => throw UnexpectedValueError(f), id);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ValueObject<T> && other.value == value;
  }

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => 'Value(value: $value)';
}

class UniqueId extends ValueObject<String> {
  @override
  final Either<ValueFailure<String>, String> value;

  factory UniqueId() {
    var uuid = const Uuid();
    return UniqueId._(right(uuid.v1()));
  }

  factory UniqueId.fromUniqueString(String uniqueId) {
    return UniqueId._(right(uniqueId));
  }
  const UniqueId._(this.value);
}
