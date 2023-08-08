import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_maihomie_app/core/services/auth_service.dart';
import 'package:flutter_maihomie_app/service_locator.dart';
import 'package:flutter_maihomie_app/ui/utils/constants.dart';
import 'package:flutter_maihomie_app/ui/utils/helper.dart';
import 'package:flutter_maihomie_app/ui/utils/style.dart';
import 'package:flutter_maihomie_app/ui/widgets/dialogs/change_password.dart';
import 'package:flutter_maihomie_app/ui/widgets/dialogs/check_password_dialog.dart';
import 'package:flutter_maihomie_app/ui/widgets/dialogs/logout_dialog.dart';
import 'package:flutter_maihomie_app/ui/widgets/language_widget.dart';

class AccountPageView extends StatefulWidget {
  const AccountPageView({Key? key}) : super(key: key);

  @override
  _AccountPageViewState createState() => _AccountPageViewState();
}

class _AccountPageViewState extends State<AccountPageView> {
  Size size = Size.zero;
  final user = locator<AuthenticationService>().user;

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;

    return Scaffold(
      body: Column(
        children: [
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, "/your-story");
            },
            child: Container(
              padding: const EdgeInsets.all(12),
              height: size.height * 0.15,
              child: Material(
                elevation: 8.0,
                borderRadius: BorderRadius.circular(12.0),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: borderRadiusCircle,
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: Image.network(
                            user.avatar != null
                                ? "$localHost${user.avatar}"
                                : avatarDefault,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                appLang(context)!.hello_user(""),
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 18,
                                  fontFamily: fontBold,
                                ),
                              ),
                              Text(
                                '${user.name}',
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 28,
                                  fontFamily: fontBold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(
                parent: ClampingScrollPhysics(),
              ),
              child: Column(
                children: [
                  user.phoneNumber != null
                      ? _buildTileSetting(
                          icon: const Icon(
                            Icons.password_sharp,
                            color: Colors.purple,
                          ),
                          title: appLang(context)!.change_password,
                          onPress: () async {
                            var res = await CheckPasswordDialog.show(context);

                            if (res != null && res) {
                              var resCP =
                                  await ChangePasswordDialog.show(context);

                              if (resCP != null && resCP) {
                                AwesomeDialog(
                                  context: context,
                                  title: "${appLang(context)!.success}!",
                                  dialogType: DialogType.SUCCES,
                                  btnOkOnPress: () {},
                                ).show();
                              }
                            }
                          },
                        )
                      : Container(),
                  const LanguageWidget(),
                  _buildTileSetting(
                    icon: const Icon(
                      Icons.logout,
                      color: Colors.red,
                    ),
                    title: appLang(context)!.logout,
                    onPress: () {
                      LogoutDialog.show(context);
                    },
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildTileSetting({
    required Widget icon,
    required String title,
    required Function() onPress,
  }) {
    return Container(
      height: size.height * 0.1,
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
      width: size.width,
      child: Material(
        elevation: 8.0,
        borderRadius: BorderRadius.circular(12.0),
        child: InkWell(
          onTap: onPress,
          borderRadius: BorderRadius.circular(12.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                icon,
                const SizedBox(
                  width: 8,
                ),
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
