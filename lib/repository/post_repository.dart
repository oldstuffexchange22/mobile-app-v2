import 'package:old_stuff_exchange/model/entity/post.dart';
import 'package:old_stuff_exchange/model/request/post_create.dart';

abstract class PostRepository {
  Future<List<Post>?> getList(String status, int pageIndex, int pageSize,
      String? filterWith, String? filterValue, String? categoryId);

  Future<Post?> create(CreatePost post);
}
