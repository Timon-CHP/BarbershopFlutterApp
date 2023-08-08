import 'package:dio/src/form_data.dart';
import 'package:flutter_maihomie_app/core/apis/api.dart';
import 'package:flutter_maihomie_app/core/models/user.dart';
import 'package:flutter_maihomie_app/service_locator.dart';

class UserService {
  final Api _api = locator<Api>();

  Future<List<MUser>> searchUser(String? searchString,
      {required int page}) async {
    Map<String, dynamic> data = {"page": page};
    if (searchString != null) {
      data["search_string"] = searchString;
    }

    var res = await _api.searchUser(data);

    if (res != null) {
      return List<MUser>.from(res.data.map((i) => MUser.fromJson(i)).toList());
    }

    return [];
  }

  Future<bool> signCalender() async {
    var res = await _api.signCalender();
    if (res != null) {
      return res.data;
    }
    return false;
  }

  Future<bool?> changeAvatar({required FormData data}) async {
    var res = await _api.changeAvatar(data: data);
    if (res != null) {
      return res.data;
    }
    return false;
  }

  Future fetch() async {
    await _api.fetch();
  }
}
