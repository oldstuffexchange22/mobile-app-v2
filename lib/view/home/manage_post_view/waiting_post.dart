import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:old_stuff_exchange/config/themes/fonts.dart';
import 'package:old_stuff_exchange/model/entity/post.dart';
import 'package:old_stuff_exchange/view_model/provider/post_status_provider.dart';
import 'package:provider/provider.dart';

class WaitingPost extends StatefulWidget {
  const WaitingPost({Key? key}) : super(key: key);

  @override
  State<WaitingPost> createState() => _WaitingPostState();
}

class _WaitingPostState extends State<WaitingPost> {
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    PostStatusProvider postStatusProvider =
        Provider.of<PostStatusProvider>(context);
    List<Post> posts = postStatusProvider.waitingPosts;
    return Scaffold(
      body: SizedBox(
        height: screenSize.height,
        child: posts.isEmpty
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                itemBuilder: ((context, i) {
                  Post post = posts[i];
                  return ListTile(
                    leading: Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: SizedBox(
                        width: screenSize.width * 0.2,
                        height: screenSize.height * 16,
                        child: FittedBox(
                          fit: BoxFit.fill,
                          child: post.imageUrl.isEmpty
                              ? const Icon(Icons.image_aspect_ratio_outlined)
                              : Image.network(post.imageUrl),
                        ),
                      ),
                    ),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 16,
                        ),
                        Text(
                          post.title,
                          style: PrimaryFont.semiBold(16),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                        Text(
                          post.description,
                          style: PrimaryFont.extraLight(16),
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                        Text(
                          'Giá : ${post.price}.000',
                          style: PrimaryFont.regular(18)
                              .copyWith(color: Colors.red),
                        ),
                        const SizedBox(
                          height: 2,
                        ),
                        Text(
                            'Ngày tạo : ${post.lastUpdatedAt.toLocal().toString().substring(0, 16)}')
                      ],
                    ),
                  );
                }),
                itemCount: posts.length,
              ),
      ),
    );
  }
}
