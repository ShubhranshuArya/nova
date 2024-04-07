// To parse this JSON data, do
//
//     final bankModel = bankModelFromJson(jsonString);
import 'dart:convert';

BankModel bankModelFromJson(String str) => BankModel.fromJson(jsonDecode(str));

String bankModelToJson(BankModel data) => json.encode(data.toJson());

class BankModel {
    List<Bank> banks;

    BankModel({
        required this.banks,
    });

    factory BankModel.fromJson(Map<String, dynamic> json) => BankModel(
        banks: List<Bank>.from(json["banks"].map((x) => Bank.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "banks": List<dynamic>.from(banks.map((x) => x.toJson())),
    };
}

class Bank {
    String? id;
    String? shortName;
    String? fullName;
    String? logo;
    String? website;

    Bank({
        required this.id,
        required this.shortName,
        required this.fullName,
        required this.logo,
        required this.website,
    });

    factory Bank.fromJson(Map<String, dynamic> json) => Bank(
        id: json["id"],
        shortName: json["short_name"],
        fullName: json["full_name"],
        logo: json["logo"],
        website: json["website"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "short_name": shortName,
        "full_name": fullName,
        "logo": logo,
        "website": website,
    };
}


