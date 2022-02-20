class Post{

  final String? post;

  Post({required this.post});

  Map<String?, dynamic> toMap() {
    return {
      'post': post};
  }}