// ignore_for_file: implementation_imports

import 'package:dio/src/form_data.dart';
import 'package:flutter_maihomie_app/core/apis/api.dart';
import 'package:flutter_maihomie_app/core/models/discount.dart';
import 'package:flutter_maihomie_app/core/models/rating.dart';
import 'package:flutter_maihomie_app/core/models/task.dart';
import 'package:flutter_maihomie_app/service_locator.dart';

class TaskService {
  final _api = locator<Api>();

  Future<bool> updateTaskStatus({required FormData data}) async {
    // Map<String, dynamic> data = {};
    var res = await _api.updateTaskStatus(data: data);

    if (res != null) {
      return res.data;
    }

    return false;
  }

  Future<Task?> getDetailTask({required int taskId}) async {
    var res = await _api.getDetailTask(data: {"task_id": taskId});

    if (res != null && res.data != null) {
      return Task.fromJson(res.data);
    }

    return null;
  }

  Future<List<Task>> searchTask(
    String? searchString, {
    required int page,
    int addDay = 0,
    bool? status,
  }) async {
    Map<String, dynamic> data = {
      "page": page,
      "add_day": addDay,
    };

    if (status != null) {
      data['status'] = status ? 1 : 0;
    }

    if (searchString != null && searchString.isNotEmpty) {
      data.addAll({"search_string": searchString});
    }

    var res = await _api.searchTask(data: data);

    if (res != null) {
      return List<Task>.from(
        res.data.map((e) => Task.fromJson(e)).toList(),
      );
    }

    return [];
  }

  Future<List<Task>> getTaskHistory({required int page}) async {
    var res = await _api.getTaskHistory(data: {"page": page});

    if (res != null) {
      return List<Task>.from(res.data.map((e) => Task.fromJson(e)).toList());
    }

    return [];
  }

  Future<bool> cancelTask({required int id}) async {
    var res = await _api.cancelTask(data: {"task_id": id});

    if (res != null && res.data) {
      return true;
    }

    return false;
  }

  Future<Rating?> getRatingTask({required int taskId}) async {
    var res = await _api.getRatingTask(taskId: taskId);

    if (res != null && res.data != null) {
      return Rating.fromJson(res.data);
    }

    return null;
  }

  Future<Rating?> saveRating({required Map<String, dynamic> data}) async {
    var res = await _api.saveRating(data: data);

    if (res != null) {
      return Rating.fromJson(res.data);
    }

    return null;
  }

  Future<List<Discount>> getDiscounts(
    String? searchString, {
    required int page,
  }) async {
    var res = await _api.getDiscounts(data: {
      "page": page,
      "discount_code": searchString,
    });

    if (res != null) {
      return List<Discount>.from(
        res.data.map((e) => Discount.fromJson(e)).toList(),
      );
    }

    return [];
  }

  Future<bool> addDiscountTask(Discount discount, int taskId) async {
    var res = await _api.addDiscountTask(data: {
      "discount_id": discount.id,
      "task_id": taskId,
    });

    if (res != null && res.data) {
      return res.data;
    }

    return false;
  }

  Future<bool> removeVoucher(int taskId, int discountId) async {
    var res = await _api.removeDiscountTask(data: {
      "discount_id": discountId,
      "task_id": taskId,
    });

    if (res != null && res.data) {
      return res.data;
    }

    return false;
  }

  Future<dynamic> changeSumSpent() async {
    var res = await _api.changeSumSpent();

    if (res != null) {
      return res.data;
    }

    return null;
  }
}
