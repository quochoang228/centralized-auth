import 'package:ag/ag.dart';

import '../../../centralized_auth.dart';
import 'base_result.dart';

typedef ResponseToModel<Model> = Model Function(dynamic);

abstract class CentralizedBaseRepository {
  Future<BaseResultCentralized<Model>> safeApiCall<Model>(
    Future<Response> call, {
    required ResponseToModel<Model> mapper,
  }) async {
    try {
      var response = await call;
      try {
        return BaseSuccessCentralized<Model>(mapper.call(response.data));
      } catch (e) {
        return BaseErrorCentralized(
          DioExceptionType.unknown,
          'Lỗi mapper dữ liệu',
          statusCode: -1,
        );
      }
    } on Exception catch (exception) {
      if (exception is DioException) {
        switch (exception.type) {
          case DioExceptionType.connectionTimeout:
            return BaseErrorCentralized(
              DioExceptionType.connectionTimeout,
              exception.message ?? 'Quá thời gian kết nối!',
              statusCode: exception.response?.statusCode ?? -1,
            );
          case DioExceptionType.sendTimeout:
            return BaseErrorCentralized(
              DioExceptionType.sendTimeout,
              exception.message ?? 'Quá thời gian gửi dữ liệu!',
              statusCode: exception.response?.statusCode ?? -1,
            );
          case DioExceptionType.receiveTimeout:
            // return BaseError(DioExceptionType.badCertificate,
            //     exception.response?.data["message"] ?? 'Connection Timeout');
            return BaseErrorCentralized(
              DioExceptionType.receiveTimeout,
              exception.message ?? 'Quá thời gian nhận dữ liệu!',
              statusCode: exception.response?.statusCode ?? -1,
            );
          case DioExceptionType.cancel:
            return BaseErrorCentralized(
              DioExceptionType.cancel,
              exception.message ?? 'Hủy kết nối!',
              statusCode: exception.response?.statusCode ?? -1,
            );
          case DioExceptionType.badCertificate:
            // return BaseError(DioExceptionType.badCertificate,
            //     exception.response?.data["message"] ?? 'BadCertificate');
            return BaseErrorCentralized(
              DioExceptionType.badCertificate,
              exception.message ?? 'Lỗi chứng chỉ SSL!',
              statusCode: exception.response?.statusCode ?? -1,
            );
          case DioExceptionType.badResponse:
            return BaseErrorCentralized(
              DioExceptionType.badResponse,
              (exception.response?.data is AuthResponse)
                  ? (exception.response?.data as AuthResponse)
                          .errorDescription ??
                      exception.message ??
                      'BadResponse'
                  : 'BadResponse',
              statusCode: exception.response?.statusCode ?? -1,
            );

          case DioExceptionType.connectionError:
            return BaseErrorCentralized(
              DioExceptionType.connectionError,
              exception.message ?? 'Hãy kiểm tra kết nối mạng của bạn!',
              statusCode: exception.response?.statusCode ?? -1,
            );

          case DioExceptionType.unknown:
            return BaseErrorCentralized(
              DioExceptionType.unknown,
              exception.message ?? 'Lỗi không xác định!',
              statusCode: exception.response?.statusCode ?? -1,
            );
        }
      }
      if (exception is BaseException) {
        return BaseErrorCentralized(
            DioExceptionType.unknown, exception.message);
      }
      return BaseErrorCentralized(
          DioExceptionType.unknown, "Xảy ra lỗi, hãy thử lại!");
    }
  }
}
