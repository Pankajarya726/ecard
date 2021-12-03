// To parse this JSON data, do
//
//     final currencyModel = currencyModelFromJson(jsonString);

import 'dart:convert';

CurrencyModel currencyModelFromJson(String str) =>
    CurrencyModel.fromJson(json.decode(str));

String currencyModelToJson(CurrencyModel data) => json.encode(data.toJson());

class CurrencyModel {
  CurrencyModel({
    this.baseCurrencyCode,
    this.baseCurrencyName,
    this.amount,
    this.updatedDate,
    this.rates,
    this.status,
  });

  final String baseCurrencyCode;
  final String baseCurrencyName;
  final String amount;
  final DateTime updatedDate;
  final Map<String, Rate> rates;
  final String status;

  factory CurrencyModel.fromJson(Map<String, dynamic> json) => CurrencyModel(
        baseCurrencyCode: json["base_currency_code"],
        baseCurrencyName: json["base_currency_name"],
        amount: json["amount"],
        updatedDate: DateTime.parse(json["updated_date"]),
        rates: Map.from(json["rates"])
            .map((k, v) => MapEntry<String, Rate>(k, Rate.fromJson(v))),
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "base_currency_code": baseCurrencyCode,
        "base_currency_name": baseCurrencyName,
        "amount": amount,
        "updated_date":
            "${updatedDate.year.toString().padLeft(4, '0')}-${updatedDate.month.toString().padLeft(2, '0')}-${updatedDate.day.toString().padLeft(2, '0')}",
        "rates": Map.from(rates)
            .map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
        "status": status,
      };
}

class Rate {
  Rate({
    this.currencyName,
    this.rate,
    this.rateForAmount,
  });

  final String currencyName;
  final String rate;
  final String rateForAmount;

  factory Rate.fromJson(Map<String, dynamic> json) => Rate(
        currencyName: json["currency_name"],
        rate: json["rate"],
        rateForAmount: json["rate_for_amount"],
      );

  Map<String, dynamic> toJson() => {
        "currency_name": currencyName,
        "rate": rate,
        "rate_for_amount": rateForAmount,
      };
}
