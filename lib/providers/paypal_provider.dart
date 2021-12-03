import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:e_card/models/cart_model.dart';
import 'package:e_card/utils/const_values.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class PaypalProvider with ChangeNotifier {
  final String clintID = ConstValues.paypalClintID;
  final String secretKey = ConstValues.paypalSecretKey;
  final String url = ConstValues.paypalUrl;

  final String successUrl = "success.capcee.com";
  final String cancelUrl = "cancel.capcee.com";

  ///GET PAYMENT TOKEN
  Future<String> getToken() async {
    try {
      var authToken = base64.encode(utf8.encode(clintID + ":" + secretKey));

      // final response = await Dio().post("$url/v1/oauth2/token",
      //     options: Options(headers: {
      //       "Authorization": 'Basic $authToken',
      //       "Content-Type": "application/x-www-form-urlencoded",
      //     }),
      //     data: {"grand_type": "client_credentials"});
      // print(response.data);
      // if (response.statusCode == 200) {
      //   print(response.data);
      //   final body = response.data;
      //   return body["access_token"];
      // }
      var headers = {
        'Authorization': 'Basic $authToken',
        'Content-Type': 'application/x-www-form-urlencoded'
      };
      var request = http.Request('POST',
          Uri.parse('https://api-m.sandbox.paypal.com/v1/oauth2/token'));
      request.bodyFields = {'grant_type': 'client_credentials'};
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        // print(await response.stream.bytesToString());

        String data = await response.stream.bytesToString();
        final body = json.decode(data);
        print(body);
        return body["access_token"];
      } else {
        print(response.reasonPhrase);
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  ///Currency
  Map<dynamic, dynamic> defaultCurrency = {
    "symbol": "INR ",
    "decimalDigit": 2,
    "symbolBeforeTheNumber": true,
    "currency": "INR"
  };

  Map<dynamic, dynamic> getOrderParams(
      {@required List<CartModel> cartModel, @required String total}) {
    print("############################");
    List item = [];
    cartModel.forEach((element) {
      item.add({
        "name": element.name,
        "quantity": element.quantity,
        "price": element.price,
        "currency": defaultCurrency["currency"]
      });
    });
    print(item);

    String totalAmount = total;
    String subTotalAmount = total;
    String shippingCost = "0";
    int shippingDiscountCost = 0;

    Map temp = {
      "intent": "sale",
      "payer": {"payment_method": "paypal"},
      "transactions": [
        {
          "amount": {
            "total": totalAmount,
            "currency": defaultCurrency["currency"],
            "details": {
              "subtotal": subTotalAmount,
              "shipping": shippingCost,
              "shipping_discount": shippingDiscountCost.toString(),
            }
          },
          "description": "The payment transaction description",
          "payment_options": {
            "allowed_payment_method": "INSTANT_FUNDING_SOURCE"
          },
          "item_list": {
            "items": item,
          }
        },
      ],
      "note_to_payer": "Contact us for any questions on your order.",
      "redirect_urls": {"return_url": successUrl, "cancel_url": cancelUrl}
    };
    print("############################");
    print(temp);
    return temp;
  }

  ///GET PAYMENT URL
  Future<Map<String, dynamic>> creatPaypalPayment(
      transaction, accessToken) async {
    try {
      print("################&&&&&&&&&&&&&&&&&&&&&&############");
      String data = json.encode(transaction);
      var response = await Dio().post(
        "${ConstValues.paypalUrl}/vi/payments/payment",
        data: data,
        options: Options(headers: {
          "Authorization": "Bearer $accessToken",
          "Content-Type": "application/json",
        }),
      );
      print(response.statusCode);

      final body = response.data;
      print(body);
      if (response.statusCode == 201) {
        if (body["links"] != null && body["links"].lenght > 0) {
          List link = body["links"];
          String executeUrl = "";
          String approvalUrl = "";

          final item = link.firstWhere((o) => o["rel"] == "approval_url",
              orElse: () => null);
          if (item != null) {
            approvalUrl = item["href"];
          }
          final item1 =
              link.firstWhere((o) => o["rel"] == "execute", orElse: () => null);
          if (item1 != null) {
            executeUrl = item1["href"];
          }

          return {"executeUrl": executeUrl, "approvalUrl": approvalUrl};
        }
        return null;
      } else {
        throw Exception(body["message"]);
      }
    } catch (e) {
      rethrow;
    }
  }

  ///Execute Payment
  Future<String> executePayment(url, payerId, accessToken) async {
    try {
      var response = await Dio().post(url,
          data: json.encode({"payer_id": payerId}),
          options: Options(headers: {
            HttpHeaders.authorizationHeader: "Bearer $accessToken",
            HttpHeaders.contentTypeHeader: "application/json"
          }));

      final body = response.data;
      if (response.statusCode == 200) {
        return body["id"];
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  //
  // Future<Map<dynamic,dynamic>> getUrl()async{
  //   var authToken = base64.encode(utf8.encode(clintID + ":" + secretKey));
  // }

}
