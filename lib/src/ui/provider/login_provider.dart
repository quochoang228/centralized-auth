import 'dart:convert';

import 'package:ag/ag.dart';
import 'package:di/di.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:utils/utils.dart';

import '../../data/repo/centralized_repo.dart';
import '../../entities/auth_response.dart';

final loginProvider = StateNotifierProvider.autoDispose<LoginProvider,
    DataState<AuthResponse, ErrorResponse>>(
  (ref) => LoginProvider(ref),
);

class LoginProvider
    extends StateNotifier<DataState<AuthResponse, ErrorResponse>> {
  LoginProvider(this.ref) : super(NotLoaded<AuthResponse>());

  final Ref ref;

  Future login({
    required String userName,
    required String psw,
  }) async {
    if (state.state != CurrentDataState.loading) {
      state = Loading<AuthResponse>();
      try {
        var request = {
          "username": userName,
          "password": psw,
          "grant_type": "password",
          "client_id": "superapp-client",
        };
        final result = await Dependencies()
            .getIt<CentralizedAuthRepository>()
            .login(request: request);
        result.when(
          success: (data) async {
            if (data.accessToken != null) {
              var authResponseRaw = JwtDecoder.decode(data.accessToken!);
              var authResponse = AuthResponse.fromJson(authResponseRaw);

              await Dependencies()
                  .getIt<CentralizedAuthRepository>()
                  .setToken(jsonEncode(data));

              state = Fetched(authResponse);

              // get local user
              // await ref.read(localUserProvider.notifier).fetchLocalUser();
              // if (data.accessToken != null) {
              //   var parseToken = JwtDecoder.decode(data.accessToken!);
              //   state = Fetched(AuthResponse.fromJson(parseToken));
              // } else {
              //   state = Fetched(AuthResponse());
              // }
            } else {
              state =
                  Failed(ErrorResponse(message: data.errorDescription ?? ''));
            }
            // if (data.status == 201 && data.data != null) {
            //   await Dependencies()
            //       .getIt<AuthRepository>()
            //       .setToken(data.data!.token ?? '');
            //
            //   // get local user
            //   await ref.read(localUserProvider.notifier).fetchLocalUser();;
            //
            //   if (data.data!.token != null) {
            //     var parseToken = JwtDecoder.decode(data.data!.token!);
            //     state = Fetched(User.fromJson(parseToken));
            //   } else {
            //     state = Fetched(User());
            //   }
            // } else {
            //   // state = Failed(data.errors);
            //   state = Failed(ErrorResponse(message: data.message ?? ''));
            // }
          },
          error: (err) {
            state = Failed(ErrorResponse(message: err.message));
          },
        );
      } catch (error) {
        state = Failed(ErrorResponse(message: error.toString()));
      }
    }
  }
}
