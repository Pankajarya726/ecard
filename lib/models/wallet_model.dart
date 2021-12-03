// To parse this JSON data, do
//
//     final walletModel = walletModelFromJson(jsonString);

import 'dart:convert';

WalletModel walletModelFromJson(String str) =>
    WalletModel.fromJson(json.decode(str));

String walletModelToJson(WalletModel data) => json.encode(data.toJson());

class WalletModel {
  WalletModel({
    this.response,
    this.data,
  });

  final bool response;
  final Data data;

  factory WalletModel.fromJson(Map<String, dynamic> json) => WalletModel(
        response: json["response"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "response": response,
        "data": data.toJson(),
      };
}

class Data {
  Data({
    this.userId,
    this.balance,
    this.lastDeposit,
    this.totalSpent,
    this.status,
    this.lockMessage,
  });

  final int userId;
  final dynamic balance;
  final dynamic lastDeposit;
  final String totalSpent;
  final String status;
  final String lockMessage;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        userId: json["user_id"],
        balance: json["balance"],
        lastDeposit: json["last_deposit"],
        totalSpent: json["total_spent"],
        status: json["status"],
        lockMessage: json["lock_message"],
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "balance": balance,
        "last_deposit": lastDeposit,
        "total_spent": totalSpent,
        "status": status,
        "lock_message": lockMessage,
      };
}
