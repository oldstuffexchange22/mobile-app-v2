import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:old_stuff_exchange/config/themes/appColors.dart';
import 'package:old_stuff_exchange/config/themes/appStyle.dart';
import 'package:old_stuff_exchange/config/themes/fonts.dart';
import 'package:old_stuff_exchange/config/toast/toast.dart';
import 'package:old_stuff_exchange/model/entity/post.dart';
import 'package:old_stuff_exchange/model/request/product_create.dart';
import 'package:old_stuff_exchange/view/post/product_dialog.dart';
import 'package:old_stuff_exchange/view_model/provider/post_create_provider.dart';
import 'package:old_stuff_exchange/view_model/provider/user_provider.dart';
import 'package:old_stuff_exchange/widgets/input/input.dart';
import 'package:old_stuff_exchange/widgets/overlay/custom_overlay.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';

class CreatePost extends StatefulWidget {
  const CreatePost({Key? key}) : super(key: key);

  @override
  State<CreatePost> createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  @override
  void initState() {
    PostProvider postProvider =
        Provider.of<PostProvider>(context, listen: false);
    postProvider.getCategories();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  final _storage = FirebaseStorage.instance;
  final _picker = ImagePicker();
  dynamic _pickImageError;
  String? _retrieveDataError;
  List<XFile>? _imageFileList;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    PostProvider postProvider = Provider.of<PostProvider>(context);
    UserProvider userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Tạo bài đăng',
          style: PrimaryFont.semiBold(18).copyWith(color: Colors.white),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [kColorBackGroundStart, kColorBackGroundEnd])),
        ),
      ),
      body: ConstrainedBox(
        constraints: BoxConstraints(minHeight: screenSize.height),
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [kColorBackGroundStart, kColorBackGroundEnd])),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(
                    height: 10,
                  ),
                  const LabelBox(label: 'Tiêu đề :'),
                  InputApp(
                      isRequired: true,
                      width: screenSize.width * 0.8,
                      icon: const Icon(Icons.title_outlined),
                      controller: _titleController),
                  const LabelBox(label: 'Miêu tả :'),
                  const SizedBox(
                    height: 8,
                  ),
                  InputApp(
                      isRequired: true,
                      minLines: 2,
                      width: screenSize.width * 0.8,
                      icon: const Icon(Icons.description_outlined),
                      controller: _descriptionController),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    child: _imageFileList == null
                        ? const SizedBox(
                            height: 40,
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              color: Colors.transparent.withOpacity(0.2),
                              child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: _preview_imageFileList()),
                            ),
                          ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: ElevatedButton(
                      onPressed: () async {
                        await uploadImage(context);
                        setState(() {
                          context.loaderOverlay.hide();
                        });
                      },
                      style: AppStyle.btnUploadStyle(),
                      child: SizedBox(
                        width: screenSize.width * 0.3,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.upload_file_outlined),
                            SizedBox(
                              width: 10,
                            ),
                            Text('Tải ảnh')
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  postProvider.products.isEmpty
                      ? const SizedBox()
                      : SizedBox(
                          width: screenSize.width * 0.84,
                          child:
                              const LabelBox(label: 'Danh sách sản phẩm : ')),
                  ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(16)),
                    child: Container(
                      color: Colors.transparent.withOpacity(0.08),
                      height:
                          (70 * postProvider.products.length.toDouble()) > 200
                              ? 200
                              : 70 * postProvider.products.length.toDouble(),
                      child: ListView.builder(
                          itemCount: postProvider.products.length,
                          itemBuilder: ((context, index) {
                            CreateProduct product =
                                postProvider.products[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                              child: Row(
                                children: [
                                  Expanded(
                                      flex: 2,
                                      child: Text(
                                        product.name,
                                        overflow: TextOverflow.ellipsis,
                                      )),
                                  Expanded(
                                      flex: 2,
                                      child: Text(
                                        '${product.price},000',
                                        overflow: TextOverflow.ellipsis,
                                      )),
                                  Expanded(
                                      flex: 5,
                                      child: Text(
                                        product.categoryName.toString(),
                                        overflow: TextOverflow.ellipsis,
                                      )),
                                  Expanded(
                                      flex: 2,
                                      child: ElevatedButton(
                                          style: AppStyle.btnDeleteStyle(),
                                          onPressed: () {
                                            postProvider.deleteProduct(index);
                                          },
                                          child: const Text('Xóa')))
                                ],
                              ),
                            );
                          })),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(12)),
                    child: SizedBox(
                      width: screenSize.width * 0.8,
                      height: screenSize.height * 0.06,
                      child: ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              if (_imageFileList == null) {
                                showToastFail('Bạn chưa đính kèm ảnh');
                                return;
                              } else if (postProvider.products.isEmpty) {
                                showToastFail(
                                    'Bạn chưa thêm bất kì sản phẩm nào');
                                return;
                              }
                              String title = _titleController.text.trim();
                              String description =
                                  _descriptionController.text.trim();
                              await postProvider.createPost(
                                  context,
                                  title,
                                  description,
                                  _imageFileList,
                                  userProvider.currentUser?.id ?? '');
                              setState(() {
                                _imageFileList = null;
                                _descriptionController.text = '';
                                _titleController.text = '';
                                showToastSuccess('Tạo bài đăng thành công');
                              });
                            } else {
                              showToastFail('Bạn chưa nhập đúng yêu cầu');
                            }
                          },
                          child: Text(
                            'Tạo bài đăng',
                            style: PrimaryFont.extraLight(16)
                                .copyWith(color: kColorWhite),
                          )),
                    ),
                  ),
                  const SizedBox(
                    height: 80,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: _BtnCreateProduct(screenSize: screenSize),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  uploadImage(BuildContext context) async {
    //Check Permissions
    await Permission.photos.request();

    var permissionStatus = await Permission.photos.status;

    if (permissionStatus.isGranted) {
      //Select Image
      _imageFileList = await _picker.pickMultiImage();

      if (_imageFileList != null) {
        //Upload to Firebase
        context.loaderOverlay.show(
            widget: const CustomOverlay(
          content: 'Xử lí ảnh...',
        ));
      } else {
        showToastFail('No Path Received');
      }
    } else {
      showToastFail('Grant Permissions and try again');
    }
  }

  Text? _getRetrieveErrorWidget() {
    if (_retrieveDataError != null) {
      final Text result = Text(_retrieveDataError!);
      _retrieveDataError = null;
      return result;
    }
    return null;
  }

  Widget _preview_imageFileList() {
    final Text? retrieveError = _getRetrieveErrorWidget();
    if (retrieveError != null) {
      return retrieveError;
    }
    if (_imageFileList != null) {
      return Semantics(
        label: 'image_picker_example_picked__imageFileList',
        child: GridView.builder(
          itemBuilder: (BuildContext context, int index) {
            return Semantics(
                label: 'image_picker_example_picked_image',
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(
                    File(_imageFileList![index].path),
                    fit: BoxFit.fill,
                  ),
                ));
          },
          itemCount: _imageFileList!.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          shrinkWrap: true,
          physics: const ScrollPhysics(),
        ),
      );
    } else if (_pickImageError != null) {
      return Text(
        'Pick image error: $_pickImageError',
        textAlign: TextAlign.center,
      );
    } else {
      return const Text(
        'You have not yet picked an image.',
        textAlign: TextAlign.center,
      );
    }
  }

  Widget _handlePreview() {
    return _preview_imageFileList();
  }
}

