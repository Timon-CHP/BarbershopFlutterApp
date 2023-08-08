import 'package:flutter_maihomie_app/core/apis/api.dart';
import 'package:flutter_maihomie_app/core/models/revenue.dart';
import 'package:flutter_maihomie_app/service_locator.dart';

class RevenueService {
  final _api = locator<Api>();

  Future<List<Revenue>> getRevenueMonth({
    required int addMonth,
  }) async {
    var res = await _api.getRevenueMonth(
      data: {
        "add_month": addMonth,
      },
    );

    if (res != null) {
      return List<Revenue>.from(
        res.data.map((e) => Revenue.fromJson(e)).toList(),
      );
    }

    return [];
  }

  Future<bool> paid(int revenueId) async {
    var res = await _api.paid(
      data: {
        "revenue_id": revenueId,
      },
    );

    if (res != null) {
      return res.data;
    }

    return false;
  }

  Future fetchTotalMonth() async {
    await _api.fetchTotalMonth();
  }
}
