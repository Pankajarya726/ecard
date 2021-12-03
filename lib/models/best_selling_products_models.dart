// To parse this JSON data, do
//
//     final bestSellingModel = bestSellingModelFromJson(jsonString);

import 'dart:convert';

BestSellingModel bestSellingModelFromJson(String str) =>
    BestSellingModel.fromJson(json.decode(str));

String bestSellingModelToJson(BestSellingModel data) =>
    json.encode(data.toJson());

class BestSellingModel {
  BestSellingModel({
    this.response,
    this.data,
  });

  final bool response;
  final List<Datum> data;

  factory BestSellingModel.fromJson(Map<String, dynamic> json) =>
      BestSellingModel(
        response: json["response"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "response": response,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datum {
  Datum({
    this.id,
    this.name,
    this.regularPrice,
    this.sales,
    this.image,
    this.price,
    this.lastEditor,
    this.sellPrice,
    this.averageRating,
    this.reviewCount,
    this.fixedCurrency,
  });

  final int id;
  final String name;
  final String regularPrice;
  final String sales;
  final String image;
  final String price;
  final String lastEditor;
  final String sellPrice;
  final String averageRating;
  final String reviewCount;
  final String fixedCurrency;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        name: json["name"],
        regularPrice: json["regular_price"],
        sales: json["sales"],
        image: json["image"],
        price: json["price"],
        lastEditor: json["last_editor"],
        sellPrice: json["sell_price"],
        averageRating: json["average_rating"],
        reviewCount: json["review_count"],
        fixedCurrency: json["fixed_currency"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "regular_price": regularPrice,
        "sales": sales,
        "image": image,
        "price": price,
        "last_editor": lastEditor,
        "sell_price": sellPrice,
        "average_rating": averageRating,
        "review_count": reviewCount,
        "fixed_currency": fixedCurrency,
      };
}
