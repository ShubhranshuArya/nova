import 'dart:convert';

AccountModel accountModelFromJson(String str) => AccountModel.fromJson(jsonDecode(str));
String accountModelToJson(AccountModel data) => json.encode(data.toJson());

// Json Parsing for Accounts.
class AccountModel {
    List<Account> accounts;

    AccountModel({
        required this.accounts,
    });

    factory AccountModel.fromJson(Map<String, dynamic> json) => AccountModel(
        accounts: List<Account>.from(json["accounts"].map((x) => Account.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "accounts": List<dynamic>.from(accounts.map((x) => x.toJson())),
    };
}

class Account {
    String? accountId;
    String? bankId;
    List<AccountRouting>? accountRoutings;
    String? label;
    List<Balance>? balances;

    Account({
        required this.accountId,
        required this.bankId,
        required this.accountRoutings,
        required this.label,
        required this.balances,
    });

    factory Account.fromJson(Map<String, dynamic> json) => Account(
        accountId: json["account_id"],
        bankId: json["bank_id"],
        accountRoutings: List<AccountRouting>.from(json["account_routings"].map((x) => AccountRouting.fromJson(x))),
        label: json["label"],
        balances: List<Balance>.from(json["balances"].map((x) => Balance.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "account_id": accountId,
        "bank_id": bankId,
        "account_routings": List<dynamic>.from(accountRoutings!.map((x) => x.toJson())),
        "label": label,
        "balances": List<dynamic>.from(balances!.map((x) => x.toJson())),
    };
}

class AccountRouting {
    String? scheme;
    String? address;

    AccountRouting({
        required this.scheme,
        required this.address,
    });

    factory AccountRouting.fromJson(Map<String, dynamic> json) => AccountRouting(
        scheme: json["scheme"],
        address: json["address"],
    );

    Map<String, dynamic> toJson() => {
        "scheme": scheme,
        "address": address,
    };
}

class Balance {
    String? type;
    String? currency;
    String? amount;

    Balance({
        required this.type,
        required this.currency,
        required this.amount,
    });

    factory Balance.fromJson(Map<String, dynamic> json) => Balance(
        type: json["type"],
        currency: json["currency"],
        amount: json["amount"],
    );

    Map<String, dynamic> toJson() => {
        "type": type,
        "currency": currency,
        "amount": amount,
    };
}