class LabelBox extends StatelessWidget {
  const LabelBox({Key? key, required this.label}) : super(key: key);
  final String label;
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return SizedBox(
      width: screenSize.width * 0.7,
      child: Padding(
          padding: const EdgeInsets.only(left: 16, top: 16, bottom: 8),
          child: Text(
            label,
            style: PrimaryFont.regular(16).copyWith(color: Colors.black),
          )),
    );
  }
}

class _BtnCreateProduct extends StatelessWidget {
  const _BtnCreateProduct({
    Key? key,
    required this.screenSize,
  }) : super(key: key);

  final Size screenSize;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: screenSize.width * 0.2,
      height: screenSize.height * 0.2,
      child: FittedBox(
        child: FloatingActionButton(
          onPressed: () async {
            await showDialog(
                barrierDismissible: false,
                context: context,
                builder: (context) => AlertDialog(
                      contentPadding: EdgeInsets.zero,
                      content:
                          Builder(builder: (context) => const ProductDialog()),
                      shape: RoundedRectangleBorder(
                          borderRadius: (BorderRadius.circular(20))),
                    ));
          },
          backgroundColor: kColorButton,
          child: Column(
            children: [
              const SizedBox(
                height: 12,
              ),
              const Icon(
                Icons.post_add_outlined,
                color: Colors.white,
              ),
              Text('Thêm sản phẩm',
                  style: PrimaryFont.semiBold(4).copyWith(
                    color: Colors.white,
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
