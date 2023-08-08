import 'package:dio/dio.dart';
import 'package:flutter_maihomie_app/core/models/data_post.dart';
import 'package:flutter_maihomie_app/core/models/post2.dart';
import 'package:flutter_maihomie_app/core/services/auth_service.dart';
import 'package:flutter_maihomie_app/core/services/post_service.dart';
import 'package:flutter_maihomie_app/core/services/user_service.dart';
import 'package:flutter_maihomie_app/core/state_models/base.dart';
import 'package:flutter_maihomie_app/service_locator.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class StoryModel extends BaseModel {
  final _postService = locator<PostService>();
  final _userService = locator<UserService>();
  final _authService = locator<AuthenticationService>();

  List<Post2> posts = [];
  List<Post2> postsLastMonth = [];
  List<int> likedPost = [];

  bool isLoading = false;
  int currentPage = 1;

  Future changePosts({int? userId}) async {
    if (currentPage == 0) {
      return;
    }

    isLoading = true;

    notifyListeners();

    DataPost? res;
    if (userId != null) {
      res = await _postService.getWall(
        userId: userId,
        page: currentPage,
      );
    } else {
      res = await _postService.getPost(
        page: currentPage,
      );
    }

    if (res != null && res.posts != null) {
      if (res.posts!.isNotEmpty) {
        posts.addAll(res.posts ?? []);
        likedPost.addAll(res.likedPost ?? []);
        currentPage++;
      } else {
        currentPage = 0;
      }
    } else {
      Fluttertoast.showToast(msg: "Error!");
    }

    isLoading = false;
    notifyListeners();
  }

  Future changePostsLastMonth() async {
    DataPost? res = await _postService.getPostLastMonth(
      page: currentPage,
    );

    if (res != null && res.posts != null) {
      postsLastMonth = res.posts ?? [];
    } else {
      Fluttertoast.showToast(msg: "Error!");
    }

    notifyListeners();
  }

  Future<bool> likePost(int postId) async {
    var res = await _postService.likePost(postId: postId);
    int indexPost =
        posts.indexOf(posts.firstWhere((element) => element.id == postId));
    int indexLikedPost = likedPost.indexOf(
      likedPost.firstWhere((element) => element == postId, orElse: () => -1),
    );
    if (res == null) {
      Fluttertoast.showToast(msg: 'Error!');
      return false;
    } else if (res == true) {
      posts[indexPost].likeCount = (posts[indexPost].likeCount ?? 0) + 1;
      if (indexLikedPost == -1) {
        likedPost.add(postId);
      }
      notifyListeners();
      return true;
    } else {
      posts[indexPost].likeCount = (posts[indexPost].likeCount ?? 0) - 1;
      if (indexLikedPost != -1) {
        likedPost.removeAt(indexLikedPost);
      }
      notifyListeners();
      return false;
    }
  }

  Future<bool> changeAvatar(PickedFile image) async {
    FormData formData = FormData.fromMap({
      "image": await MultipartFile.fromFile(
        image.path,
      )
    });

    var res = await _userService.changeAvatar(data: formData);

    if (res != null) {
      await _authService.getMe();

      notifyListeners();

      return true;
    }

    return true;
  }

  Future deletePost({required int postId}) async {
    var res = await _postService.deletePost(postId: postId);

    if (res) {
      Fluttertoast.showToast(msg: "Đã xóa bài viết!");
    } else {
      Fluttertoast.showToast(msg: "Đã có lỗi sảy ra!");
    }
  }

  Future updatePost({required int postId, required String captions}) async {
    var res = await _postService.updatePost(postId: postId, captions: captions);

    if (res) {
      Fluttertoast.showToast(msg: "Thành công!");
    } else {
      Fluttertoast.showToast(msg: "Đã có lỗi sảy ra!");
    }
  }

  resetList() {
    posts.clear();
    likedPost.clear();
    isLoading = false;
    currentPage = 1;
    notifyListeners();
  }
}
