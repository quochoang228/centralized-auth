import 'package:ds/ds.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../entities/auth_response.dart';
import '../provider/login_provider.dart';

typedef OnLoginSuccess = Function(AuthResponse authResponse);

class LoginCentralizedPage extends StatefulHookConsumerWidget {
  const LoginCentralizedPage({
    super.key,
    required this.onLoginSuccess,
  });

  final OnLoginSuccess onLoginSuccess;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _LoginCentralizedPageState();
}

class _LoginCentralizedPageState extends ConsumerState<LoginCentralizedPage> {
  @override
  Widget build(BuildContext context) {
    var userController = useTextEditingController();
    var passWorkController = useTextEditingController();

    var isUserControllerNotEmpty = useListenableSelector(
      userController,
      () => userController.text.isNotEmpty,
    );
    var isPassWorkControllerNotEmpty = useListenableSelector(
      passWorkController,
      () => passWorkController.text.isNotEmpty,
    );

    var isObscureText = useState(true);

    ref.listen(loginProvider, (previous, next) {
      next.match(
        notLoaded: (_) => const SizedBox(),
        loading: (_) => LoadingDialog.show(context),
        fetched: (value) {
          LoadingDialog.dismiss(context);
          // BaseNormalToast.showError(
          //   context: context,
          //   text: 'Đăng nhập thành công!',
          // );
          // Dependencies().getIt<AuthService>().onLoginSuccess(context);
          Navigator.pop(context);
          widget.onLoginSuccess(value.data);
        },
        noData: (_) => const SizedBox(),
        failed: (err) {
          LoadingDialog.dismiss(context);
          // BaseNormalToast.showError(
          //   context: context,
          //   text: (err as ErrorResponse).message ?? '',
          // );
        },
      );
    });

    return Scaffold(
      backgroundColor: DSColors.backgroundWhite,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(DSSpacing.spacing6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Đăng nhập tập trung',
                      style: DSTextStyle.titleMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: DSSpacing.spacing4),
                    DSTextField(
                      controller: userController,
                      // prefix: MyAssets.icons.user.svg(),
                      labelText: 'Tài khoản',
                      hintText: 'Nhập tài khoản',
                    ),
                    const SizedBox(height: DSSpacing.spacing4),
                    DSTextField(
                      controller: passWorkController,
                      labelText: 'Mật khẩu',
                      hintText: 'Nhập mật khẩu đăng nhập',
                      // prefix: MyAssets.icons.unlockOtp.svg(),
                      keyboardType: TextInputType.visiblePassword,
                      suffix: InkWell(
                          onTap: () {
                            isObscureText.value = !isObscureText.value;
                          },
                          child: isObscureText.value
                              ? Icon(Icons.visibility)
                              : Icon(Icons.visibility_off)),
                      obscureText: isObscureText.value,
                    ),
                    const SizedBox(height: DSSpacing.spacing4),
                    RichText(
                      text: TextSpan(
                        text: "Tôi đồng ý với ",
                        style: DSTextStyle.captionLarge
                            .copyWith(color: DSColors.textTitle),
                        children: [
                          TextSpan(
                            text: "Điều khoản dịch vụ ",
                            style: DSTextStyle.captionLarge
                                .copyWith(color: DSColors.info),
                            recognizer: TapGestureRecognizer()..onTap = () {},
                          ),
                          TextSpan(
                            text: "và ",
                            style: DSTextStyle.captionLarge
                                .copyWith(color: DSColors.textTitle),
                          ),
                          TextSpan(
                            text: "chính sách bảo mật ",
                            style: DSTextStyle.captionLarge
                                .copyWith(color: DSColors.info),
                            recognizer: TapGestureRecognizer()..onTap = () {},
                          ),
                          TextSpan(
                            text: "của Viettel Construction ",
                            style: DSTextStyle.captionLarge
                                .copyWith(color: DSColors.textTitle),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: DSSpacing.spacing4),
                    DSButton(
                      label: 'Đăng nhập',
                      onPressed: isUserControllerNotEmpty &&
                              isPassWorkControllerNotEmpty
                          ? () {
                              ref.read(loginProvider.notifier).login(
                                    userName: userController.text,
                                    psw: passWorkController.text,
                                  );
                            }
                          : null,
                    ),
                    const SizedBox(height: DSSpacing.spacing4),
                  ],
                ),
              ),
          
              // const Spacer(),
          
              Center(
                child: RichText(
                  text: TextSpan(
                    text: "Bạn chưa có tài khoản? ",
                    style: DSTextStyle.captionLarge
                        .copyWith(color: DSColors.textTitle),
                    children: [
                      TextSpan(
                        text: "Đăng ký ngay",
                        style: DSTextStyle.captionLarge
                            .copyWith(color: DSColors.primary),
                        recognizer: TapGestureRecognizer()..onTap = () {},
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
