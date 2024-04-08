import 'package:flutter/material.dart';
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
                padding:const EdgeInsets.only(bottom: 0,),
                child: Image.asset(
                  noInternetImg,
                  width: 200,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 40),
              child: SizedBox(
                width: 300,
                child: customText(
                  text: noInternetText,
                  size: 24,
                  color: primaryTextColor,
                  alignment: TextAlign.center,
                  textHeight: 1.2,
                ),
              ),
            ),
           const SizedBox(height: 80,)
          ],
        ),
      ),
    );
  }
}
