import 'package:flutter_maihomie_app/core/apis/api.dart';
import 'package:flutter_maihomie_app/core/services/auth_service.dart';
import 'package:flutter_maihomie_app/core/services/booking_service.dart';
import 'package:flutter_maihomie_app/core/services/locale_service.dart';
import 'package:flutter_maihomie_app/core/services/post_service.dart';
import 'package:flutter_maihomie_app/core/services/product_service.dart';
import 'package:flutter_maihomie_app/core/services/revenue_service.dart';
import 'package:flutter_maihomie_app/core/services/role_service.dart';
import 'package:flutter_maihomie_app/core/services/shared_preferences_service.dart';
import 'package:flutter_maihomie_app/core/services/task_service.dart';
import 'package:flutter_maihomie_app/core/services/user_service.dart';
import 'package:flutter_maihomie_app/core/services/youtube_service.dart';
import 'package:flutter_maihomie_app/core/state_models/admin_model/collect_money_model.dart';
import 'package:flutter_maihomie_app/core/state_models/admin_model/hr_model.dart';
import 'package:flutter_maihomie_app/core/state_models/admin_model/product_model.dart';
import 'package:flutter_maihomie_app/core/state_models/auth_model.dart';
import 'package:flutter_maihomie_app/core/state_models/booking_model.dart';
import 'package:flutter_maihomie_app/core/state_models/history_model.dart';
import 'package:flutter_maihomie_app/core/state_models/home_page_model.dart';
import 'package:flutter_maihomie_app/core/state_models/story_model.dart';
import 'package:flutter_maihomie_app/core/state_models/stylist_model/report_task_model.dart';
import 'package:flutter_maihomie_app/ui/utils/store_secure.dart';
import 'package:get_it/get_it.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  //APIs - Services
  locator.registerLazySingleton(() => YoutubeService());
  locator.registerLazySingleton(() => StoreSecure());
  locator.registerLazySingleton(() => SharedPreferencesService());
  locator.registerLazySingleton(() => AuthenticationService());
  locator.registerLazySingleton(() => UserService());
  locator.registerLazySingleton(() => TaskService());
  locator.registerLazySingleton(() => BookingService());
  locator.registerLazySingleton(() => RoleService());
  locator.registerLazySingleton(() => PostService());
  locator.registerLazySingleton(() => ProductService());
  locator.registerLazySingleton(() => LocaleService());
  locator.registerLazySingleton(() => RevenueService());

  //Api
  locator.registerLazySingleton(() => Api());

  //ViewModels
  locator.registerFactory(() => BookingModel());
  locator.registerFactory(() => AuthModel());
  locator.registerFactory(() => HomePageModel());
  locator.registerFactory(() => HistoryModel());
  locator.registerFactory(() => HRModel());
  locator.registerFactory(() => ProductModel());
  locator.registerFactory(() => StoryModel());
  locator.registerFactory(() => ReportTaskModel());
  locator.registerFactory(() => CollectMoneyModel());
}
