import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

class DatabaseServices {
  Future addPost(String postContent) async {
    final post = ParseObject('Post')
      ..set('post', postContent);


    var response = await post.save();
    if (response.success) {
      return null;
    } else {
      return null;

  }
  }

}
