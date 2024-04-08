import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nova/constants/strings.dart';
import 'package:nova/models/account_model.dart';
import 'package:nova/models/bank_model.dart';
import 'package:nova/models/transaction_model.dart';

class OBPService {

  // User Authentication
  Future<String?> loginOBP(
    String username,
    String password,
  ) async {
    try {
      var url =
          Uri.parse("https://apisandbox.openbankproject.com/my/logins/direct");
      var response = await http.post(
        url,
        headers: {
          'Authorization':
              'DirectLogin username="$username", password="$password", consumer_key="$consumerKey"',
          'Content-Type': 'application/json'
        },
      );
      if (response.statusCode == 201) {
        var jsonString = jsonDecode(response.body);
        var token = jsonString['token'];
        return token;
      }
      
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  // Get User Banks
  Future<BankModel?> getBanksOBP(String token) async {
    try {
      var url =
          Uri.parse("https://apisandbox.openbankproject.com/obp/v4.0.0/banks");
      var response = await http.get(
        url,
        headers: {
          'Authorization': 'DirectLogin token=$token',
          'Cache-Control': 'no-cache, no-store, max-age=0',
          'Content-Type': 'application/json'
        },
      );

      if (response.statusCode == 200) {
        var jsonString = response.body;
        final bankModel = bankModelFromJson(jsonString);
        return bankModel;
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  // Get Accounts for a Bank
  Future<AccountModel?> getAccountsOBP(
    String token,
    String bankId,
  ) async {
    try {
      var url = Uri.parse(
          "https://apisandbox.openbankproject.com/obp/v4.0.0/banks/$bankId/balances");
      var response = await http.get(
        url,
        headers: {
          'Authorization': 'DirectLogin token=$token',
          'Content-Type': 'application/json'
        },
      );

      if (response.statusCode == 200) {
        var jsonString = response.body;
        final accountModel = accountModelFromJson(jsonString);
        return accountModel;
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  // Get Transactions for a Bank Account
  Future<TransactionModel?> getTransactionsOBP(
    String token,
    String bankId,
    String accountId,
  ) async {
    try {
      var url = Uri.parse(
          "https://apisandbox.openbankproject.com/obp/v4.0.0/my/banks/$bankId/accounts/$accountId/transactions");
      var response = await http.get(
        url,
        headers: {
          'Authorization': 'DirectLogin token=$token',
          'Content-Type': 'application/json'
        },
      );
      if (response.statusCode == 200) {
        var jsonString = response.body;
        final transactionModel = transactionModelFromJson(jsonString);
        return transactionModel;
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  // Logout User
  Future<void> logoutUser(
    String token,
  ) async {
    try {
      var url = Uri.parse(
          "https://apisandbox.openbankproject.com/obp/v4.0.0/users/current/logout-link");
      var response = await http.get(
        url,
        headers: {
          'Authorization': 'DirectLogin token=$token',
          'Content-Type': 'application/json'
        },
      );
      debugPrint(response.body);
      
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
