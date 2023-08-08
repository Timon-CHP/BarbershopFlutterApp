import 'package:flutter_maihomie_app/ui/utils/server_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  final keyLoginWithSocial = 'LOGIN_WITH_SOCIAL';
  SharedPreferences? prefs;

  SharedPreferencesService() {
    getInstance();
  }

  setSocial(TypeSocial typeSocial) async {
    prefs?.setInt(keyLoginWithSocial, typeSocial.index);
  }

  int getSocial() {
    return prefs?.getInt(keyLoginWithSocial) ?? 0;
  }

  getInstance() async {
    if (prefs == null) {
      prefs = await SharedPreferences.getInstance();
    } else {
      return;
    }
  }
}
