import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:old_stuff_exchange/config/constrant/post_status.dart';
import 'package:old_stuff_exchange/config/themes/fonts.dart';
import 'package:old_stuff_exchange/model/entity/post.dart';
import 'package:old_stuff_exchange/repository/implement/post_repository_implement.dart';
import 'package:old_stuff_exchange/view/common/post_list_item.dart';

class PostListView extends StatefulWidget {
  const PostListView({Key? key}) : super(key: key);

  @override
  State<PostListView> createState() => _PostListViewState();
}

class _PostListViewState extends State<PostListView> {
  static const _pageSize = 10;
  // final TextEditingController searchController = TextEditingController();
  final PagingController<int, Post> _pagingController =
      PagingController(firstPageKey: 0);
  String _searchTerm = '';
  Timer _timer = Timer(const Duration(milliseconds: 0), () {});
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    searchController.text = '';
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });

    _pagingController.addStatusListener((status) {
      if (status == PagingStatus.subsequentPageError) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text('Something when wrong while fetching a new page'),
          action: SnackBarAction(
            label: 'Retry',
            onPressed: () => _pagingController.retryLastFailedRequest(),
          ),
        ));
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: _titleSearch(screenSize),
      ),
      body: RefreshIndicator(
        onRefresh: () => Future.sync(() => _pagingController.refresh()),
        child: CustomScrollView(
          slivers: [
            PagedSliverList(
                pagingController: _pagingController,
                builderDelegate: PagedChildBuilderDelegate<Post>(
                    animateTransitions: true,
                    itemBuilder: (context, item, index) =>
                        PostListItem(post: item, index: index)))
          ],
        ),
      ),
    );
  }

  Container _titleSearch(Size screenSize) {
    return Container(
      width: screenSize.width * 0.9,
      height: 36,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: TextField(
          controller: searchController,
          onChanged: (value) {
            _timer.cancel();
            _timer = Timer(const Duration(milliseconds: 500), () {
              setState(() {
                _updateSearchTerm(value.trim());
              });
            });
          },
          style: PrimaryFont.extraLight(16).copyWith(color: Colors.black),
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.search),
            suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    _updateSearchTerm('');
                    searchController.clear();
                  });
                },
                icon: const Icon(Icons.clear)),
            hintText: 'Tìm kiếm ...',
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            contentPadding: const EdgeInsetsDirectional.only(start: 20),
          ),
        ),
      ),
    );
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      int pageIndex = (pageKey / _pageSize).ceil() + 1;
      final newItems = await PostRepImp().getList(
          PostStatus.ACTIVE, pageIndex, _pageSize, 'TITLE', _searchTerm, null);
      final isLastPage = newItems.length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + newItems.length;
        _pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  void _updateSearchTerm(String searchTerm) {
    _searchTerm = searchTerm;
    _pagingController.refresh();
  }

  @override
  void dispose() {
    _timer.cancel();
    _pagingController.dispose();
    super.dispose();
  }
}
