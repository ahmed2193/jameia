import 'package:dio/dio.dart';

class ServerException implements Exception {
  final String? message;
  ServerException([this.message]);
}

class FetchDataException extends DioException {
  FetchDataException([String? message])
      : super(
            requestOptions: RequestOptions(path: ''),
            error: message ?? 'Error During Communication');
}

class BadRequestException extends DioException {
  BadRequestException([String? message])
      : super(
            requestOptions: RequestOptions(path: ''),
            error: message ?? 'Bad Request');
}

class UnauthorizedException extends DioException {
  UnauthorizedException([String? message])
      : super(
            requestOptions: RequestOptions(path: ''),
            error: message ?? 'Unauthorized');
}

class NotFoundException extends DioException {
  NotFoundException([String? message])
      : super(
            requestOptions: RequestOptions(path: ''),
            error: message ?? 'Requested Info Not Found');
}

class ConflictException extends DioException {
  ConflictException([String? message])
      : super(
            requestOptions: RequestOptions(path: ''),
            error: message ?? 'Conflict Occurred');
}

class InternalServerErrorException extends DioException {
  InternalServerErrorException([String? message])
      : super(
            requestOptions: RequestOptions(path: ''),
            error: message ?? 'Internal Server Error');
}

class NoInternetConnectionException extends DioException {
  NoInternetConnectionException([String? message])
      : super(
            requestOptions: RequestOptions(path: ''),
            error: message ?? 'No Internet Connection');
}

class BadCertificateException extends DioException {
  BadCertificateException([String? message])
      : super(
            requestOptions: RequestOptions(path: ''),
            error: message ?? 'Bad Certificate');
}
