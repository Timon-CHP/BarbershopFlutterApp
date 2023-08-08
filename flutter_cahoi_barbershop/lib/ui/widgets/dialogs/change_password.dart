import 'package:flutter/material.dart';
import 'package:flutter_maihomie_app/core/state_models/auth_model.dart';
import 'package:flutter_maihomie_app/ui/utils/helper.dart';
import 'package:flutter_maihomie_app/ui/utils/style.dart';
import 'package:flutter_maihomie_app/ui/views/_base.dart';
import 'package:flutter_maihomie_app/ui/widgets/dialogs/loading_dialog.dart';

class ChangePasswordDialog {
  static Future<bool?> show(BuildContext context) async {
    var res = await showDialog(
      context: context,
      builder: (_) => const _ChangePasswordBody(),
    );

    return res;
  }

  static dismiss(BuildContext context) {
    Navigator.pop(context);
  }
}

class _ChangePasswordBody extends StatefulWidget {
  const _ChangePasswordBody({Key? key}) : super(key: key);

  @override
  State<_ChangePasswordBody> createState() => _ChangePasswordBodyState();
}

class _ChangePasswordBodyState extends State<_ChangePasswordBody> {
  final formKey = GlobalKey<FormState>();
  final controller = TextEditingController();

  bool isHintPass = true;
  bool isError = false;

  @override
  Widget build(BuildContext context) {
    return BaseView<AuthModel>(
      builder: (context, model, child) => AlertDialog(
        title: Text(
          appLang(context)!.create_new_pass,
        ),
        shape: RoundedRectangleBorder(borderRadius: borderRadius12),
        content: Form(
          key: formKey,
          child: TextFormField(
            controller: controller,
            decoration: InputDecoration(
              hintText: "Abcd1234",
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    isHintPass = !isHintPass;
                  });
                },
                icon: Icon(
                  isHintPass
                      ? Icons.remove_red_eye_outlined
                      : Icons.remove_red_eye,
                  color: isHintPass ? Colors.grey : Colors.blue,
                ),
              ),
            ),
            obscureText: isHintPass,
            validator: (_) {
              if (controller.text.isEmpty || controller.text.length < 8) {
                return appLang(context)!.warning_length;
              }

              if (validateNumeric(controller.text)) {
                return appLang(context)!.warning_numeric;
              }

              if (validateUppercase(controller.text)) {
                return appLang(context)!.warning_upcase;
              }

              if (isError) {
                return appLang(context)!.wrong_password;
              }

              return null;
            },
            onChanged: (_) {
              isError = false;
              formKey.currentState!.validate();
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              appLang(context)!.cancel,
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              if (!formKey.currentState!.validate()) {
                return;
              }

              LoadingDialog.show(context);

              final res = await model.changePassword(
                newPassword: controller.text,
              );

              LoadingDialog.dismiss(context);

              Navigator.pop(context, res);
            },
            child: const Text("Ok"),
          ),
        ],
      ),
    );
  }
}
