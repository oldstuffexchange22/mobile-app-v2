import 'package:flutter/cupertino.dart';
import 'package:old_stuff_exchange/config/constrant/post_status.dart';
import 'package:old_stuff_exchange/config/toast/toast.dart';
import 'package:old_stuff_exchange/model/entity/post.dart';
import 'package:old_stuff_exchange/repository/implement/post_repository_implement.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:old_stuff_exchange/widgets/overlay/custom_overlay.dart';

class PostSaleProvider with ChangeNotifier {
  List<Post> _inactivePosts = [];
  List<Post> _activePosts = [];
  List<Post> _waitingPosts = [];
  List<Post> _deliveryPosts = [];
  List<Post> _deliveredPosts = [];
  List<Post> _accomplishedPosts = [];
  List<Post> _failurePosts = [];

  List<Post> get inactivePosts => _inactivePosts;
  List<Post> get activePosts => _activePosts;
  List<Post> get waitingPosts => _waitingPosts;
  List<Post> get deliveryPosts => _deliveryPosts;
  List<Post> get deliveredPosts => _deliveredPosts;
  List<Post> get accomplishedPosts => _accomplishedPosts;
  List<Post> get failurePosts => _failurePosts;

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

  Future<void> getPostInactive() async {
    try {
      _inactivePosts = await PostRepImp().getPostStatus(PostStatus.INACTIVE);
      notifyListeners();
    } catch (e) {
      showToastFail('Error provider post status $e');
    }
  }

  Future<void> getPostWaiting() async {
    try {
      _waitingPosts = await PostRepImp().getPostStatus(PostStatus.WAITING);
      notifyListeners();
    } catch (e) {
      showToastFail('Error provider post status $e');
    }
  }

  Future<void> getPostActive() async {
    try {
      _activePosts = await PostRepImp().getPostStatus(PostStatus.ACTIVE);
      notifyListeners();
    } catch (e) {
      showToastFail('Error provider post status $e');
    }
  }

  Future<void> getPostDelivery() async {
    try {
      _deliveryPosts = await PostRepImp().getPostStatus(PostStatus.DELIVERY);
      notifyListeners();
    } catch (e) {
      showToastFail('Error provider post status $e');
    }
  }

  Future<void> getPostDelivered() async {
    try {
      _deliveredPosts = await PostRepImp().getPostStatus(PostStatus.DELIVERED);
      notifyListeners();
    } catch (e) {
      showToastFail('Error provider post status $e');
    }
  }

  Future<void> getPostAccomplished() async {
    try {
      _accomplishedPosts = await PostRepImp().getPostStatus(PostStatus.ACCOMPLISHED);
      notifyListeners();
    } catch (e) {
      showToastFail('Error provider post status $e');
    }
  }

  Future<void> getPostFailure() async {
    try {
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
        await getPostDelivery();
        await getPostDelivered();
        showToastSuccess('Giao hàng thành công');
        context.loaderOverlay.hide();
      }
      context.loaderOverlay.hide();
    } catch (e) {
      showToastFail('delivered post fail $e');
    }
  }

  Future<void> inactivePost(BuildContext context, String postId) async {
    try {
      context.loaderOverlay
          .show(widget: const CustomOverlay(content: 'Đang xử lí'));
      Post? post = await PostRepImp().inactive(postId);
      if (post == null) {
        showToastFail('Gỡ bài đăng thất bại');
      } else {
        await getPostWaiting();
        await getPostInactive();
        await getPostActive();
        notifyListeners();
        showToastSuccess('Gỡ bài đăng thành công');
        context.loaderOverlay.hide();
      }
      context.loaderOverlay.hide();
    } catch (e) {
      showToastFail('delivered post fail $e');
    }
  }
}
