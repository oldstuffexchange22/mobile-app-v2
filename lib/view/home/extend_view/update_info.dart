import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:old_stuff_exchange/config/constrant/asset_path.dart';
import 'package:old_stuff_exchange/config/themes/appColors.dart';
import 'package:old_stuff_exchange/config/themes/fonts.dart';
import 'package:old_stuff_exchange/config/toast/toast.dart';
import 'package:old_stuff_exchange/model/entity/apartment.dart';
import 'package:old_stuff_exchange/model/entity/user.dart';
import 'package:old_stuff_exchange/utils/utils.dart';
import 'package:old_stuff_exchange/view_model/provider/user_provider.dart';
import 'package:old_stuff_exchange/widgets/overlay/custom_overlay.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:loader_overlay/loader_overlay.dart';

class UpdateInfoPage extends StatefulWidget {
  const UpdateInfoPage({Key? key}) : super(key: key);

  @override
  State<UpdateInfoPage> createState() => _UpdateInfoPageState();
}

class _UpdateInfoPageState extends State<UpdateInfoPage> {
  final _storage = FirebaseStorage.instance;
  final _picker = ImagePicker();
  late TextEditingController _nameController;
  bool _isShowBtnNameSave = false;
  bool _isShowNameState = false;
  late TextEditingController _phoneController;
  bool _isShowBtnPhoneSave = false;
  bool _isShowPhoneState = false;
  late FocusNode _focusPhone;

  late User? _originUser;

  List<DropdownMenuItem<String>> dropdownItemGender = [
    DropdownMenuItem(
      value: 'MALE',
      child: Row(
        children: [
          SizedBox(
            height: 20,
            width: 30,
            child: Image.asset(AssetPath.boy),
          ),
          const SizedBox(
            width: 12,
          ),
          const Text('Nam'),
        ],
      ),
    ),
    DropdownMenuItem(
      value: 'FEMALE',
      child: Row(
        children: [
          SizedBox(
            height: 20,
            width: 30,
            child: Image.asset(AssetPath.girl),
          ),
          const SizedBox(
            width: 12,
          ),
          const Text('Nữ'),
        ],
      ),
    ),
    DropdownMenuItem(
      value: 'OTHER',
      child: Row(
        children: [
          SizedBox(
            height: 20,
            width: 30,
            child: Image.asset(AssetPath.avatar),
          ),
          const SizedBox(
            width: 12,
          ),
          const Text('Khác'),
        ],
      ),
    )
  ];
  late String _selectedGender;

