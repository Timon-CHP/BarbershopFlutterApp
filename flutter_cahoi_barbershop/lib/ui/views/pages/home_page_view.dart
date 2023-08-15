import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:date_format/date_format.dart' as date_format;
import 'package:flutter/material.dart';
import 'package:flutter_maihomie_app/core/fake-data/data.dart';
import 'package:flutter_maihomie_app/core/models/clip_youtube.dart';
import 'package:flutter_maihomie_app/core/services/auth_service.dart';
import 'package:flutter_maihomie_app/core/services/booking_service.dart';
import 'package:flutter_maihomie_app/core/state_models/home_page_model.dart';
import 'package:flutter_maihomie_app/service_locator.dart';
import 'package:flutter_maihomie_app/ui/utils/colors.dart';
import 'package:flutter_maihomie_app/ui/utils/constants.dart';
import 'package:flutter_maihomie_app/ui/utils/helper.dart';
import 'package:flutter_maihomie_app/ui/utils/style.dart';
import 'package:flutter_maihomie_app/ui/views/_base.dart';
import 'package:flutter_maihomie_app/ui/views/membership_view.dart';
import 'package:flutter_maihomie_app/ui/views/playlist_youtube/play_clip_view.dart';
import 'package:flutter_maihomie_app/ui/views/playlist_youtube/playlist_youtube_view.dart';
import 'package:flutter_maihomie_app/ui/widgets/avatar.dart';
import 'package:flutter_maihomie_app/ui/widgets/slider_image.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePageView extends StatefulWidget {
  const HomePageView({Key? key}) : super(key: key);

  @override
  _HomePageViewState createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView> {
  Size size = Size.zero;
  final user = locator<AuthenticationService>().user;

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return BaseView<HomePageModel>(
      onModelReady: (model) {
        model.initHomePage();
      },
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          backgroundColor: textColorLight2,
          leading: IconButton(
            onPressed: null,
            // onPressed: () async {},
            icon: const Icon(
              Icons.notifications_none,
              size: 24,
            ),
            tooltip: appLang(context)!.notification,
          ),
          title: Center(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/logo_appbar.png",
                  height: 50,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.error);
                  },
                ),
                const Text('Mai Homie')
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          heroTag: 'HostLine',
          backgroundColor:
              Theme.of(context).floatingActionButtonTheme.backgroundColor,
          onPressed: () async {
            if (await canLaunch("tel:$hostLine")) {
              await launch("tel:$hostLine");
            }
          },
          tooltip: 'Hotline',
          child: Icon(
            Icons.call,
            color: Theme.of(context).backgroundColor,
          ),
        ),
        body: Column(
          children: [
            SizedBox(
              height: size.height * 0.255,
              child: Stack(
                children: [
                  Positioned(
                    top: 0,
                    child: SizedBox(
                      height: size.height * 0.188,
                      width: size.width,
                      child: Image.asset(
                        "assets/bg_login.png",
                        fit: BoxFit.fitWidth,
                        color: Colors.black.withOpacity(0),
                        colorBlendMode: BlendMode.colorBurn,
                      ),
                    ),
                  ),
                  // Positioned(
                  //   top: 12,
                  //   left: 12,
                  //   right: 12,
                  //   child: Row(
                  //     crossAxisAlignment: CrossAxisAlignment.start,
                  //     children: [
                  //       Avatar(
                  //         height: size.width * 0.18,
                  //         src: user.avatar != null
                  //             ? "$localHost${user.avatar}"
                  //             : avatarDefault,
                  //       ),
                  //       Expanded(
                  //         child: Container(
                  //           padding: const EdgeInsets.symmetric(
                  //             horizontal: 8.0,
                  //             vertical: 4.0,
                  //           ),
                  //           child: Column(
                  //             crossAxisAlignment: CrossAxisAlignment.start,
                  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //             children: [
                  //               const SizedBox(
                  //                 height: 8,
                  //               ),
                  //               Text(
                  //                 "${user.name}",
                  //                 style: const TextStyle(
                  //                   fontSize: 24,
                  //                   fontFamily: fontBold,
                  //                   color: headerColor1,
                  //                 ),
                  //               ),
                  //               const SizedBox(
                  //                 height: 8,
                  //               ),
                  //               Text(
                  //                 "${appLang(context)!.your_rank} ${user.rank?.rankName}",
                  //                 style: TextStyle(
                  //                     color: user.rank?.id == 1
                  //                         ? Colors.white
                  //                         : Colors.yellow,
                  //                     shadows: const [
                  //                       Shadow(
                  //                           color: Colors.white,
                  //                           offset: Offset(0, 0),
                  //                           blurRadius: 10),
                  //                     ]),
                  //               ),
                  //             ],
                  //           ),
                  //         ),
                  //       )
                  //     ],
                  //   ),
                  // ),
                  Positioned(
                    bottom: 12,
                    left: 12,
                    right: 12,
                    child: Material(
                      elevation: 8.0,
                      borderRadius: BorderRadius.circular(8.0),
                      child: SizedBox(
                        width: size.width,
                        height: size.height * 0.1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildNaviRoute(
                              context: context,
                              icons: "assets/ic_calendar.png",
                              title: appLang(context)!.navi_home_booking,
                              onTap: () async {
                                if (await locator<BookingService>()
                                    .checkCanBook()) {
                                  Navigator.pushNamed(context, '/booking');
                                } else {
                                  AwesomeDialog(
                                    context: context,
                                    btnOkOnPress: () {
                                      Navigator.pushNamed(context, '/history');
                                    },
                                    title: appLang(context)!.warningg,
                                    titleTextStyle: styleTitleDialog,
                                    dialogType: DialogType.WARNING,
                                    desc: appLang(context)!.warning_task,
                                    descTextStyle: styleDescDialog,
                                  ).show();
                                }
                              },
                            ),
                            _buildNaviRoute(
                              context: context,
                              icons: "assets/ic_history.png",
                              title: appLang(context)!.navi_home_history,
                              onTap: () {
                                Navigator.pushNamed(context, '/history');
                              },
                            ),
                            // _buildNaviRoute(
                            //   context: context,
                            //   icons: "assets/ic_membership.png",
                            //   title: appLang(context)!.navi_home_member,
                            //   onTap: () {
                            //     Navigator.pushNamed(
                            //       context,
                            //       MembershipView.name,
                            //     );
                            //   },
                            // ),
                            // _buildNaviRoute(
                            //   context: context,
                            //   icons: "assets/ic_gift.png",
                            //   title: appLang(context)!.navi_home_reward,
                            //   onTap: () => null,
                            // ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(
                  parent: ClampingScrollPhysics(),
                ),
                child: Column(
                  children: [
                    SliderImage(
                      height: size.height * 0.23,
                      width: size.width,
                      items: itemsSlider,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "MaiHomie's videos",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: fontBold,
                                ),
                              ),
                              TextButton(
                                style: const ButtonStyle(
                                  splashFactory: NoSplash.splashFactory,
                                ),
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const PlaylistYoutube(),
                                    ),
                                  );
                                },
                                child: Text(
                                  "${appLang(context)!.more} >",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontFamily: fontBold,
                                    color: Colors.cyan,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: size.width,
                            height: size.height * 0.33,
                            child: ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              padding: const EdgeInsets.only(
                                bottom: 10.0,
                              ),
                              itemCount: model.clipInfoList.length > 5
                                  ? 5
                                  : model.clipInfoList.length,
                              itemBuilder: (context, index) {
                                return _buildChanelYoutubeTile(
                                  model.clipInfoList[index],
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNaviRoute({
    required BuildContext context,
    required String icons,
    required String title,
    required Function() onTap,
  }) =>
      Expanded(
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                icons,
                color: Theme.of(context).primaryColor,
                height: 32,
              ),
              const SizedBox(
                height: 8.0,
              ),
              Text(
                title,
                style: Theme.of(context).textTheme.bodyText2,
              )
            ],
          ),
        ),
      );

  Widget _buildChanelYoutubeTile(ClipYouTube item) {
    final width = size.width * 0.8;
    final heightImage = width * 9 / 16;

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => PlayClipView(id: item.id),
          ),
        );
      },
      child: Card(
        child: Stack(
          children: [
            ClipRRect(
              child: Image.network(
                item.linkImage,
                width: width,
                height: heightImage - 12,
                fit: BoxFit.cover,
              ),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(4.0),
              ),
            ),
            Positioned(
              top: heightImage - 12,
              right: 0,
              left: 0,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: ClipRRect(
                  child: Column(
                    children: [
                      Text(
                        item.title,
                        maxLines: 2,
                        style: const TextStyle(
                          fontFamily: fontBold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const Divider(color: Colors.black),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('${item.viewCount} views'),
                          Text(
                            date_format.formatDate(
                                DateTime.tryParse(item.publishedAt) ??
                                    DateTime.now(),
                                fullFormatDatetime),
                          ),
                        ],
                      )
                    ],
                  ),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(8.0),
                    bottomRight: Radius.circular(8.0),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
