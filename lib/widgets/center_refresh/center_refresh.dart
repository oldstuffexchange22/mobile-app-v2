import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CenterRefresh extends StatelessWidget {
  const CenterRefresh({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return ListView.builder(
      itemCount: 1,
      itemBuilder: ((context, i) {
        return SizedBox(
          height: screenSize.height * 0.7,
          width: screenSize.width,
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        );
      }),
    );
  }
}

class CenterNotifyEmpty extends StatelessWidget {
  const CenterNotifyEmpty({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return ListView.builder(
      itemCount: 1,
      itemBuilder: ((context, i) {
        return SizedBox(
          height: screenSize.height * 0.7,
          width: screenSize.width,
          child: const Center(
            child: Text('Không tìm thấy bài viết'),
          ),
        );
      }),
    );
  }
}
