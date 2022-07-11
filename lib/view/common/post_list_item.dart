import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:old_stuff_exchange/config/themes/fonts.dart';
import 'package:old_stuff_exchange/config/toast/toast.dart';
import 'package:old_stuff_exchange/model/entity/post.dart';
import 'package:old_stuff_exchange/view/post/detail_post.dart';

class PostListItem extends StatelessWidget {
  const PostListItem({Key? key, required this.post}) : super(key: key);

  final Post post;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.post_add_outlined),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 16,
          ),
          Text(
            post.title,
            style: PrimaryFont.extraLight(16),
          ),
          const SizedBox(
            height: 6,
          ),
          Text(
            'Giá : ${post.price}.000',
            style: PrimaryFont.bold(18).copyWith(color: Colors.red),
          )
        ],
      ),
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => PostDetail(post: post)));
      },
    );
  }
}
