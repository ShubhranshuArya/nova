import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nova/constants/colors.dart';
import 'package:nova/constants/strings.dart';
import 'package:nova/constants/widgets.dart';
import 'package:nova/models/account_model.dart';
import 'package:nova/pages/no_internet_screen.dart';
import 'package:nova/pages/transactions_page.dart';
import 'package:nova/services/internet_service.dart';
import 'package:nova/services/obp_service.dart';
import 'package:page_transition/page_transition.dart';

// Account Page for a selected Bank
class AccountsPage extends StatefulWidget {
  final String userToken;
  final String bankName;
  final String bankId;
  const AccountsPage({
    super.key,
    required this.userToken,
    required this.bankName,
    required this.bankId,
  });

  @override
  State<AccountsPage> createState() => _AccountsPageState();
}

class _AccountsPageState extends State<AccountsPage> {
  final _accountController = TextEditingController();
  AccountModel? accountsList;
  AccountModel? searchedAccountsList;
  bool isAccountsLoaded = false;

  // Initializes the accounts list
  getAccountsList() async {
    accountsList =
        await OBPService().getAccountsOBP(widget.userToken, widget.bankId);
    searchedAccountsList = accountsList;
    if (accountsList != null) {
      Future.delayed(const Duration(milliseconds: 350), () {
        setState(() {
          isAccountsLoaded = true;
        });
      });
    }
  }

  // On pressing bank account item
  bankAccountBtn(
    String accountId,
    String balance,
  ) {
    Navigator.of(context)
        .push(
          PageTransition(
            type: PageTransitionType.rightToLeftWithFade,
            duration: const Duration(milliseconds: 400),
            curve: Curves.ease,
            child: TransactionsPage(
              userToken: widget.userToken,
              bankId: widget.bankId,
              accountId: accountId,
              balance: balance,
              bankName: widget.bankName,
            ),
            // ignore: unnecessary_this
            childCurrent: this.widget,
          ),
        )
        .whenComplete(() => updateAccounts());
  }
  
  // Updating searched accounts list
  updateAccounts() {
    setState(() {
      _accountController.clear();
      searchedAccountsList = accountsList;
    });
  }

  // Searching for an account by ID
  searchAccount(String accountId) {
    if (accountId.isEmpty) {
      updateAccounts();
    }
    setState(() {
      searchedAccountsList = AccountModel(
        accounts: accountsList!.accounts
            .where((account) => account.accountId!.contains(accountId))
            .toList(),
      );
    });
  }

  @override
  void initState() {
    getAccountsList();
    super.initState();
  }

  @override
  void dispose() {
    _accountController.dispose();
    super.dispose();
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
              mainAxisSize: MainAxisSize.min,
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
                Align(
                  alignment: const AlignmentDirectional(-1, 0),
                  child: Padding(
                    padding:
                        const EdgeInsetsDirectional.fromSTEB(24, 12, 24, 0),
                    child: customText(
                      text: widget.bankName,
                      size: 18.sp,
                      color: primaryTextColor,
                    ),
                  ),
                ),
                Align(
                  alignment: const AlignmentDirectional(-1, 0),
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
                    child: customText(
                      text: 'My Accounts',
                      size: 24,
                      fontWeight: FontWeight.w600,
                      color: primaryTextColor,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(24, 16, 24, 0),
                  child: TextField(
                    controller: _accountController,
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
                      hintText: 'Search by Account Id',
                      hintStyle: GoogleFonts.poppins(
                        color: primaryTextColor,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.normal,
                      ),
                      contentPadding:
                          const EdgeInsetsDirectional.fromSTEB(16, 16, 12, 16),
                      suffixIcon: GestureDetector(
                        onTap: () => updateAccounts(),
                        child: _accountController.text.isEmpty
                            ? const Icon(
                                Icons.search_rounded,
                                color: secondaryTextColor,
                              )
                            : const Icon(
                                Icons.clear_rounded,
                                color: secondaryTextColor,
                              ),
                      ),
                    ),
                    keyboardType: TextInputType.text,
                    style: GoogleFonts.poppins(
                      color: primaryTextColor,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.normal,
                    ),
                    onChanged: (value) {
                      searchAccount(value);
                    },
                  ),
                ),
                !isAccountsLoaded
                    ? const Padding(
                        padding: EdgeInsets.only(top: 48.0),
                        child: CircularProgressIndicator(
                          color: primaryColor,
                        ),
                      )
                    : searchedAccountsList!.accounts.isEmpty
                        ? Column(
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
                                text: 'No Account found',
                                size: 18.sp,
                                color: primaryTextColor,
                                fontWeight: FontWeight.w500
                              ),
                            ],
                          )
                        : Expanded(
                            child: ListView.builder(
                              itemCount: searchedAccountsList!.accounts.length,
                              itemBuilder: (BuildContext context, int index) {
                                String balance = searchedAccountsList!
                                    .accounts[index].balances![0].amount!;
                                String currency = searchedAccountsList!
                                    .accounts[index].balances![0].currency!;
                                String accountId = searchedAccountsList!
                                    .accounts[index].accountId!;

                                String currencyText =
                                    getCurrencyText(currency, balance);
                                Color amountColor = currencyText.startsWith('-')
                                    ? errorColor
                                    : successColor;

                                return Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      24, 16, 24, 0),
                                  child: Container(
                                    padding: const EdgeInsets.all(16.0),
                                    decoration: BoxDecoration(
                                      color: primaryColor.withOpacity(0.05),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: InkWell(
                                      splashColor: Colors.transparent,
                                      focusColor: Colors.transparent,
                                      hoverColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      onTap: () => bankAccountBtn(
                                          accountId, currencyText),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              customText(
                                                text: widget.bankId,
                                                size: 16.sp,
                                                color: primaryTextColor,
                                                fontWeight: FontWeight.w500,
                                              ),
                                              customText(
                                                text: accountId,
                                                size: 12.sp,
                                                color: primaryTextColor,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ],
                                          ),
                                          customText(
                                            text: currencyText,
                                            size: 16.sp,
                                            color: amountColor,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                SizedBox(
                  height: 20.h,
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
