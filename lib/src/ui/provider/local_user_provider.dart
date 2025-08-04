
// import 'package:hooks_riverpod/hooks_riverpod.dart';

// import '../../entities/auth_response.dart';

// final localUserProvider = StateNotifierProvider<LocalUserProvider, User>(
//     (ref) => LocalUserProvider(ref));

// class LocalUserProvider extends StateNotifier<AuthResponse> {
//   LocalUserProvider(this.ref) : super(AuthResponse());

//   final Ref ref;

//   Future fetchLocalUser() async {
//     final token = await Dependencies().getIt<AuthRepository>().fetchToken();

//     if (token != null) {
//       var parseToken = JwtDecoder.decode(token);

//       state = User.fromJson(parseToken);
//     }
//   }
// }
