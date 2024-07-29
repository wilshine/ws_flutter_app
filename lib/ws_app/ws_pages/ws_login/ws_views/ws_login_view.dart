import 'package:common_tools/common_tools.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:ws_flutter_app/ws_app/ws_app_util.dart';
import 'package:ws_flutter_app/ws_app/ws_dialog/ws_dialog_actor.dart';
import 'package:ws_flutter_app/ws_app/ws_pages/ws_login/ws_controllers/ws_login_controller.dart';
import 'package:ws_flutter_app/ws_app/ws_pages/ws_main/ws_main_views/ws_main_view.dart';
import 'package:ws_flutter_app/ws_services/ws_app_service.dart';
import 'package:ws_flutter_app/ws_utils/ws_log/ws_logger.dart';
import 'package:common_ui/common_ui.dart';

class WSLoginView extends StatefulWidget {
  const WSLoginView({super.key, this.extra});

  final Object? extra;

  @override
  State<WSLoginView> createState() => WSLoginViewState();
}

class WSLoginViewState extends State<WSLoginView> {
  int currentLoginType = 0;

  @override
  void initState() {
    super.initState();

    () async {
      try {
        bool isSupported = await WSAppService.instance.isSupportAutoLogin();
        if (isSupported) {
          EasyLoading.show();
          bool isLoginSuccess = await WSAppService.instance.loginAuto();
          if (isLoginSuccess) {
            goToMainPage();
          }
        }
      } catch (e, s) {
        // WSLogger.debug('check auto login error: $e, $s');
      } finally {
        EasyLoading.dismiss();
      }
    }();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onLongPress: () {
          // test();
        },
        child: Container(
          alignment: Alignment.bottomCenter,
          decoration: const BoxDecoration(
            color: Colors.black,
            image: DecorationImage(image: AssetImage('assets/images/login_bg.jpeg'), fit: BoxFit.fitWidth),
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 48),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const SizedBox(height: 32),
                getFastLoginButton(),
                const SizedBox(height: 46),
                getPrivacyWidget(),
                const SizedBox(height: 54),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget getFastLoginButton() {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 15),
        decoration: const BoxDecoration(color: Color(0xFFFFFFFF), borderRadius: BorderRadius.all(Radius.circular(52))),
        child: const Stack(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '快速登录',
                  style: TextStyle(color: Color(0xFF202020)),
                ),
              ],
            ),
          ],
        ),
      ),
      onPressed: () async {
        onEventFastLogin();
      },
    );
  }

  Widget getPopupWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      width: 315,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 24),
          Container(
              alignment: Alignment.center,
              width: 53,
              height: 52,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(12)),
                image: DecorationImage(image: AssetImage('assets/images/logo.png')),
              ),
              child: const SizedBox()),
          const SizedBox(height: 14),
          const Text(
            'XTechPark',
            style: TextStyle(color: Color(0xFF404040), fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          RichText(
            text: TextSpan(
                text: 'By using our App you agree with our \n',
                style: const TextStyle(color: Color(0xFF404040), fontSize: 14, fontWeight: FontWeight.normal),
                children: [
                  TextSpan(
                    text: "Term of Use",
                    style: TextStyle(color: Colors.blue.withAlpha(200), fontSize: 14),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        // WSDialogActor.dismissTopDialog();
                        WSAppUtil.onEventTermOfUse();
                      },
                  ),
                  const TextSpan(
                    text: " and ",
                    style: TextStyle(color: Color(0xFF404040), fontSize: 15),
                  ),
                  TextSpan(
                    text: "Privacy Policy",
                    style: TextStyle(color: Colors.blue.withAlpha(200), fontSize: 14),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        // WSDialogActor.dismissTopDialog();
                        WSAppUtil.onEventPrivacyPolicy();
                      },
                  ),
                ]),
          ),
          const SizedBox(height: 24),
          CupertinoButton(
            padding: EdgeInsets.zero,
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 15),
              decoration: const BoxDecoration(
                color: Color(0xFF4C4B4B),
                borderRadius: BorderRadius.all(Radius.circular(52)),
              ),
              child: const Text('Agree and Continue', style: TextStyle(color: Color(0xFFE6FF4E))),
            ),
            onPressed: () async {
              onEventAgreeAndContinue();
            },
          ),
          const SizedBox(height: 12),
          CupertinoButton(
            padding: EdgeInsets.zero,
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.black.withAlpha(90), fontSize: 14),
            ),
            onPressed: () {
              // WSDialogActor.dismissTopDialog();
            },
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget getPrivacyWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Obx(() {
          return Checkbox(
            shape: RoundedRectangleBorder(
              side: BorderSide(width: 1, color: Colors.grey.withAlpha(128)),
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
            value: Get.find<WSLoginController>().isCheckedPrivacy.value,
            onChanged: (value) {
              Get.find<WSLoginController>().isCheckedPrivacy.value = value!;
            },
          );
        }),
        RichText(
          text: TextSpan(
              text: 'By using our App you agree with our\n',
              style: const TextStyle(color: Colors.white, fontSize: 12),
              children: [
                TextSpan(
                  text: "Term of Use",
                  style: const TextStyle(color: Colors.blue, fontSize: 14),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      WSAppUtil.onEventTermOfUse();
                    },
                ),
                const TextSpan(
                  text: " and ",
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
                TextSpan(
                  text: "Privacy Policy",
                  style: const TextStyle(color: Colors.blue, fontSize: 14),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      WSAppUtil.onEventPrivacyPolicy();
                    },
                ),
                const TextSpan(
                  text: ".",
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ]),
        ),
      ],
    );
  }

  /// Events

  void onEventAgreeAndContinue() {
    Get.find<WSLoginController>().isCheckedPrivacy.value = true;
    // WSDialogActor.dismissTopDialog().then((value) {
    //   if (currentLoginType == 1) {
    //     doAppleLogin();
    //   } else {
    //     doFastLogin();
    //   }
    // });
  }

  void onEventLoginWithApple() async {
    currentLoginType = 1;
    if (preLogin() == false) {
      return;
    }
    doAppleLogin();
  }

  void onEventFastLogin() {
    currentLoginType = 0;
    // if (preLogin() == false) {
    //   return;
    // }
    doFastLogin();
  }

  bool preLogin() {
    if (Get.find<WSLoginController>().isCheckedPrivacy.value == false) {
      WSDialogActor.showCenter(getPopupWidget())
        ..barrierColor = Colors.black.withAlpha(164)
        ..routeName = 'Privacy';
      return false;
    }
    return true;
  }

  Future<bool> doAppleLogin() async {
    EasyLoading.show();
    bool isLoginSuccess = false;
    // try {
    //   AuthorizationCredentialAppleID credential = await SignInWithApple.getAppleIDCredential(
    //     scopes: [
    //       AppleIDAuthorizationScopes.email,
    //       AppleIDAuthorizationScopes.fullName,
    //     ],
    //   );
    //   //i.e. AuthorizationAppleID(000332.788889f88a480000000.1233, He, Her, mmmmmm@privaterelay.appleid.com, null)
    //   WSLogger.debug('Apple credential >>>>>> $credential');
    //   // Now send the credential (especially `credential.authorizationCode`) to your server to create a session
    //   // after they have been validated with Apple (see `Integration` section for more information on how to do this)
    //   isLoginSuccess = await WSAppService.instance.login(appleToken: credential.identityToken);
    // } catch (e, s) {
    //   WSLogger.error('error on login with apple: $e, $s');
    // } finally {
    //   EasyLoading.dismiss();
    // }
    // if (isLoginSuccess) {
    //   goToMainPage();
    // } else {
    //   WSToast.show('Apple login failed, please try again later.');
    // }
    return isLoginSuccess;
  }

  Future<bool> doFastLogin() async {
    EasyLoading.show();
    bool isLoginSuccess = false;
    try {
      // isLoginSuccess = await WSAppService.instance.login();
      await Future.delayed(Duration(milliseconds: 500));
    } catch (e, s) {
      WSLogger.error('error on fast login: $e, $s');
    } finally {
      EasyLoading.dismiss();
    }
    goToMainPage();
    if (isLoginSuccess) {
    } else {
      // WSToast.show('Login failed, please try again later.');
    }
    return isLoginSuccess;
  }

  void goToMainPage() {
    context.push('/main');
  }
}
