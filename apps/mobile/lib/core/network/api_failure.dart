import 'package:dio/dio.dart';
import 'package:talanta/l10n/generated/app_localizations.dart';
import 'package:talanta_api/talanta_api.dart';

/// Every way a request can go wrong, as the UI needs to tell them apart.
sealed class ApiFailure implements Exception {
  const ApiFailure();

  /// Turns a Dio error into one of the cases below.
  factory ApiFailure.from(Object error) {
    if (error is ApiFailure) return error;
    if (error is! DioException) return const UnknownFailure();

    switch (error.type) {
      case DioExceptionType.connectionError:
        return const OfflineFailure();
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.transformTimeout:
        return const TimeoutFailure();
      case DioExceptionType.badResponse:
        final status = error.response?.statusCode ?? 0;
        final body = error.response?.data;
        if (body is Map<String, Object?> &&
            body['code'] is String &&
            body['message'] is String) {
          return ProblemFailure(Problem.fromJson(body), status);
        }
        return status >= 500 ? const ServerFailure() : const UnknownFailure();
      case DioExceptionType.cancel:
      case DioExceptionType.badCertificate:
      case DioExceptionType.unknown:
        return error.error is ApiFailure
            ? error.error! as ApiFailure
            : const UnknownFailure();
    }
  }

  String message(AppLocalizations l10n);
}

/// The API answered with a `ProblemDto`.
final class ProblemFailure extends ApiFailure {
  const ProblemFailure(this.problem, this.status);

  final Problem problem;
  final int status;

  ErrorCode get code => problem.code;

  /// The first message the API gave for [field], if any.
  String? fieldMessage(String field) => problem.fields?[field]?.firstOrNull;

  @override
  String message(AppLocalizations l10n) => switch (code) {
    ErrorCode.phoneInvalid => l10n.phoneErrorInvalid,
    ErrorCode.phoneCountryUnsupported => l10n.phoneErrorCountryUnsupported,
    ErrorCode.otpInvalid => l10n.otpErrorInvalid,
    ErrorCode.otpExpired => l10n.otpErrorExpired,
    ErrorCode.otpTooManyAttempts => l10n.otpErrorTooManyAttempts,
    ErrorCode.otpResendTooSoon => l10n.otpErrorResendTooSoon,
    ErrorCode.otpRateLimited ||
    ErrorCode.rateLimited => l10n.otpErrorRateLimited,
    ErrorCode.usernameTaken => l10n.profileUsernameTaken,
    ErrorCode.usernameReserved => l10n.profileUsernameReserved,
    ErrorCode.ageBelowMinimum => l10n.profileErrorTooYoung,
    ErrorCode.sessionExpired ||
    ErrorCode.unauthorized => l10n.errorSessionEnded,
    ErrorCode.internalError ||
    ErrorCode.serviceUnavailable ||
    ErrorCode.smsDeliveryFailed => l10n.errorServer,
    _ => l10n.errorUnknown,
  };
}

final class OfflineFailure extends ApiFailure {
  const OfflineFailure();

  @override
  String message(AppLocalizations l10n) => l10n.errorOffline;
}

final class TimeoutFailure extends ApiFailure {
  const TimeoutFailure();

  @override
  String message(AppLocalizations l10n) => l10n.errorTimeout;
}

final class ServerFailure extends ApiFailure {
  const ServerFailure();

  @override
  String message(AppLocalizations l10n) => l10n.errorServer;
}

final class UnknownFailure extends ApiFailure {
  const UnknownFailure();

  @override
  String message(AppLocalizations l10n) => l10n.errorUnknown;
}
