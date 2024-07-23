// import 'package:country_pickers/countries.dart';
// import 'package:country_pickers/country.dart';
// import 'package:country_pickers/country_pickers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ws_flutter_app/ws_services/ws_app_service.dart';
import 'package:ws_flutter_app/ws_services/ws_app_service.dart';
import 'package:ws_flutter_app/ws_utils/ws_dialog_util.dart';
import 'package:ws_flutter_app/ws_utils/ws_log/ws_logger.dart';

import 'ws_mine_base_view.dart';

/// 编辑个人信息
class WSMineEditInfoView extends StatefulWidget {
  const WSMineEditInfoView({super.key});

  @override
  State<WSMineEditInfoView> createState() => _WSMineEditInfoViewState();
}

class _WSMineEditInfoViewState extends WSMineBaseState<WSMineEditInfoView> {
  final TextEditingController nickNameController = TextEditingController();
  DateTime birthday = DateTime.now();
  late String country;
  int nickNameMaxLength = 30;

  @override
  void initState() {
    // nickNameController.text = WSAppService().instance.userInfo.value.nickname ?? '';
    // country = WSAppService.instance.userInfo.value.country ?? '';
    // birthday = DateTime.parse(WSAppService.instance.userInfo.value.birthday ?? DateTime.now().toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: Column(
          children: [
            SizedBox(height: context.mediaQueryPadding.top.h),
            buildTopBar(),
            buildUserPicWidget(),
            SizedBox(height: 32.h),
            buildNicknameWidget(),
            SizedBox(height: 20.h),
            buildDateWidget(),
            SizedBox(height: 20.h),
            buildCountryWidget(),
            const Spacer(),
            buildBottomButton(),
            SizedBox(height: 40.h),
          ],
        ),
      ),
    );
  }

  buildNicknameWidget() {
    WSLogger.debug('======buildNicknameWidget==>>>>${nickNameController.text}');
    return Container(
        height: 44.h,
        margin: EdgeInsets.only(left: 32.w, right: 32.w),
        padding: EdgeInsets.only(right: 20.w),
        decoration: BoxDecoration(
          color: const Color(0xFFF7F8FA),
          borderRadius: BorderRadius.circular(8.w),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(left: 20.w),
              child: const Text(
                'Nick Name',
                style: TextStyle(
                  color: Color(0x4D000000),
                  fontSize: 16,
                ),
              ),
            ),
            Expanded(
              child: Container(
                alignment: Alignment.centerLeft,
                child: TextField(
                  controller: nickNameController,
                  maxLines: 1,
                  maxLength: nickNameMaxLength,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: const Color(0xFF404040),
                    fontSize: 16.sp,
                  ),
                  onChanged: (value) {
                    refreshSubmitStatus(name: value);
                  },
                  decoration: InputDecoration(
                    counterText: '',
                    hintStyle: TextStyle(
                      fontSize: 16.sp,
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
          ],
        ));
  }

  Widget buildBottomButton() {
    return Obx(
      () {
        // WSLogger.debug(
        //     '=buildBottomButton==>>>>>>${Get.find<WSMineController>().hashCode}==${Get.find<WSMineController>().editInfoCanSubmit.value}');
        return GestureDetector(
          onTap: () async {
            // if (Get.find<WSMineController>().editInfoCanSubmit.value == true) {
            //   Get.find<WSMineController>().updateUserInfo(nickNameController.text, birthday, country);
            // }
          },
          behavior: HitTestBehavior.opaque,
          child: Container(
            height: 52.h,
            margin: const EdgeInsets.only(top: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 300.w,
                  height: 40.h,
                  decoration: BoxDecoration(
                    // color: (Get.find<WSMineController>().editInfoCanSubmit.value == true)
                    //     ? Color(0xFFE6FF4E)
                    //     : Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      'Submit',
                      style: TextStyle(
                        // color: Color(
                        //     (Get.find<WSMineController>().editInfoCanSubmit.value == true) ? 0xFF202020 : 0xFFA0A0A0),
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void refreshSubmitStatus({String? name}) {
    name ??= nickNameController.text;
    // if (name == WSAppService.instance.userInfo.value.nickname &&
    //     birthday == DateTime.parse(WSAppService.instance.userInfo.value.birthday!) &&
    //     country == WSAppService.instance.userInfo.value.country) {
    //   Get.find<WSMineController>().editInfoCanSubmit.value = false;
    // } else {
    //   Get.find<WSMineController>().editInfoCanSubmit.value = true;
    // }
    // Get.find<WSMineController>().editInfoCanSubmit.refresh();
  }

  buildDateWidget() {
    return StatefulBuilder(
      builder: (context, setState) => GestureDetector(
        onTap: () {
          DateTime maximumDate = DateTime.now().subtract(const Duration(days: 365 * 18));
          WSDialogUtil.showDatePicker(
            initialDateTime: birthday,
            maximumDate: maximumDate,
            onDateTimeChanged: (value) {
              WSLogger.debug('update birthday:  $value');
              birthday = value;
              setState(() {});
              refreshSubmitStatus();
            },
          );
        },
        child: Container(
            height: 44.h,
            padding: EdgeInsets.only(right: 20.w),
            margin: EdgeInsets.only(left: 32.w, right: 32.w),
            decoration: BoxDecoration(
              color: const Color(0xFFF7F8FA),
              borderRadius: BorderRadius.circular(8.w),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.only(left: 20.w),
                  child: const Text(
                    'Birthday',
                    style: TextStyle(
                      color: Color(0x4D000000),
                      fontSize: 16,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.centerRight,
                    child: Text(
                      '${birthday.year}-${birthday.month}-${birthday.day}',
                      style: TextStyle(
                        color: const Color(0xFF404040),
                        fontSize: 16.sp,
                      ),
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }

  buildCountryWidget() {
    return StatefulBuilder(
      builder: (context, setState) => GestureDetector(
        onTap: () {
          // showCupertinoModalPopup(
          //     context: context,
          //     builder: (BuildContext context) {
          //       Country? selectCountry;
          //       for (var c in countryList) {
          //         if (c.iso3Code == country) {
          //           selectCountry = c;
          //           break;
          //         }
          //       }
          //       return CountryPickerCupertino(
          //         diameterRatio: 10,
          //         offAxisFraction: 0,
          //         initialCountry: selectCountry,
          //         pickerSheetHeight: 300.0,
          //         onValuePicked: (Country c) {
          //           country = c.iso3Code;
          //           setState(() {});
          //           refreshSubmitStatus();
          //         },
          //         itemBuilder: (country) {
          //           return Row(
          //             children: <Widget>[
          //               const SizedBox(width: 8.0),
          //               CountryPickerUtils.getDefaultFlagImage(country),
          //               const SizedBox(width: 8.0),
          //               Expanded(child: Text(country.name)),
          //             ],
          //           );
          //         },
          //         itemFilter: (c) => !['CN'].contains(c.isoCode),
          //       );
          //     });
        },
        child: Container(
            height: 44.h,
            margin: EdgeInsets.only(left: 32.w, right: 32.w),
            padding: EdgeInsets.only(right: 20.w),
            decoration: BoxDecoration(
              color: const Color(0xFFF7F8FA),
              borderRadius: BorderRadius.circular(8.w),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.only(left: 20.w),
                  child: const Text(
                    'Country',
                    style: TextStyle(
                      color: Color(0x4D000000),
                      fontSize: 16,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.centerRight,
                    child: Text(
                      country,
                      style: TextStyle(
                        color: const Color(0xFF404040),
                        fontSize: 16.sp,
                      ),
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
