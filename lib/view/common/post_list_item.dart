import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:old_stuff_exchange/config/themes/fonts.dart';
import 'package:old_stuff_exchange/config/toast/toast.dart';
import 'package:old_stuff_exchange/model/entity/post.dart';
import 'package:old_stuff_exchange/view/post/detail_post.dart';

class PostListItem extends StatelessWidget {
  const PostListItem({Key? key, required this.post, required this.index})
      : super(key: key);

  final Post post;
  final int index;

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    Color titleColor =
        index % 2 == 0 ? Colors.white : Colors.black.withOpacity(0.04);
    return ListTile(
      tileColor: titleColor,
      leading: Container(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black.withOpacity(0.2), width: 2)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 2),
          child: SizedBox(
            width: screenSize.width * 0.16,
            height: screenSize.height * 0.14,
            child: FittedBox(
              fit: BoxFit.fill,
              child: post.imageUrl.isEmpty
                  ? const Icon(Icons.image_aspect_ratio_outlined)
                  : Image.network(post.imageUrl),
            ),
          ),
        ),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 8,
          ),
          Text(
            post.title,
            style: PrimaryFont.regular(16),
          ),
          const SizedBox(
            height: 6,
          ),
          Text(
            'Giá : ${post.price}00',
            style: PrimaryFont.bold(18).copyWith(color: Colors.red),
          ),
          const SizedBox(
            height: 4,
          ),
          Text(
            'Ngày tạo : ${post.createdAt.add(const Duration(hours: 7)).toString().substring(0, 16)}',
            style: PrimaryFont.extraLight(12),
          ),
          const SizedBox(
            height: 8,
          ),
        ],
      ),
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => PostDetail(post: post)));
      },
    );
  }
}
