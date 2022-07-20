import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:old_stuff_exchange/config/constrant/post_status.dart';
import 'package:old_stuff_exchange/config/toast/toast.dart';
import 'package:old_stuff_exchange/model/entity/post.dart';
import 'package:old_stuff_exchange/repository/implement/post_repository_implement.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:old_stuff_exchange/widgets/overlay/custom_overlay.dart';

class PostBoughtProvider with ChangeNotifier {
  List<Post> _deliveryPosts = [];
  List<Post> _deliveredPosts = [];
  List<Post> _accomplishedPosts = [];
  List<Post> _failurePosts = [];

  get deliveryPosts => _deliveryPosts;
  get deliveredPosts => _deliveredPosts;
  get accomplishedPosts => _accomplishedPosts;
  get failurePosts => _failurePosts;

  Future<void> getAllPost() async {
    try {
      _deliveryPosts =
          await PostRepImp().getPostUserBoughtStatus(PostStatus.DELIVERY);
      _deliveredPosts =
          await PostRepImp().getPostUserBoughtStatus(PostStatus.DELIVERED);
      _accomplishedPosts =
          await PostRepImp().getPostUserBoughtStatus(PostStatus.ACCOMPLISHED);
      _failurePosts =
          await PostRepImp().getPostUserBoughtStatus(PostStatus.FAILURE);
      notifyListeners();
    } catch (e) {
      // showToastFail('Error provider post status $e');
    }
  }

  void notify() {
    notifyListeners();
  }

  Future<void> getDeliveryPost() async {
    try {
      _deliveryPosts =
          await PostRepImp().getPostUserBoughtStatus(PostStatus.DELIVERY);
      notifyListeners();
    } catch (e) {
      // showToastFail('Error provider post status $e');
    }
  }

  Future<void> getDeliveredPost() async {
    try {
      _deliveredPosts =
          await PostRepImp().getPostUserBoughtStatus(PostStatus.DELIVERED);
      notifyListeners();
    } catch (e) {
      // showToastFail('Error provider post status $e');
    }
  }

  Future<void> getAccomplishedPost() async {
    try {
      _accomplishedPosts =
          await PostRepImp().getPostUserBoughtStatus(PostStatus.ACCOMPLISHED);
      notifyListeners();
    } catch (e) {
      // showToastFail('Error provider post status $e');
    }
  }

  Future<void> getFailurePost() async {
    try {
      _failurePosts =
          await PostRepImp().getPostUserBoughtStatus(PostStatus.FAILURE);
      notifyListeners();
    } catch (e) {
      // showToastFail('Error provider post status $e');
    }
  }

  Future<void> makeAccomplishedPost(BuildContext context, String postId) async {
    try {
      context.loaderOverlay.show(
          widget: const CustomOverlay(
        content: 'Đang xử lí...',
      ));
      Post? post = await PostRepImp().accomplished(postId);
      if (post == null) {
        showToastFail('Đơn hàng thất bại');
      } else {
        await getDeliveredPost();
        await getAccomplishedPost();
        notifyListeners();
        showToastSuccess('Đơn hàng đã thành công');
      }
      context.loaderOverlay.hide();
    } catch (e) {
      // showToastFail('Error provider post status $e');
      context.loaderOverlay.hide();
    }
  }

  Future<void> makeFailurePost(BuildContext context, String postId) async {
    try {
      context.loaderOverlay.show(
          widget: const CustomOverlay(
        content: 'Đang xử lí...',
      ));
      Post? post = await PostRepImp().failure(postId);
      if (post == null) {
        showToastFail('Đơn hàng thất bại');
      } else {
        await getDeliveredPost();
        await getFailurePost();
        notifyListeners();
        showToastSuccess('Đơn hàng đã thành công');
      }
      context.loaderOverlay.hide();
    } catch (e) {
      // showToastFail('Error provider post status $e');
      context.loaderOverlay.hide();
    }
  }

  void clearDeliveryPost() {
    _deliveryPosts = [];
    notifyListeners();
  }

  void clearDeliveredPost() {
    _deliveredPosts = [];
    notifyListeners();
  }

  void clearAccomplishedPost() {
    _accomplishedPosts = [];
    notifyListeners();
  }

  void clearFailurePost() {
    _failurePosts = [];
    notifyListeners();
  }

  void clearAll() {
    _deliveryPosts = [];
    _deliveredPosts = [];
    _accomplishedPosts = [];
    _failurePosts = [];
    notifyListeners();
  }
}
