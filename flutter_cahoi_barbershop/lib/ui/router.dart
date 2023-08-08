import 'package:flutter/material.dart';
import 'package:flutter_maihomie_app/home_view.dart';
import 'package:flutter_maihomie_app/ui/splash_view.dart';
import 'package:flutter_maihomie_app/ui/views/auth/login_view.dart';
import 'package:flutter_maihomie_app/ui/views/booking/booking_view.dart';
import 'package:flutter_maihomie_app/ui/views/history_view.dart';
import 'package:flutter_maihomie_app/ui/views/info_product_view.dart';
import 'package:flutter_maihomie_app/ui/views/membership_view.dart';
import 'package:flutter_maihomie_app/ui/views/promotion_mechanism_view.dart';
import 'package:flutter_maihomie_app/ui/views/rating_task_view.dart';
import 'package:flutter_maihomie_app/ui/views/your_story_view.dart';
import 'package:flutter_maihomie_app/ui_admin/home_admin_view.dart';
import 'package:flutter_maihomie_app/ui_admin/views/edit_user_view.dart';
import 'package:flutter_maihomie_app/ui_admin/views/product/add_product.dart';
import 'package:flutter_maihomie_app/ui_admin/views/product/edit_product.dart';
import 'package:flutter_maihomie_app/ui_admin/views/product/show_product_view.dart';
import 'package:flutter_maihomie_app/ui_employee/add_voucher_view.dart';
import 'package:flutter_maihomie_app/ui_employee/employee_home_view.dart';
import 'package:flutter_maihomie_app/ui_employee/report_task_view.dart';
import 'package:flutter_maihomie_app/ui_employee/show_task_view.dart';

const String initialRoute = "/splash";

class Router {
  static Map<String, Widget Function(BuildContext)> defineRoute = {
    '/splash': (BuildContext ctx) => const SplashView(),
    '/home': (BuildContext ctx) => const HomeView(),
    '/login': (BuildContext ctx) => const LoginView(),
    '/booking': (BuildContext ctx) => const BookingView(),
    '/history': (BuildContext ctx) => const HistoryView(),
    '/your-story': (BuildContext ctx) => const YourStoryView(),
    '/info-product': (BuildContext ctx) => const InfoProductView(),
    RatingTaskView.name: (BuildContext ctx) => const RatingTaskView(),
    MembershipView.name: (BuildContext ctx) => const MembershipView(),
    PromotionMechanismView.name: (BuildContext ctx) =>
        const PromotionMechanismView(),

    ///Employee
    '/report-task': (BuildContext ctx) => const ReportTaskView(),
    '/show-task': (BuildContext ctx) => const ShowTaskView(),
    '/employee-home': (BuildContext ctx) => const EmployeeHomeView(),

    ///admin
    '/home-super-admin': (BuildContext ctx) => const HomeAdminView(),
    '/edit-user': (BuildContext ctx) => const EditUserView(),
    AddProductView.name: (BuildContext ctx) => const AddProductView(),
    EditProductView.name: (BuildContext ctx) => const EditProductView(),
    ShowProductView.name: (BuildContext ctx) => const ShowProductView(),
    AddVoucherView.name: (BuildContext ctx) => const AddVoucherView(),

    ///Test
  };
}
