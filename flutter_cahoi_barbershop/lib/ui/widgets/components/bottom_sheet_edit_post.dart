import 'package:flutter/material.dart';
import 'package:flutter_maihomie_app/core/models/post2.dart';
import 'package:flutter_maihomie_app/core/models/user.dart';
import 'package:flutter_maihomie_app/core/services/auth_service.dart';
import 'package:flutter_maihomie_app/core/state_models/story_model.dart';
import 'package:flutter_maihomie_app/service_locator.dart';
import 'package:flutter_maihomie_app/ui/utils/constants.dart';
import 'package:flutter_maihomie_app/ui/utils/helper.dart';
import 'package:flutter_maihomie_app/ui/utils/style.dart';
import 'package:flutter_maihomie_app/ui/views/_base.dart';

class BottomSheetEditPost {
  static show(BuildContext context, Post2 post) async {
    MUser user = locator<AuthenticationService>().user;
    TextEditingController captionController = TextEditingController();

    await showModalBottomSheet(
      context: context,
      builder: (_) => BaseView<StoryModel>(
        onModelReady: (model) {
          captionController.text = post.captions ?? "";
        },
        builder: (context, model, child) => Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(
                height: 65,
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: borderRadiusCircle,
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: Image.network(
                          user.avatar != null
                              ? "$localHost${user.avatar}"
                              : avatarDefault,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      '${user.name}',
                      style: const TextStyle(
                        fontFamily: fontBold,
                        fontSize: 16,
                      ),
                    )
                  ],
                ),
              ),
              TextField(
                maxLines: 3,
                maxLength: 250,
                controller: captionController,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
                decoration: InputDecoration(
                  hintText: appLang(context)!.hint_status,
                  hintStyle: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.withOpacity(0.5),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  cacheExtent: 5000,
                  itemCount: post.task?.image!.length,
                  itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Material(
                      elevation: 8,
                      borderRadius: borderRadius12,
                      child: ClipRRect(
                        borderRadius: borderRadius12,
                        child: Image.network(
                          "$localHost/${post.task?.image![index].link}",
                          errorBuilder: (context, _, __) => Container(),
                        ),
                      ),
                    ),
                  ),
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      await model.updatePost(
                        postId: post.id ?? 0,
                        captions: captionController.text,
                      );

                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.edit),
                    label: Text(
                      appLang(context)!.complete,
                      style: const TextStyle(
                        fontFamily: fontBold,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
