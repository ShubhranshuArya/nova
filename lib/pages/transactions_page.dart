import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nova/constants/colors.dart';
import 'package:nova/constants/strings.dart';
import 'package:nova/constants/widgets.dart';
import 'package:nova/models/transaction_model.dart';
import 'package:nova/pages/no_internet_screen.dart';
import 'package:nova/pages/txn_card.dart';
import 'package:nova/services/internet_service.dart';
import 'package:nova/services/obp_service.dart';
import 'package:intl/intl.dart';

enum TxnFilter {
  all,
  sent,
  received,
}

class TransactionsPage extends StatefulWidget {
  final String userToken;
  final String bankId;
  final String accountId;
  final String balance;
  final String bankName;
  const TransactionsPage({
    super.key,
    required this.userToken,
    required this.bankId,
    required this.accountId,
    required this.balance,
    required this.bankName,
  });

  @override
  State<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> {
  TransactionModel? transactionsList;
  TransactionModel? filteredList;
  TxnFilter selectedFilter = TxnFilter.all;
  bool isTransactionLoaded = false;

  getTxnList() async {
    transactionsList = await OBPService().getTransactionsOBP(
      widget.userToken,
      widget.bankId,
      widget.accountId,
    );
    filteredList = transactionsList;
    if (transactionsList != null) {
      Future.delayed(const Duration(seconds: 1), () {
        setState(() {
          isTransactionLoaded = true;
        });
      });
    }
  }

  filteredTxnList(TxnFilter txnFilter) {
    if (selectedFilter != TxnFilter.sent && txnFilter == TxnFilter.sent) {
      setState(() {
        selectedFilter = TxnFilter.sent;
        filteredList = TransactionModel(
            transactions: transactionsList!.transactions
                .where((txn) => txn.details!.value!.amount!.startsWith('-'))
                .toList());
      });
    } else if (selectedFilter != TxnFilter.received && txnFilter == TxnFilter.received) {
      setState(() {
        selectedFilter = TxnFilter.received;
        filteredList = TransactionModel(
            transactions: transactionsList!.transactions
                .where((txn) => !txn.details!.value!.amount!.startsWith('-'))
                .toList());
      });
    } else if (selectedFilter != TxnFilter.all) {
      setState(() {
        selectedFilter = TxnFilter.all;
        filteredList = transactionsList;
      });
    }
  }

  @override
  void initState() {
    getTxnList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InternetCubit, InternetState>(
      builder: (context, state) {
        if (state == InternetState.lost) {
          return const NoInternetScreen();
        }
        return Scaffold(
          backgroundColor: primaryBg,
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: const AlignmentDirectional(-1, 0),
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(10, 16, 0, 0),
                    child: InkWell(
                      splashColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () => Navigator.pop(context),
                      child: const Icon(
                        Icons.chevron_left_rounded,
                        color: secondaryTextColor,
                        size: 40,
                      ),
                    ),
                  ),
                ),
                TxnCard(
                  balance: widget.balance,
                  accountId: widget.accountId,
                  bankId: widget.bankId,
                  bankName: widget.bankName,
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(24, 32, 24, 0),
                  child: customText(
                    text: 'Transactions',
                    size: 22.sp,
                    color: primaryTextColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                (isTransactionLoaded &&
                        transactionsList!.transactions.isNotEmpty)
                    ? Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(24, 6, 24, 0),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () => filteredTxnList(TxnFilter.all),
                              child: Chip(
                                label: customText(
                                  text: 'All',
                                  size: 12.sp,
                                  color: selectedFilter == TxnFilter.all
                                    ? primaryBg
                                    : primaryTextColor,
                                ),
                                backgroundColor: selectedFilter == TxnFilter.all
                                    ? primaryTextColor
                                    : primaryBg,
                              ),
                            ),
                            SizedBox(width: 8),
                            GestureDetector(
                              onTap: () => filteredTxnList(TxnFilter.sent),
                              child: Chip(
                                label: customText(
                                  text: 'Sent',
                                  size: 12.sp,
                                  color: selectedFilter == TxnFilter.sent
                                    ? primaryBg
                                    : primaryTextColor,
                                ),
                                backgroundColor: selectedFilter == TxnFilter.sent
                                    ? primaryTextColor
                                    : primaryBg,
                              ),
                            ),
                            const SizedBox(width: 8),
                            GestureDetector(
                              onTap: () => filteredTxnList(TxnFilter.received),
                              child: Chip(
                                label: customText(
                                  text: 'Received',
                                  size: 12.sp,
                                  color: selectedFilter == TxnFilter.received
                                    ? primaryBg
                                    : primaryTextColor,
                                ),
                                backgroundColor: selectedFilter == TxnFilter.received
                                    ? primaryTextColor
                                    : primaryBg,
                              ),
                            ),
                          ],
                        ),
                      )
                    : const SizedBox.shrink(),
                !isTransactionLoaded
                    ? const Padding(
                        padding: EdgeInsets.only(top: 48.0),
                        child: Center(
                          child: CircularProgressIndicator(
                            color: primaryColor,
                          ),
                        ),
                      )
                    : filteredList!.transactions.isEmpty
                        ? Align(
                          alignment: Alignment.center,
                          child: Column(
                              children: [
                                const SizedBox(height: 40),
                                Image.asset(
                                  noDataFoundImg,
                                  width: 120,
                                  height: 120,
                                  fit: BoxFit.cover,
                                ),
                                const SizedBox(height: 12),
                                customText(
                                  text: 'No Transaction Done',
                                  size: 18.sp,
                                  color: primaryTextColor,
                                  fontWeight: FontWeight.w500
                                ),
                              ],
                            ),
                        )
                        : Expanded(
                            child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  32, 16, 32, 0),
                              child: ListView.separated(
                                itemCount:
                                    filteredList!.transactions.length,
                                separatorBuilder:
                                    (BuildContext context, int index) {
                                  return const Divider();
                                },
                                itemBuilder: (BuildContext context, int index) {
                                  DateTime completedAt = filteredList!
                                          .transactions[index]
                                          .details!
                                          .completed ??
                                      DateTime.now();
                                  String description = filteredList!
                                          .transactions[index]
                                          .details!
                                          .description ??
                                      'Description';
                                  String type = filteredList!
                                          .transactions[index].details!.type ??
                                      'type';
                                  String currency = filteredList!
                                      .transactions[index]
                                      .details!
                                      .value!
                                      .currency!;
                                  String amount = filteredList!
                                      .transactions[index]
                                      .details!
                                      .value!
                                      .amount!;
                                  String time = DateFormat('dd-MM-yyyy')
                                      .format(completedAt);
                                  String amountText =
                                      getCurrencyText(currency, amount);
                                  Color amountColor = amountText.startsWith('-')
                                      ? errorColor
                                      : successColor;
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 6.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            customText(
                                              text: type,
                                              size: 14.sp,
                                              color: primaryTextColor,
                                              fontWeight: FontWeight.w500,
                                            ),
                                            customText(
                                              text: description.length > 20
                                                  ? description.substring(0, 20)
                                                  : description,
                                              size: 12.sp,
                                              color: primaryTextColor,
                                              fontWeight: FontWeight.w400,
                                            ),
                                            customText(
                                              text: time,
                                              size: 12.sp,
                                              color: primaryTextColor,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          width: 180,
                                          child: customText(
                                            text: amountText,
                                            size: 22.sp,
                                            color: amountColor,
                                            fontWeight: FontWeight.w700,
                                            alignment: TextAlign.end,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                SizedBox(height: 20.h)
              ],
            ),
          ),
        );
      },
    );
  }
}
