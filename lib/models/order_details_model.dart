// To parse this JSON data, do
//
//     final orderDetailsModel = orderDetailsModelFromJson(jsonString);

import 'dart:convert';

OrderDetailsModel orderDetailsModelFromJson(String str) =>
    OrderDetailsModel.fromJson(json.decode(str));

String orderDetailsModelToJson(OrderDetailsModel data) =>
    json.encode(data.toJson());

class OrderDetailsModel {
  OrderDetailsModel({
    this.response,
    this.data,
  });

  final bool response;
  final Data data;

  factory OrderDetailsModel.fromJson(Map<String, dynamic> json) =>
      OrderDetailsModel(
        response: json["response"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "response": response,
        "data": data.toJson(),
      };
}

class Data {
  Data(
      {this.id,
      this.parentId,
      this.orderPlaced,
      this.totalItems,
      this.total,
      this.shippingTotal,
      this.products,
      this.subTotal,
      this.refund});

  final String id;
  final dynamic parentId;
  final String orderPlaced;
  final int totalItems;
  final dynamic total;
  final dynamic subTotal;
  final int refund;
  final dynamic shippingTotal;
  final List<Product> products;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        parentId: json["parent_id"],
        orderPlaced: json["order_placed"],
        totalItems: json["total_items"],
        total: json["total"],
        subTotal: json["subtotal"],
        shippingTotal: json["shipping_total"],
        refund: json["refund"],
        products: json["products"] != null
            ? List<Product>.from(
                json["products"].map(
                  (x) => Product.fromJson(x),
                ),
              )
            : null,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "parent_id": parentId,
        "order_placed": orderPlaced,
        "total_items": totalItems,
        "total": total,
        "subtotal": subTotal,
        "shipping_total": shippingTotal,
        "refund": refund,
        "products": List<dynamic>.from(products.map((x) => x.toJson())),
      };
}

class Product {
  Product({
    this.name,
    this.voucher,
    this.subTotal,
    this.quantity,
  });

  final String name;
  final dynamic subTotal;
  final dynamic quantity;
  final List<Voucher> voucher;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        name: json["name"],
        subTotal: json["subtotal"],
        quantity: json["quantity"],
        voucher: json["voucher"] != null
            ? List<Voucher>.from(
                json["voucher"].map((x) => Voucher.fromJson(x)))
            : null,
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "subtotal": subTotal,
        "quantity": quantity,
        "voucher": List<dynamic>.from(voucher.map((x) => x.toJson())),
      };
}

class Voucher {
  Voucher({
    this.pin,
    this.serial,
    this.expires,
  });

  final String pin;
  final String serial;
  final String expires;

  factory Voucher.fromJson(Map<String, dynamic> json) => Voucher(
        pin: json["pin"],
        serial: json["serial"],
        expires: json["expires"],
      );

  Map<String, dynamic> toJson() => {
        "pin": pin,
        "serial": serial,
        "expires": expires,
      };
}
