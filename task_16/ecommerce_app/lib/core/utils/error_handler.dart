import 'package:dartz/dartz.dart';
import '../error/failures.dart';
import '../constants/app_constants.dart';

class ErrorHandler {
  /// Convert Failure to user-friendly error message
  static String getErrorMessage(Failure failure) {
    if (failure is ServerFailure) {
      return AppConstants.serverErrorMessage;
    } else if (failure is NetworkFailure) {
      return AppConstants.networkErrorMessage;
    } else if (failure is CacheFailure) {
      return AppConstants.cacheErrorMessage;
    } else {
      return AppConstants.generalErrorMessage;
    }
  }
  
  /// Handle Either result and return success value or throw error
  static T handleEither<T>(Either<Failure, T> result) {
    return result.fold(
      (failure) => throw Exception(getErrorMessage(failure)),
      (success) => success,
    );
  }
  
  /// Handle Either result and return success value or null
  static T? handleEitherNullable<T>(Either<Failure, T> result) {
    return result.fold(
      (failure) => null,
      (success) => success,
    );
  }
  
  /// Check if result is success
  static bool isSuccess<T>(Either<Failure, T> result) {
    return result.isRight();
  }
  
  /// Check if result is failure
  static bool isFailure<T>(Either<Failure, T> result) {
    return result.isLeft();
  }
  
  /// Get failure from Either if it exists
  static Failure? getFailure<T>(Either<Failure, T> result) {
    return result.fold(
      (failure) => failure,
      (success) => null,
    );
  }
  
  /// Get success value from Either if it exists
  static T? getSuccess<T>(Either<Failure, T> result) {
    return result.fold(
      (failure) => null,
      (success) => success,
    );
  }
}

/// Extension methods for Either to make error handling more convenient
extension EitherExtensions<T> on Either<Failure, T> {
  String get errorMessage => ErrorHandler.getErrorMessage(
    fold((failure) => failure, (success) => ServerFailure())
  );
  
  bool get isSuccess => ErrorHandler.isSuccess(this);
  
  bool get isFailure => ErrorHandler.isFailure(this);
  
  Failure? get failure => ErrorHandler.getFailure(this);
  
  T? get success => ErrorHandler.getSuccess(this);
} 