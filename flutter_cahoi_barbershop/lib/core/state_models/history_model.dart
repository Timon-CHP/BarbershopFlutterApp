import 'package:flutter_maihomie_app/core/models/rating.dart';
import 'package:flutter_maihomie_app/core/models/task.dart';
import 'package:flutter_maihomie_app/core/services/post_service.dart';
import 'package:flutter_maihomie_app/core/services/task_service.dart';
import 'package:flutter_maihomie_app/core/state_models/base.dart';
import 'package:flutter_maihomie_app/service_locator.dart';
import 'package:fluttertoast/fluttertoast.dart';

class HistoryModel extends BaseModel {
  final _taskService = locator<TaskService>();
  final _postService = locator<PostService>();

  List<Task> tasks = [];
  int currentPage = 1;
  bool isLoading = false;
  dynamic sumSpent;

  Future changeTasksHistory() async {
    if (currentPage == 0) {
      return;
    }

    isLoading = true;
    notifyListeners();

    var res = await _taskService.getTaskHistory(page: currentPage);
    currentPage++;
    if (res.isEmpty) {
      currentPage = 0;
    }
    tasks += res;
    isLoading = false;
    notifyListeners();
  }

  Future<bool> sharePost({required Task task, String caption = ''}) async {
    return await _postService.sharePost(
      taskId: task.id ?? 0,
      caption: caption.isNotEmpty ? caption : null,
    );
  }

  Future cancelTask({required int id}) async {
    var res = await _taskService.cancelTask(id: id);

    if (res) {
      tasks.removeWhere((element) => element.id == id);
      Fluttertoast.showToast(msg: "Thành công!");
      notifyListeners();
    } else {
      Fluttertoast.showToast(msg: "Đã có sự có sảy ra!");
    }
  }

  Future<Rating?> checkRatingTask({int? taskId}) async {
    if (taskId == null) return null;
    return await _taskService.getRatingTask(taskId: taskId);
  }

  Future<bool> saveRating({required Map<String, dynamic> data}) async {
    var res = await _taskService.saveRating(data: data);
    return res != null;
  }

  Future changeSumSpent() async {
    sumSpent = await _taskService.changeSumSpent();
    notifyListeners();
  }
}
