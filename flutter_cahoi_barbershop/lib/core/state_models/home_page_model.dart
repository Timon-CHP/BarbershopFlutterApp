import 'package:flutter/material.dart';
import 'package:flutter_maihomie_app/core/models/clip_youtube.dart';
import 'package:flutter_maihomie_app/core/services/youtube_service.dart';
import 'package:flutter_maihomie_app/service_locator.dart';
import 'package:flutter_maihomie_app/ui/utils/helper.dart';

class HomePageModel extends ChangeNotifier {
  final _youtubeApi = locator<YoutubeService>();

  bool _disposed = false;

  List<IdClipYouTube> clipIdList = [];
  List<ClipYouTube> clipInfoList = [];

  Future changeClipIdList() async {
    var response = await _youtubeApi.getPlayListYouTube(maxResults: 5);

    clipIdList =
        response.values.first.map((i) => IdClipYouTube.fromMap(i)).toList();

    notifyListeners();

    await changeClipInfoList(clipIdList);
  }

  Future changeClipInfoList(List<IdClipYouTube> clipIdList) async {
    var response = await _youtubeApi.getInfoVideosYouTube(clipIdList);

    try {
      clipInfoList += response.map((i) => ClipYouTube.fromJson(i)).toList();

      notifyListeners();
    } catch (e) {
      logger.e(e.toString());
    }
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  @override
  void notifyListeners() {
    if (!_disposed) {
      super.notifyListeners();
    }
  }

  initHomePage() {
    changeClipIdList();
  }
}
