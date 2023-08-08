import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_maihomie_app/core/services/auth_service.dart';
import 'package:flutter_maihomie_app/core/state_models/auth_model.dart';
import 'package:flutter_maihomie_app/service_locator.dart';
import 'package:flutter_maihomie_app/ui/utils/colors.dart';
import 'package:flutter_maihomie_app/ui/utils/constants.dart';
import 'package:flutter_maihomie_app/ui/utils/helper.dart';
import 'package:flutter_maihomie_app/ui/utils/router_login.dart';
import 'package:flutter_maihomie_app/ui/utils/server_config.dart';
import 'package:flutter_maihomie_app/ui/views/_base.dart';
import 'package:flutter_maihomie_app/ui/views/auth/enter_password_view.dart';
import 'package:flutter_maihomie_app/ui/views/auth/enter_pin_view.dart';
import 'package:flutter_maihomie_app/ui/views/auth/register_view.dart';
import 'package:flutter_maihomie_app/ui/widgets/base_text_form_field.dart';
import 'package:flutter_maihomie_app/ui/widgets/button_login.dart';
import 'package:flutter_maihomie_app/ui/widgets/dialogs/loading_dialog.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:phone_numbers_parser/phone_numbers_parser.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  Size size = Size.zero;
  final TextEditingController phoneController = TextEditingController();
  final formGlobalKey = GlobalKey<FormState>();
  bool isValidatePhoneNumber = false;
  String currentPhone = '';

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;

    return BaseView<AuthModel>(
      builder: (context, model, child) => Scaffold(
        backgroundColor: backgroundColor,
        body: Stack(
          children: [
            Column(
              children: [
                Image.asset(
                  'assets/bg_login.png',
                  fit: BoxFit.cover,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Text(
                          appLang(context)!.hello_user(""),
                          style: const TextStyle(
                            color: headerColor1,
                            fontSize: 36,
                            fontFamily: fontBold,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Text(
                          appLang(context)!.login_or_register,
                          style: TextStyle(
                            color: Colors.black.withOpacity(0.5),
                            fontSize: 18,
                          ),
                        ),
                      ),
                      _buildPhoneField(
                        onChanged: (value) {
                          setState(() {
                            currentPhone = PhoneNumber.fromIsoCode(
                                    countryCode, phoneController.text)
                                .international;
                          });
                          formGlobalKey.currentState?.validate();
                        },
                        validator: (_) {
                          if (PhoneNumber.fromIsoCode(
                                  countryCode, phoneController.text)
                              .validate()) {
                            isValidatePhoneNumber = true;
                            return null;
                          } else if (phoneController.text.isEmpty) {
                            isValidatePhoneNumber = false;
                            return appLang(context)!.warning_enter_phoneNum;
                          } else {
                            isValidatePhoneNumber = false;
                            return appLang(context)!.warning_phoneNum_invalid;
                          }
                        },
                        onFieldSubmitted: (_) async {
                          await _checkUserExist(model: model);
                        },
                      ),
                    ],
                  ),
                ),
                MediaQuery.of(context).viewInsets.bottom == 0
                    ? _buildButtonContinue(
                        onCheckUserExisted: () async {
                          await _checkUserExist(model: model);
                        },
                      )
                    : Container()
              ],
            ),
            MediaQuery.of(context).viewInsets.bottom != 0
                ? Positioned(
                    bottom: size.height * 0.02,
                    child: SizedBox(
                      width: size.width,
                      child: Center(
                        child: _buildButtonContinue(
                          onCheckUserExisted: () async {
                            await _checkUserExist(model: model);
                          },
                        ),
                      ),
                    ),
                  )
                : Container(),
            Positioned(
              bottom: size.height * 0.07,
              left: 0,
              right: 0,
              child: MediaQuery.of(context).viewInsets.bottom == 0
                  ? Column(
                      children: [
                        Text(
                          appLang(context)!.or_continue,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.black.withOpacity(0.5),
                            fontFamily: fontBold,
                          ),
                        ),
                        const Divider(
                          indent: 50,
                          endIndent: 50,
                        ),
                        SizedBox(
                          height: size.height * 0.03,
                        ),
                        _buildSocials(
                          onLoginGoogle: () async {
                            if (await model.loginWithGoogle()) {
                              _routerSocial();
                            } else {
                              Fluttertoast.cancel();
                              Fluttertoast.showToast(
                                msg: appLang(context)!.has_error,
                              );
                            }
                          },
                          onLoginFacebook: () async {
                            if (await model.loginWithFacebook()) {
                              _routerSocial();
                            } else {
                              Fluttertoast.cancel();
                              Fluttertoast.showToast(
                                msg: appLang(context)!.has_error,
                              );
                            }
                          },
                        ),
                        SizedBox(
                          height: size.height * 0.03,
                        ),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black.withOpacity(0.5),
                                  fontFamily: fontBold,
                                ),
                                text: appLang(context)!.terms_of_use2,
                              ),
                              TextSpan(
                                style: const TextStyle(
                                    color: Colors.blue,
                                    decoration: TextDecoration.underline,
                                    fontStyle: FontStyle.italic,
                                    fontSize: 12),
                                text: appLang(context)!.terms_of_use,
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () async {
                                    var url =
                                        'https://hotro.tiki.vn/s/article/dieu-khoan-su-dung';
                                    if (await canLaunch(url)) {
                                      await launch(
                                        url,
                                        forceSafariVC: false,
                                      );
                                    }
                                  },
                              ),
                            ],
                          ),
                        )
                      ],
                    )
                  : Container(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButtonContinue({required Function() onCheckUserExisted}) =>
      BaseButton(
        height: 50,
        width: size.width * 0.9,
        onPressed: isValidatePhoneNumber ? onCheckUserExisted : null,
        title: appLang(context)!.continuee,
      );

  Widget _buildSocials({
    required Function() onLoginGoogle,
    required Function() onLoginFacebook,
  }) =>
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FloatingActionButton(
            heroTag: "facebook",
            onPressed: onLoginFacebook,
            backgroundColor: Colors.transparent,
            child: Image.asset("assets/ic_facebook.png"),
          ),
          SizedBox(
            width: size.width * 0.03,
          ),
          FloatingActionButton(
            heroTag: "google",
            backgroundColor: Colors.transparent,
            onPressed: onLoginGoogle,
            child: Image.asset("assets/ic_google.png"),
          ),
        ],
      );

  Widget _buildPhoneField({
    Function(String? value)? onChanged,
    Function(String? value)? onFieldSubmitted,
    FormFieldValidator<String>? validator,
  }) =>
      Form(
        key: formGlobalKey,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: BaseTextFormField(
            textInputFormatter: r'^([0-9]+([.][0-9]*)?|[.][0-9]+)',
            maxLength: 15,
            controller: phoneController,
            textInputAction: TextInputAction.send,
            hintText: "Phone number",
            onChanged: onChanged,
            onFieldSubmitted: onFieldSubmitted,
            validator: validator,
          ),
        ),
      );

  Future _checkUserExist({required AuthModel model}) async {
    LoadingDialog.show(context);
    currentPhone = PhoneNumber.fromIsoCode(countryCode, phoneController.text)
        .international;

    var res = await model.checkUserExisted(
      phoneNumber: currentPhone,
    );

    if (res == null) {
      LoadingDialog.dismiss(context);
      AwesomeDialog(
        context: context,
        dialogType: DialogType.ERROR,
        btnOkOnPress: () {},
        title: 'Error server!',
      ).show();
    } else if (res) {
      ///nếu đã tồn tại thì nhập pass, ngược lại thì đằng kí
      LoadingDialog.dismiss(context);
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => EnterPasswordView(
            phoneNumber: currentPhone,
          ),
        ),
      );
    } else {
      var res = await model.sendOTPRegister(
          phoneNumber: currentPhone,
          onlyAndroid: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => RegisterView(
                  phoneNumber: currentPhone,
                ),
              ),
              (route) => route.isFirst,
            );
          },
          gotoVerifyOTP: (verifyId) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EnterPinView(
                  phoneNumber: currentPhone,
                  verifyId: verifyId,
                  typeOTP: TypeOTP.register,
                ),
              ),
            );
          });

      LoadingDialog.dismiss(context);
    }
  }

  Future _routerSocial() async {
    final user = locator<AuthenticationService>().user;

    Role role = Role.values[user.roles?.first.id ?? 1];

    RouterLogin.navigation(context, role: role);
  }
}
