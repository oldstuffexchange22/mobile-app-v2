import 'dart:async';

import 'package:flutter/material.dart';
import 'package:old_stuff_exchange/config/themes/appColors.dart';
import 'package:old_stuff_exchange/config/themes/appStyle.dart';
import 'package:old_stuff_exchange/config/themes/fonts.dart';
import 'package:old_stuff_exchange/config/toast/toast.dart';
import 'package:old_stuff_exchange/model/entity/apartment.dart';
import 'package:old_stuff_exchange/model/entity/building.dart';
import 'package:old_stuff_exchange/model/entity/user.dart';
import 'package:old_stuff_exchange/repository/implement/apartment_repository_implement.dart';
import 'package:old_stuff_exchange/repository/implement/building_repository_implement.dart';
import 'package:old_stuff_exchange/view_model/provider/update_address_provider.dart';
import 'package:old_stuff_exchange/view_model/provider/user_provider.dart';
import 'package:old_stuff_exchange/widgets/overlay/custom_overlay.dart';
import 'package:provider/provider.dart';
import 'package:loader_overlay/loader_overlay.dart';

class UpdateAddressPage extends StatefulWidget {
  const UpdateAddressPage({Key? key}) : super(key: key);

  @override
  State<UpdateAddressPage> createState() => _UpdateAddressPageState();
}

class _UpdateAddressPageState extends State<UpdateAddressPage> {
  String _selectedApartment = '';
  String _selectedBuilding = '';
  List<Apartment> apartments = [];
  List<Building> buildings = [];
  late User currentUser;
  @override
  void initState() {
    super.initState();
    getApartments();
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    userProvider.getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    UserProvider userProvider = Provider.of<UserProvider>(context);
    UpdateAddressProvider updateAddressProvider =
        Provider.of<UpdateAddressProvider>(context);
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
                flex: 7,
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                            kColorBackGroundStart,
                            kColorBackGroundEnd
                          ])),
                    ),
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'NHẬP ĐỊA CHỈ CỦA BẠN',
                            style: PrimaryFont.semiBold(20)
                                .copyWith(color: kColorWhite),
                          ),
                          const SizedBox(
                            height: 60,
                          ),
                          SizedBox(
                            height: 40,
                            width: screenSize.width * 0.7,
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 12),
                                child: Text('Tên chung cư : ',
                                    style: PrimaryFont.extraLight(16)
                                        .copyWith(color: kColorWhite)),
                              ),
                            ),
                          ),
                          Container(
                            width: screenSize.width * 0.7,
                            decoration: BoxDecoration(
                                color: kColorWhite,
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(24))),
                            child: DropdownButtonHideUnderline(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: DropdownButton(
                                    style: PrimaryFont.extraLight(16)
                                        .copyWith(color: Colors.black),
                                    icon: const Icon(
                                        Icons.arrow_downward_outlined),
                                    iconSize: 24,
                                    value: _selectedApartment,
                                    isExpanded: true,
                                    underline: const SizedBox(),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(12)),
                                    items: apartments
                                        .map((e) => DropdownMenuItem(
                                              value: e.id,
                                              child: Text(
                                                  e.name.replaceAll('.', '')),
                                            ))
                                        .toList(),
                                    onChanged: (String? value) async {
                                      context.loaderOverlay.show(
                                          widget: const CustomOverlay(
                                        content:
                                            'Đang lấy dữ liệu của chung cư',
                                      ));
                                      _selectedApartment = value ?? '';
                                      await getBuildings();
                                      context.loaderOverlay.hide();
                                      setState(() {});
                                    }),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          SizedBox(
                            height: 40,
                            width: screenSize.width * 0.7,
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 12),
                                child: Text('Tòa nhà : ',
                                    style: PrimaryFont.extraLight(16)
                                        .copyWith(color: kColorWhite)),
                              ),
                            ),
                          ),
                          Container(
                            width: screenSize.width * 0.7,
                            decoration: BoxDecoration(
                                color: kColorWhite,
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(24))),
                            child: DropdownButtonHideUnderline(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: DropdownButton(
                                    style: PrimaryFont.extraLight(16)
                                        .copyWith(color: Colors.black),
                                    icon: const Icon(
                                        Icons.arrow_downward_outlined),
                                    iconSize: 24,
                                    value: _selectedBuilding,
                                    isExpanded: true,
                                    underline: const SizedBox(),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(24)),
                                    items: buildings
                                        .map((e) => DropdownMenuItem(
                                              value: e.id,
                                              child: Text(
                                                  e.name.replaceAll('.', '')),
                                            ))
                                        .toList(),
                                    onChanged: (String? value) {
                                      setState(() {
                                        _selectedBuilding = value ?? '';
                                      });
                                    }),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 100,
                          ),
                          SizedBox(
                              width: screenSize.width * 0.7,
                              height: screenSize.height * 0.05,
                              child: ElevatedButton(
                                  style: AppStyle.btnPrimaryStyle(),
                                  onPressed: () async {
                                    String userId =
                                        userProvider.currentUser?.id ?? '';
                                    if (userId.isEmpty ||
                                        _selectedBuilding.isEmpty) {
                                      showToastFail(
                                          'Có cái gì đó đang bị null');
                                    } else {
                                      await updateAddressProvider
                                          .updateUserAddress(context, userId,
                                              _selectedBuilding);
                                    }
                                  },
                                  child: const Text('Tạo địa chỉ')))
                        ],
                      ),
                    )
                  ],
                )),
          ],
        ));
  }

  Future<void> getApartments() async {
    context.loaderOverlay.show();
    var response = await ApartmentReqImp().getList();
    setState(() {
      _selectedApartment = response[0].id;
      apartments = response;
    });
    await getBuildings();
    context.loaderOverlay.hide();
  }

  Future<void> getBuildings() async {
    var response = await BuildingRepImp().getList(_selectedApartment);
    setState(() {
      _selectedBuilding = response[0].id;
      buildings = response;
    });
  }
}
