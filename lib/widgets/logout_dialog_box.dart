import 'package:flutter/material.dart';
import 'package:nova/constants/colors.dart';
import 'package:nova/constants/widgets.dart';
import 'package:nova/pages/login_page.dart';
import 'package:nova/services/obp_service.dart';
import 'package:page_transition/page_transition.dart';


// Custom Logout Dialog box
class LogoutDialogBox extends StatelessWidget {
  final String userToken;
  const LogoutDialogBox({super.key, required this.userToken});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        decoration: BoxDecoration(
          color: primaryBg,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 22),
            customText(
                text: 'Are you sure that you\nwant to logout?',
                size: 20,
                color: primaryTextColor,
                alignment: TextAlign.center,
                fontWeight: FontWeight.w600),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Center(
                      child: customText(
                          text: 'Cancel',
                          size: 16,
                          color: primaryBg,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    OBPService().logoutUser(userToken);
                    Navigator.of(context).pushReplacement(
                      PageTransition(
                        type: PageTransitionType.fade,
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.ease,
                        child: const LoginPage(),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                    decoration: BoxDecoration(
                      color: errorColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Center(
                      child: customText(
                          text: 'Logout',
                          size: 16,
                          color: primaryBg,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
