import 'package:flutter/material.dart';
import 'package:nova/constants/colors.dart';
import 'package:nova/constants/widgets.dart';

class TxnCard extends StatelessWidget {
  final String balance;
  final String bankId;
  final String bankName;
  final String accountId;
  const TxnCard(
      {super.key,
      required this.balance,
      required this.bankId,
      required this.bankName,
      required this.accountId});

  @override
  Widget build(BuildContext context) {
    return // Generated code for this Container Widget...
        Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(24, 16, 24, 0),
      child: Container(
        width: double.infinity,
        height: 200,
        decoration: BoxDecoration(
          boxShadow: const [
            BoxShadow(
              blurRadius: 8,
              color: primaryTextColor,
              offset: Offset(
                0,
                2,
              ),
            )
          ],
          gradient: const LinearGradient(
            colors: [
              gradientColorOne,
              errorColor,
              gradientColorThree,
            ],
            stops: [0, 0.5, 1],
            begin: AlignmentDirectional(1, 1),
            end: AlignmentDirectional(-1, -1),
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      customText(
                        text: 'Balance',
                        size: 12,
                        color: primaryBg,
                      ),
                      SizedBox(
                        width: 300,
                        child: customText(
                          text: balance,
                          size: 36,
                          color: primaryBg,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 12, 0, 4),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    customText(
                      text: bankName,
                      size: 14,
                      color: primaryBg,
                    ),
                    customText(
                      text: accountId,
                      size: 14,
                      color: primaryBg,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
