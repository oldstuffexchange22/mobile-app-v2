import 'package:flutter/cupertino.dart';

class ManagePostView extends StatefulWidget {
  const ManagePostView({Key? key}) : super(key: key);

  @override
  State<ManagePostView> createState() => _ManagePostViewState();
}

class _ManagePostViewState extends State<ManagePostView> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Manage post view'),
    );
  }
}