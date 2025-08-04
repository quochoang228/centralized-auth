import 'package:ag/ag.dart';

sealed class BaseResultCentralized<T> with SealedResult<T> {
  bool get isSuccessful => this is BaseSuccessCentralized<T>;

  BaseResultCentralized<T> transform({
    required T Function(T)? success,
    BaseErrorCentralized<T> Function(BaseErrorCentralized<T>)? error,
  }) {
    if (this is BaseSuccessCentralized<T> && success != null) {
      (this as BaseSuccessCentralized<T>).data =
          success.call((this as BaseSuccessCentralized<T>).data);
    }
    if (this is BaseErrorCentralized<T> && error != null) {
      return error.call(this as BaseErrorCentralized<T>);
    }
    return this;
  }

  T? getData() {
    final state = this;
    if (state is BaseSuccessCentralized<T>) {
      return state.data;
    } else {
      return null;
    }
  }
}

class BaseSuccessCentralized<T> extends BaseResultCentralized<T> {
  T data;

  BaseSuccessCentralized(this.data);
}

class BaseErrorCentralized<T> extends BaseResultCentralized<T> {
  DioExceptionType type;
  String message;
  int? statusCode = 0;

  BaseErrorCentralized(this.type, this.message, {this.statusCode});
}

class BaseLoadingCentralized<T> extends BaseResultCentralized<T> {
  BaseLoadingCentralized();
}

class Init<T> extends BaseResultCentralized<T> {
  Init();
}

mixin SealedResult<T> {
  R? when<R>({
    R Function(T)? success,
    R Function(BaseErrorCentralized)? error,
  }) {
    if (this is BaseSuccessCentralized<T>) {
      return success?.call((this as BaseSuccessCentralized).data);
    }
    if (this is BaseErrorCentralized<T>) {
      return error?.call(this as BaseErrorCentralized);
    }
    throw Exception(
        'If you got here, probably you forgot to regenerate the classes? '
        'Try running flutter packages pub run build_runner build');
  }
}
