import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nova/constants/colors.dart';
import 'package:nova/constants/strings.dart';
import 'package:nova/constants/widgets.dart';

// No Internet connectivity screen
class NoInternetScreen extends StatelessWidget {
  const NoInternetScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryBg,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: EdgeInsets.only(bottom: 0.h,),
                child: Image.asset(
                  noInternetImg,
                  width: 200,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 40.h),
              child: SizedBox(
                width: 300.w,
                child: customText(
                  text: noInternetText,
                  size: 24,
                  color: primaryTextColor,
                  alignment: TextAlign.center,
                  textHeight: 1.2,
                ),
              ),
            ),
            SizedBox(height: 80.h,)
          ],
        ),
      ),
    );
  }
}
