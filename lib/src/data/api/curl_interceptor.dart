import 'dart:convert';

import 'package:ag/ag.dart';
import 'package:logs/logs.dart';

class CurlLoggerDioInterceptor extends Interceptor {
  final bool? printOnSuccess;
  final bool convertFormData;

  CurlLoggerDioInterceptor({this.printOnSuccess, this.convertFormData = true});

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    _renderCurlRepresentation(err.requestOptions);
    return handler.next(err); // continue
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    _renderCurlRepresentation(options);
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (printOnSuccess != null && printOnSuccess == true) {
      _renderCurlRepresentation(response.requestOptions);
    }
    return handler.next(response); // continue
  }

  void _renderCurlRepresentation(RequestOptions requestOptions) {
    try {
      LogUtils.d(_cURLRepresentation(requestOptions), tag: 'Curl');
    } catch (err) {
      LogUtils.e(
          'unable to create a CURL representation of the requestOptions: $err'); // Include the error
    }
  }

  String _cURLRepresentation(RequestOptions options) {
    List<String> components = ['\ncurl -i'];
    if (options.method.toUpperCase() != 'GET') {
      components.add('-X ${options.method}');
    }

    options.headers.forEach((k, v) {
      if (k != 'Cookie') {
        components.add('-H "$k: $v"');
      }
    });

    if (options.data != null) {
      final data = options.data;
      if (data is FormData && convertFormData == true) {
        if (data.fields.isNotEmpty) {
          for (int i = 0; i < data.fields.length; i++) {
            var field = data.fields[i];
            components.add('-F "${field.key}=${field.value}"');
          }
        }

        // Log chi tiết từng file
        if (data.files.isNotEmpty) {
          for (int i = 0; i < data.files.length; i++) {
            var file = data.files[i];
            final filename = file.value.filename ?? 'file';
            components.add('-F "${file.key}=@$filename"');
          }
        }
      } else if (data is Map || data is List) {
        try {
          final jsonData = json.encode(data).replaceAll('"', '\\"');
          components.add('-d "$jsonData"');
        } catch (e) {
          components.add('-d "${data.toString()}"');
        }
      } else if (data is String || data is num || data is bool) {
        components.add('-d "${data.toString()}"');
      } else {
        // fallback cho mọi kiểu khác
        try {
          final jsonData = json.encode(data).replaceAll('"', '\\"');
          components.add('-d "$jsonData"');
        } catch (e) {
          components.add('-d "${data.toString()}"');
        }
      }
    }

    components.add('"${options.uri.toString()}"');

    return components.join(' \\\n\t');
  }
}
