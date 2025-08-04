
import 'package:ag/ag.dart';

abstract class CentralizedAuthApi {
  Future<Response> login({
    required Map<String, dynamic> request,
  });
}

class CentralizedAuthApiImpl implements CentralizedAuthApi {
  final Dio _dio;

  CentralizedAuthApiImpl({
    required Dio dio,
  }) : _dio = dio;

  @override
  Future<Response> login({
    required Map<String, dynamic> request,
  }) {
    return _dio.post(
      '/superapp/protocol/openid-connect/token',
      data: request,
      options: Options(
        headers: {
          'Content-Type': Headers.formUrlEncodedContentType,
        },
      ),
    );
  }
}