  @override
  void initState() {
    _nameController = TextEditingController();
    _phoneController = TextEditingController();
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    _originUser = userProvider.currentUser;
    _nameController.text = _originUser?.fullName ?? '';
    if (_originUser?.phone.isEmpty ?? false) {
      _phoneController.text = 'Thêm số điện thoại';
    } else {
      _phoneController.text = _originUser?.phone ?? '';
    }
    _selectedGender = (_originUser?.gender ?? '').isEmpty
        ? 'OTHER'
        : _originUser?.gender ?? '';
    _focusPhone = FocusNode();
    _focusPhone.addListener(_onFocusPhone);
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _focusPhone.removeListener(_onFocusPhone);
    _focusPhone.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    User? currentUser = userProvider.currentUser;
    Apartment? currentApartment = userProvider.currentApartment;
    Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Cập nhật thông tin'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Flexible(
                  flex: 1,
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundImage: CachedNetworkImageProvider(
                          Utils.getString(currentUser?.imagesUrl).isEmpty
                              ? 'https://thuvienplus.com/themes/cynoebook/public/images/default-user-image.png'
                              : Utils.getString(currentUser?.imagesUrl),
                        ),
                      ),
                      Positioned(
                          right: -16,
                          bottom: -2,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  shape: const CircleBorder(),
                                  primary:
                                      const Color.fromARGB(255, 85, 88, 87),
                                  side: const BorderSide(
                                      width: 2, color: Colors.white)),
                              onPressed: () async {
                                await uploadImage(context, userProvider);
                              },
                              child: const Icon(
                                Icons.camera_alt_rounded,
                                size: 16,
                              )))
                    ],
                  ),
                ),
                const SizedBox(
                  width: 12,
                ),
                Flexible(
                  flex: 4,
                  child: Container(
                    height: screenSize.height * 0.11,
                    width: screenSize.width * 0.74,
                    decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(4)),
                        border: Border.all(
                            width: 2, color: Colors.black.withOpacity(0.16))),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 6),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Họ và tên',
                            style: PrimaryFont.regular(14)
                                .copyWith(color: Colors.black.withOpacity(0.6)),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(flex: 3, child: _inputName()),
                              Flexible(
                                  flex: 2,
                                  child: SizedBox(
                                    height: 32,
                                    child: Visibility(
                                      visible: _isShowBtnNameSave,
                                      child: ElevatedButton(
                                          style: ButtonStyle(
                                              padding: MaterialStateProperty
                                                  .all<EdgeInsetsGeometry>(
                                                      EdgeInsets.zero),
                                              backgroundColor:
                                                  MaterialStateProperty.all<
                                                      Color>(Colors.green)),
                                          onPressed: () async {
                                            await userProvider.updateUser(
                                                context,
                                                'NAME',
                                                _nameController.text);
                                            setState(() {
                                              _originUser?.fullName =
                                                  _nameController.text;
                                              _isShowBtnNameSave = false;
                                              _isShowNameState = false;
                                            });
                                          },
                                          child: const Text('Lưu')),
                                    ),
                                  ))
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 30, top: 20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Số điện thoại',
                          style: PrimaryFont.regular(14)
                              .copyWith(color: Colors.black.withOpacity(0.6)),
                        ),
                        SizedBox(
                          width: screenSize.width * 0.6,
                          child: _inputPhone(),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 40,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 8, right: 20),
                        child: Visibility(
                          visible: _isShowBtnPhoneSave,
                          child: ElevatedButton(
                              style: ButtonStyle(
                                  padding: MaterialStateProperty.all<
                                      EdgeInsetsGeometry>(EdgeInsets.zero),
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.green)),
                              onPressed: () async {
                                await userProvider.updateUser(
                                    context, 'PHONE', _phoneController.text);
                                setState(() {
                                  _originUser?.phone = _phoneController.text;
                                  _isShowBtnPhoneSave = false;
                                  _isShowPhoneState = false;
                                });
                              },
                              child: const Text('Lưu')),
                        ),
                      ),
                    )
                  ],
                ),
                Divider(
                  endIndent: 0,
                  thickness: 2,
                  color: Colors.black.withOpacity(0.08),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Giới tính',
                      style: PrimaryFont.regular(14)
                          .copyWith(color: Colors.black.withOpacity(0.6)),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      children: [
                        Flexible(
                            flex: 30,
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.04),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(24))),
                              child: DropdownButtonHideUnderline(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 6),
                                  child: DropdownButton(
                                    style: PrimaryFont.extraLight(16)
                                        .copyWith(color: Colors.black),
                                    icon: const Icon(
                                        Icons.arrow_downward_outlined),
                                    menuMaxHeight: screenSize.height * 0.4,
                                    iconSize: 24,
                                    value: _selectedGender,
                                    isExpanded: true,
                                    underline: const SizedBox(),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(12)),
                                    items: dropdownItemGender.toList(),
                                    onChanged: (selectedValue) async {
                                      if (selectedValue.toString() !=
                                          _originUser?.gender) {
                                        await userProvider.updateUser(context,
                                            'GENDER', selectedValue.toString());
                                        _originUser?.gender =
                                            selectedValue.toString();
                                      }
                                      setState(() {
                                        _selectedGender =
                                            selectedValue.toString();
                                      });
                                    },
                                  ),
                                ),
                              ),
                            )),
                        const Flexible(
                            child: SizedBox(
                          width: 40,
                        )),
                      ],
                    ),
                  ],
                ),
                Divider(
                  endIndent: 0,
                  thickness: 2,
                  color: Colors.black.withOpacity(0.08),
                  height: 30,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Địa chỉ email',
                      style: PrimaryFont.regular(14)
                          .copyWith(color: Colors.black.withOpacity(0.6)),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                            flex: 2,
                            child: Text(currentUser?.email ?? '',
                                style: PrimaryFont.regular(16))),
                        Flexible(
                            flex: 1,
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(right: 20, bottom: 6),
                              child: ElevatedButton(
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Colors.yellow)),
                                  onPressed: null,
                                  child: Text(
                                    'Đã kết nối',
                                    style: PrimaryFont.regular(14)
                                        .copyWith(color: Colors.black),
                                  )),
                            ))
                      ],
                    ),
                  ],
                ),
                Divider(
                  endIndent: 0,
                  thickness: 2,
                  color: Colors.black.withOpacity(0.08),
                  height: 30,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Tên tòa nhà',
                      style: PrimaryFont.regular(14)
                          .copyWith(color: Colors.black.withOpacity(0.6)),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(currentUser?.building?.name.replaceAll('.', '') ?? '',
                        style: PrimaryFont.regular(16))
                  ],
                ),
                Divider(
                  endIndent: 0,
                  thickness: 2,
                  color: Colors.black.withOpacity(0.08),
                  height: 30,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Tên chung cư',
                      style: PrimaryFont.regular(14)
                          .copyWith(color: Colors.black.withOpacity(0.6)),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(currentApartment?.name.replaceAll('.', '') ?? '',
                        style: PrimaryFont.regular(16))
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  TextFormField _inputName() {
    return TextFormField(
      controller: _nameController,
      decoration: InputDecoration(
          border: InputBorder.none,
          errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25.0),
              borderSide: const BorderSide(
                color: Colors.red,
                width: 2.0,
              )),
          errorStyle:
              PrimaryFont.extraLight(10).copyWith(color: Colors.red, height: 1),
          labelStyle: MaterialStateTextStyle.resolveWith((states) {
            return PrimaryFont.regular(16).copyWith(color: kColorText);
          })),
      onChanged: (String value) {
        _isShowBtnNameSave = _originUser?.fullName != value ? true : false;
        if (_isShowBtnNameSave != _isShowNameState) {
          setState(() {
            _isShowNameState = _isShowBtnNameSave;
          });
        }
      },
    );
  }

  TextFormField _inputPhone() {
    return TextFormField(
      controller: _phoneController,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
          hintStyle: PrimaryFont.regular(16).copyWith(color: Colors.black),
          border: InputBorder.none,
          errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25.0),
              borderSide: const BorderSide(
                color: Colors.red,
                width: 2.0,
              )),
          errorStyle:
              PrimaryFont.extraLight(10).copyWith(color: Colors.red, height: 1),
          labelStyle: MaterialStateTextStyle.resolveWith((states) {
            return PrimaryFont.regular(16).copyWith(color: kColorText);
          })),
      focusNode: _focusPhone,
      onChanged: (String value) {
        _isShowBtnPhoneSave =
            (_originUser?.phone != value && value.length > 5) ? true : false;
        if (_isShowBtnPhoneSave != _isShowPhoneState) {
          setState(() {
            _isShowPhoneState = _isShowBtnPhoneSave;
          });
        }
      },
    );
  }

  void _onFocusPhone() {
    if (_focusPhone.hasFocus) {
      if (_phoneController.text == 'Thêm số điện thoại') {
        setState(() {
          _phoneController.clear();
        });
      }
    } else {
      if (_phoneController.text == '') {
        setState(() {
          _phoneController.text = 'Thêm số điện thoại';
        });
      }
    }
  }

  uploadImage(BuildContext context, UserProvider userProvider) async {
    //Check Permissions
    await Permission.photos.request();

    var permissionStatus = await Permission.photos.status;

    if (permissionStatus.isGranted) {
      XFile? image = await _picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        //Upload to Firebase
        context.loaderOverlay.show(
            widget: const CustomOverlay(
          content: 'Đang cập nhật ...',
        ));
        var fileName = image.path.substring(image.path.lastIndexOf('/'));
        var fileImage = File(image.path);
        var snapshot = await _storage
            .ref()
            .child('users')
            .child('avatar')
            .child(fileName)
            .putFile(fileImage);
        String urlDownload = await snapshot.ref.getDownloadURL();
        userProvider.updateUser(context, 'IMAGE', urlDownload);
      } else {
        showToastFail('No Path Received');
      }
    } else {
      showToastFail('Grant Permissions and try again');
    }
  }
}
