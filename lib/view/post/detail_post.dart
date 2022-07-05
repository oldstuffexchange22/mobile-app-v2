import 'package:flutter/cupertino.dart';
import 'package:old_stuff_exchange/model/entity/post.dart';

class PostDetail extends StatefulWidget {
  const PostDetail({Key? key, required this.post}) : super(key: key);
  final Post post;

  @override
  State<PostDetail> createState() => _PostDetailState(currentPost: post);
}

class _PostDetailState extends State<PostDetail> {
  Post currentPost;

  _PostDetailState({required this.currentPost});
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
