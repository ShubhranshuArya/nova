import 'dart:convert';

TransactionModel transactionModelFromJson(String str) => TransactionModel.fromJson(json.decode(str));
String transactionModelToJson(TransactionModel data) => json.encode(data.toJson());

// Json parsing for transactions
class TransactionModel {
    List<Transaction> transactions;

    TransactionModel({
        required this.transactions,
    });

    factory TransactionModel.fromJson(Map<String, dynamic> json) => TransactionModel(
        transactions: List<Transaction>.from(json["transactions"].map((x) => Transaction.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "transactions": List<dynamic>.from(transactions.map((x) => x.toJson())),
    };
}

class Transaction {
    String? id;
    Details? details;
    List<TransactionAttribute>? transactionAttributes;

    Transaction({
        required this.id,
        required this.details,
        required this.transactionAttributes,
    });

    factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
        id: json["id"],
        details: Details.fromJson(json["details"]),
        transactionAttributes: List<TransactionAttribute>.from(json["transaction_attributes"].map((x) => TransactionAttribute.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "details": details!.toJson(),
        "transaction_attributes": List<dynamic>.from(transactionAttributes!.map((x) => x.toJson())),
    };
}

class Details {
    String? type;
    String? description;
    DateTime? completed;
    Value? value;

    Details({
        required this.type,
        required this.description,
        required this.completed,
        required this.value,
    });

    factory Details.fromJson(Map<String, dynamic> json) => Details(
        type: json["type"],
        description: json["description"],
        completed: DateTime.parse(json["completed"]),
        value: Value.fromJson(json["value"]),
    );

    Map<String, dynamic> toJson() => {
        "type": type,
        "description": description,
        "completed": completed!.toIso8601String(),
        "value": value!.toJson(),
    };
}

class Value {
    String? currency;
    String? amount;

    Value({
        required this.currency,
        required this.amount,
    });

    factory Value.fromJson(Map<String, dynamic> json) => Value(
        currency: json["currency"],
        amount: json["amount"],
    );

    Map<String, dynamic> toJson() => {
        "currency": currency,
        "amount": amount,
    };
}

class TransactionAttribute {
    String? name;
    String? type;
    String? value;

    TransactionAttribute({
        required this.name,
        required this.type,
        required this.value,
    });

    factory TransactionAttribute.fromJson(Map<String, dynamic> json) => TransactionAttribute(
        name: json["name"],
        type: json["type"],
        value: json["value"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "type": type,
        "value": value,
    };
}
