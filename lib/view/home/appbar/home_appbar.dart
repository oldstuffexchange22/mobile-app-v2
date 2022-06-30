

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:old_stuff_exchange/config/themes/fonts.dart';

class HomeAppBarContainer extends StatelessWidget {
  const HomeAppBarContainer({
    Key? key,
    required this.screenSize,
    required this.searchController,
  }) : super(key: key);
  final Size screenSize;
  final TextEditingController searchController;

  @override
  Widget build(BuildContext context) {
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
          style: PrimaryFont.extraLight(16).copyWith(color: Colors.black),
          decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search),
              suffixIcon: IconButton(
                  onPressed: () {
                    searchController.clear();
                  },
                  icon: const Icon(Icons.clear)),
              hintText: 'Tìm kiếm ...',
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              contentPadding: const EdgeInsetsDirectional.only(start: 20)),
        ),
      ),
    );
  }
}