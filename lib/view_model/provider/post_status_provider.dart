import 'package:flutter/cupertino.dart';
import 'package:old_stuff_exchange/config/constrant/post_status.dart';
import 'package:old_stuff_exchange/config/toast/toast.dart';
import 'package:old_stuff_exchange/model/entity/post.dart';
import 'package:old_stuff_exchange/repository/implement/post_repository_implement.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:old_stuff_exchange/widgets/overlay/custom_overlay.dart';

class PostStatusProvider with ChangeNotifier {
  List<Post> _inactivePosts = [];
  List<Post> _activePosts = [];
  List<Post> _waitingPosts = [];
  List<Post> _deliveryPosts = [];
  List<Post> _deliveredPosts = [];
  List<Post> _accomplishedPosts = [];
  List<Post> _failurePosts = [];
  get inactivePosts => _inactivePosts;
  get activePosts => _activePosts;
  get waitingPosts => _waitingPosts;
  get deliveryPosts => _deliveryPosts;
  get deliveredPosts => _deliveredPosts;
  get accomplishedPosts => _accomplishedPosts;
  get failurePosts => _failurePosts;

  Future<void> getAllPostStatus() async {
    try {
      _inactivePosts = await PostRepImp().getPostStatus(PostStatus.INACTIVE);
      _activePosts = await PostRepImp().getPostStatus(PostStatus.ACTIVE);
      _waitingPosts = await PostRepImp().getPostStatus(PostStatus.WAITING);
      _deliveryPosts = await PostRepImp().getPostStatus(PostStatus.DELIVERY);
      _deliveredPosts = await PostRepImp().getPostStatus(PostStatus.DELIVERED);
      _accomplishedPosts =
          await PostRepImp().getPostStatus(PostStatus.ACCOMPLISHED);
      _failurePosts = await PostRepImp().getPostStatus(PostStatus.FAILURE);
      notifyListeners();
    } catch (e) {
      showToastFail('Error provider post status $e');
    }
  }

  Future<void> deliveredPost(BuildContext context, String postId) async {
    try {
      context.loaderOverlay
          .show(widget: const CustomOverlay(content: 'Đang xử lí'));
      Post? post = await PostRepImp().delivered(postId);
      if (post == null) {
        showToastFail('Giao hàng thất bại');
      } else {
        await getAllPostStatus();
        showToastSuccess('Giao hàng thành công');
        context.loaderOverlay.hide();
      }
      context.loaderOverlay.hide();
    } catch (e) {
      showToastFail('delivered post fail $e');
    }
  }
}
