// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nova/constants/colors.dart';
import 'package:nova/constants/strings.dart';
import 'package:nova/constants/widgets.dart';
import 'package:nova/pages/banks_page.dart';
import 'package:nova/services/obp_service.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

// User Login page
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _pdController = TextEditingController();
  bool isWeb = kIsWeb;
  String? userToken;

  // On pressing Login button
  loginBtn() async {
    if (_emailController.text.isEmpty || _pdController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: customText(
            text: 'Input Credentials',
            size: 14.sp,
            fontWeight: FontWeight.bold,
            color: errorColor,
          ),
          backgroundColor: tertiaryColor,
        ),
      );
    } else {
      userToken = await OBPService().loginOBP(
        _emailController.text,
        _pdController.text,
      );

      if (userToken != null) {
        Navigator.of(context).push(
          PageTransition(
            type: PageTransitionType.rightToLeftWithFade,
            duration: const Duration(milliseconds: 400),
            curve: Curves.ease,
            child: BanksPage(
              userToken: userToken!,
              emailId: _emailController.text,
            ),
            // ignore: unnecessary_this
            childCurrent: this.widget,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: customText(
              text: 'Invalid Credentials',
              size: 14.sp,
              fontWeight: FontWeight.bold,
              color: errorColor,
            ),
            backgroundColor: tertiaryColor,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryBg,
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: isWeb ? const EdgeInsetsDirectional.fromSTEB(0, 120, 0, 0) :const EdgeInsetsDirectional.fromSTEB(0, 80, 0, 0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  novaAppIcon,
                  width:  200,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Align(
              alignment: const AlignmentDirectional(0, 0),
              child: customText(
                text: 'Sign In',
                size: 32,
                color: primaryTextColor,
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(16, 40, 16, 0),
              child: SizedBox(
                width: isWeb ? 400 : double.infinity,
                child: TextField(
                
                  controller: _emailController,
                  cursorColor: secondaryTextColor,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 2.r,
                        color: borderColor,
                      ),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 2.r,
                        color: borderColor,
                      ),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 2.r,
                        color: borderColor,
                      ),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    hintText: 'Email',
                    hintStyle: GoogleFonts.poppins(
                      color: primaryTextColor,
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  keyboardType: TextInputType.text,
                  style: GoogleFonts.poppins(
                    color: primaryTextColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 0),
              child: SizedBox(
                width: isWeb ? 400 : double.infinity,
                child: TextField(
                  controller: _pdController,
                  cursorColor: secondaryTextColor,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 2.r,
                        color: borderColor,
                      ),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 2.r,
                        color: borderColor,
                      ),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 2.r,
                        color: borderColor,
                      ),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    hintText: 'Password',
                    hintStyle: GoogleFonts.poppins(
                      color: primaryTextColor,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  keyboardType: TextInputType.text,
                  style: GoogleFonts.poppins(
                    color: primaryTextColor,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 24, 0, 0),
              child: GestureDetector(
                onTap: loginBtn,
                child: Container(
                  width: 180,
                  height: 52,
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: customText(
                      text: 'Sign In',
                      size: 18.sp,
                      color: primaryBg,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
