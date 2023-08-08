import 'package:flutter/material.dart';
import 'package:flutter_maihomie_app/core/state_models/auth_model.dart';
import 'package:flutter_maihomie_app/ui/utils/colors.dart';
import 'package:flutter_maihomie_app/ui/utils/constants.dart';
import 'package:flutter_maihomie_app/ui/utils/helper.dart';
import 'package:flutter_maihomie_app/ui/views/_base.dart';
import 'package:flutter_maihomie_app/ui/widgets/button_login.dart';
import 'package:flutter_maihomie_app/ui/widgets/text_regex.dart';

class ChangePasswordView extends StatefulWidget {
  final String phoneNumber;

  const ChangePasswordView({Key? key, required this.phoneNumber})
      : super(key: key);

  @override
  _ChangePasswordViewState createState() => _ChangePasswordViewState();
}

class _ChangePasswordViewState extends State<ChangePasswordView> {
  final formKey = GlobalKey<FormState>();
  bool isHidePassword = false;
  Size size = Size.zero;
  final formPassKey = GlobalKey<FormState>();
  final formNameKey = GlobalKey<FormState>();
  final passEditingController = TextEditingController();

  String currentPassword = '';
  String currentName = '';

  String? messageValidatePassword;
  String? messageValidateName;
  bool isUppercase = false;
  bool isNumeric = false;
  bool isLength = false;
  bool isValidatedName = false;

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;

    return BaseView<AuthModel>(
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(),
        backgroundColor: backgroundColor,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),
                    _buildNewPasswordField(
                      onFieldSubmitted: (_) async {
                        //TODO reset API
                        // _resetPass(mdoel: model);
                      },
                      validator: (_) {
                        RegExp regex = RegExp(
                            r'^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[a-zA-Z]).{8,}$');
                        if (!regex.hasMatch(currentPassword)) {
                          return appLang(context)!.warning_pass_invalid;
                        } else {
                          return '';
                        }
                      },
                      onChange: (value) {
                        currentPassword = passEditingController.text;
                        formKey.currentState?.validate();
                      },
                      changeCurrentPassword: (value) {
                        currentPassword = passEditingController.text;
                      },
                      passEditingController: passEditingController,
                      currentPassword: currentPassword,
                    ),
                    _buildRegex(
                      isLength: isLength,
                      isNumeric: isNumeric,
                      isUppercase: isUppercase,
                    ),
                  ],
                ),
                _buildButtonChangePass(
                  isAllReady: isLength && isNumeric && isUppercase,
                  onChangePassword: () async {
                    //TODO reset API
                    // _resetPass(model: model);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() => Text(
        appLang(context)!.create_new_pass,
        style: const TextStyle(
          fontSize: 36,
          fontFamily: fontBold,
          color: headerColor1,
        ),
        textAlign: TextAlign.left,
      );

  Widget _buildNewPasswordField({
    required Function(String) onFieldSubmitted,
    required String Function(String?)? validator,
    required Function(String?) onChange,
    required Function(String) changeCurrentPassword,
    required TextEditingController passEditingController,
    required String currentPassword,
  }) =>
      Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: TextFormField(
            style: const TextStyle(
              color: Colors.black,
              fontSize: 24,
            ),
            // autofillHints: const [AutofillHints.],
            textInputAction: TextInputAction.done,
            validator: validator,
            cursorColor: Colors.black,
            controller: passEditingController,
            keyboardType: TextInputType.visiblePassword,
            obscureText: isHidePassword,
            obscuringCharacter: '*',
            onChanged: onChange,
            onFieldSubmitted: onFieldSubmitted,
            maxLength: 250,
            autocorrect: true,
            decoration: InputDecoration(
              hintText: appLang(context)!.password,
              counterText: "",
              hintStyle: TextStyle(
                fontSize: 24,
                color: Colors.grey.withOpacity(0.5),
              ),
              labelText: appLang(context)!.warning_enter_password,
              floatingLabelBehavior: FloatingLabelBehavior.always,
              labelStyle: TextStyle(
                color: Colors.black.withOpacity(0.5),
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
              suffix: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  currentPassword.isNotEmpty
                      ? IconButton(
                          splashColor: Colors.transparent,
                          onPressed: () {
                            changeCurrentPassword('');
                          },
                          icon: const Icon(
                            Icons.cancel,
                            size: 24,
                            color: Colors.red,
                          ),
                        )
                      : Container(),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        isHidePassword = !isHidePassword;
                      });
                    },
                    style: const ButtonStyle(
                        splashFactory: NoSplash.splashFactory),
                    child: Text(
                      isHidePassword
                          ? appLang(context)!.show
                          : appLang(context)!.hide,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

  Widget _buildButtonChangePass(
          {required bool isAllReady, required Function() onChangePassword}) =>
      Positioned(
        bottom: size.height * 0.02,
        child: BaseButton(
          height: size.height * 0.06,
          width: size.width * 0.9,
          onPressed: isAllReady ? onChangePassword : null,
          title: appLang(context)!.complete,
        ),
      );

  Widget _buildRegex({
    required bool isUppercase,
    required bool isNumeric,
    required bool isLength,
  }) =>
      Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextRegex(
              title: appLang(context)!.warning_upcase,
              validated: isUppercase,
            ),
            TextRegex(
              title: appLang(context)!.warning_numeric,
              validated: isNumeric,
            ),
            TextRegex(
              title: appLang(context)!.warning_length,
              validated: isLength,
            ),
          ],
        ),
      );

// Future _resetPass({required LoginModel model}) async {
//   LoadingDialog.show(context);
//   if (await model.changePassword(
//       currentPassword: currentPassword, phoneNumber: widget.phoneNumber)) {
//     LoadingDialog.dismiss(context);
//     AwesomeDialog(
//       context: context,
//       dialogType: DialogType.SUCCES,
//       title: 'Successful',
//       btnOkOnPress: () {
//         Navigator.of(context).popUntil((route) => route.isFirst);
//       },
//       dismissOnBackKeyPress: false,
//       dismissOnTouchOutside: false,
//     ).show();
//   } else {
//     LoadingDialog.dismiss(context);
//     AwesomeDialog(
//       context: context,
//       dialogType: DialogType.ERROR,
//       title: 'Fail',
//     ).show();
//   }
// }
}
