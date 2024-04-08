import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nova/constants/colors.dart';
import 'package:nova/constants/strings.dart';
import 'package:nova/constants/widgets.dart';
import 'package:nova/models/bank_model.dart';
import 'package:nova/pages/accounts_page.dart';
import 'package:nova/pages/no_internet_screen.dart';
import 'package:nova/services/internet_service.dart';
import 'package:nova/services/obp_service.dart';
import 'package:nova/widgets/logout_dialog_box.dart';
import 'package:page_transition/page_transition.dart';

// Home Page
class BanksPage extends StatefulWidget {
  final String userToken;
  final String emailId;

  const BanksPage({
    super.key,
    required this.userToken,
    required this.emailId,
  });

  @override
  State<BanksPage> createState() => _BanksPageState();
}

class _BanksPageState extends State<BanksPage> {
  final _bankController = TextEditingController();
  BankModel? banksList;
  BankModel? searchedBanksList;
  bool isDataLoaded = false;

  // Initializes banksList
  getBanksList() async {
    banksList = await OBPService().getBanksOBP(widget.userToken);
    searchedBanksList = banksList;
    if (banksList != null) {
      Future.delayed(const Duration(seconds: 1), () {
        setState(() {
          isDataLoaded = true;
        });
      });
    }
  }

  // On pressing bank list item
  bankButton(String bankName, String bankId) {
    Navigator.of(context)
        .push(
          PageTransition(
            type: PageTransitionType.rightToLeftWithFade,
            duration: const Duration(milliseconds: 400),
            curve: Curves.ease,
            child: AccountsPage(
              userToken: widget.userToken,
              bankName: bankName,
              bankId: bankId,
            ),
            // ignore: unnecessary_this
            childCurrent: this.widget,
          ),
        )
        .whenComplete(() => updateBanks());
  }

  // Updating searched banks list
  updateBanks() {
    setState(() {
      _bankController.clear();
      searchedBanksList = banksList;
    });
  }

  // On search for a bank
  searchBank(String bankName) {
    if (bankName.isEmpty) {
      updateBanks();
    }
    setState(() {
      // If there is a search query, filter the banks based on the query
      searchedBanksList = BankModel(
        banks: banksList!.banks
            .where((bank) => bank.fullName!.startsWith(bankName))
            .toList(),
      );
    });
  }

  @override
  void initState() {
    getBanksList();
    super.initState();
  }

  @override
  void dispose() {
    _bankController.dispose();
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
                    padding:
                        const EdgeInsetsDirectional.fromSTEB(24, 16, 24, 0),
                    child: customText(
                      text: 'Hi ${getUserName(widget.emailId)},',
                      size: 22,
                      fontWeight: FontWeight.w600,
                      color: primaryColor,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      customText(
                        text: 'My Banks',
                        size: 24,
                        fontWeight: FontWeight.w600,
                        color: primaryTextColor,
                      ),
                      InkWell(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) =>
                                LogoutDialogBox(userToken: widget.userToken),
                          );
                        },
                        splashColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        child: const Icon(
                          Icons.logout_rounded,
                          color: primaryTextColor,
                          size: 24,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 16),
                  child: TextField(
                    controller: _bankController,
                    cursorColor: secondaryTextColor,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          width: 2,
                          color: borderColor,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          width: 2,
                          color: borderColor,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(
                          width: 2,
                          color: borderColor,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      hintText: 'Search for a Bank',
                      hintStyle: GoogleFonts.poppins(
                        color: primaryTextColor,
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                      ),
                      contentPadding:
                          const EdgeInsetsDirectional.fromSTEB(16, 16, 12, 16),
                      suffixIcon: GestureDetector(
                        onTap: () => updateBanks(),
                        child: _bankController.text.isEmpty
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
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                    ),
                    onChanged: (value) {
                      searchBank(value);
                    },
                  ),
                ),
                !isDataLoaded
                    ? const Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0, 40, 0, 0),
                        child: CircularProgressIndicator(
                          color: primaryColor,
                        ),
                      )
                    : searchedBanksList!.banks.isEmpty
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
                                  text: 'No Banks found',
                                  size: 18,
                                  color: primaryTextColor,
                                  fontWeight: FontWeight.w500),
                            ],
                          )
                        : Expanded(
                            child: ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              itemCount: searchedBanksList!.banks.length,
                              shrinkWrap: true,
                              itemBuilder: (BuildContext context, int index) {
                                var bankFullName =
                                    searchedBanksList!.banks[index].fullName!;
                                var bankId =
                                    searchedBanksList!.banks[index].id!;

                                return Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      16, 0, 16, 16),
                                  child: Container(
                                    padding: const EdgeInsets.all(8.0),
                                    decoration: BoxDecoration(
                                      color: primaryColor.withOpacity(0.05),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: InkWell(
                                      splashColor: Colors.transparent,
                                      focusColor: Colors.transparent,
                                      hoverColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      onTap: () =>
                                          bankButton(bankFullName, bankId),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: 64,
                                            height: 64,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              border: Border.all(
                                                color: secondaryColor,
                                              ),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(2),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: primaryBg,
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                child: FutureBuilder(
                                                    future: validateLogoUrl(
                                                        searchedBanksList!
                                                            .banks[index].logo),
                                                    builder:
                                                        (context, snapshot) {
                                                      if (snapshot.hasData &&
                                                          (snapshot.data !=
                                                              'no_img')) {
                                                        String imgUrl =
                                                            snapshot.data!;

                                                        return Image.network(
                                                          imgUrl,
                                                          width: 20,
                                                          height: 20,
                                                          fit: BoxFit.fitWidth,
                                                          errorBuilder: (context,
                                                                  error,
                                                                  stackTrace) =>
                                                              Image.asset(
                                                            defaultBankImg,
                                                            width: 20,
                                                            height: 20,
                                                            fit: BoxFit.cover,
                                                          ),
                                                        );
                                                      } else {
                                                        return Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(12.0),
                                                          child: Image.asset(
                                                            defaultBankImg,
                                                            width: 20,
                                                            height: 20,
                                                            fit: BoxFit.cover,
                                                          ),
                                                        );
                                                      }
                                                    }),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(12, 0, 0, 0),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  width: 260,
                                                  child: customText(
                                                    text: bankFullName,
                                                    size: 16,
                                                    color: primaryTextColor,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                customText(
                                                  text: bankId,
                                                  size: 12,
                                                  color: primaryTextColor,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                const SizedBox(
                  height: 20,
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
