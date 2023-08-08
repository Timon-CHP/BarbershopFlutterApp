import 'package:flutter/material.dart';
import 'package:flutter_maihomie_app/core/services/auth_service.dart';
import 'package:flutter_maihomie_app/service_locator.dart';
import 'package:flutter_maihomie_app/ui/utils/colors.dart';
import 'package:flutter_maihomie_app/ui/utils/constants.dart';
import 'package:flutter_maihomie_app/ui/utils/helper.dart';
import 'package:flutter_maihomie_app/ui/utils/server_config.dart';
import 'package:flutter_maihomie_app/ui/utils/style.dart';
import 'package:flutter_maihomie_app/ui/views/pages/story_page_view.dart';
import 'package:flutter_maihomie_app/ui/widgets/dialogs/logout_dialog.dart';
import 'package:flutter_maihomie_app/ui_employee/task_tab.dart';

class EmployeeHomeView extends StatefulWidget {
  const EmployeeHomeView({Key? key}) : super(key: key);

  @override
  State<EmployeeHomeView> createState() => _EmployeeHomeViewState();
}

class _EmployeeHomeViewState extends State<EmployeeHomeView> {
  Size size = Size.zero;

  EmployeeTab currentTab = EmployeeTab.task;

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    final user = locator<AuthenticationService>().user;

    return Scaffold(
      appBar: AppBar(),
      drawer: Drawer(
        child: Column(
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: primaryColor,
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ClipRRect(
                      borderRadius: borderRadiusCircle,
                      child: SizedBox(
                        width: size.width * 0.2,
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
                    ),
                    Text(
                      '${user.name}',
                      style: const TextStyle(
                        fontSize: 24,
                        color: headerColor1,
                        fontFamily: fontBold,
                      ),
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              child: ListView(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                physics: const BouncingScrollPhysics(),
                children: [
                  ListTile(
                    onTap: () {
                      setState(() {
                        currentTab = EmployeeTab.task;
                      });
                      Navigator.pop(context);
                    },
                    leading: const Icon(Icons.cut),
                    title: const Text(
                      'Nhiệm vụ',
                    ),
                  ),
                  const Divider(),
                  ListTile(
                    onTap: () {
                      setState(() {
                        currentTab = EmployeeTab.story;
                      });
                      Navigator.pop(context);
                    },
                    leading: const Icon(Icons.history_edu),
                    title: Text(
                      appLang(context)!.bottombar_story,
                    ),
                  ),
                  const Divider(),
                  ListTile(
                    onTap: () async {
                      LogoutDialog.show(context);
                    },
                    leading: const Icon(
                      Icons.logout,
                      color: Colors.red,
                    ),
                    title: const Text('Đăng xuất'),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      body: SafeArea(
        child: _getTab(),
      ),
    );
  }

  Widget _getTab() {
    switch (currentTab) {
      case EmployeeTab.task:
        return const TaskTab();
      case EmployeeTab.story:
        return const StoryPageView();
    }
  }
}
