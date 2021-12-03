import 'dart:convert';

import 'package:e_card/providers/woocommerce_provider.dart';
import 'package:e_card/utils/toast_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

class BraintreeProvider with ChangeNotifier {
  Future<String> getClintToken(BuildContext context) async {
    Provider.of<WoocommerceProvider>(context, listen: false).change(true);
    final String url =
        "https://ecardsstore.com/braintree_laravel/public/api/token";

    try {
      Response response = await get(url);

      if (response.statusCode == 200) {
        Provider.of<WoocommerceProvider>(context, listen: false).change(false);
        Map data = json.decode(response.body);
        return data["data"];
      } else {
        Provider.of<WoocommerceProvider>(context, listen: false).change(false);
        successToast("Server Error ${response.statusCode}");
        return null;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> createTransaction(
      {@required String amount,
      @required String nonce,
      @required String device,
      @required BuildContext context}) async {
    bool transaction = false;
    try {
      Provider.of<WoocommerceProvider>(context, listen: false).change(true);
      final String url =
          "https://ecardsstore.com/braintree_laravel/public/api/payment";

      Response response = await post(url, body: {
        "amount": amount,
        "nonce_client": nonce,
        "device_data": device
      });
      if (response.statusCode == 200) {
        Map data = json.decode(response.body);
        print("+++++++++++++++++++++++++++++++++++++");
        print(data);
        print("+++++++++++++++++++++++++++++++++++++");
        if (data["response"] &&
            data["data"]["success"] != null &&
            data["data"]["success"]) {
          transaction = true;
        } else {
          Provider.of<WoocommerceProvider>(context, listen: false)
              .change(false);
          successToast("Payment Failed");
        }
        print(response.body);
        print(response.statusCode);
      } else {
        Provider.of<WoocommerceProvider>(context, listen: false).change(false);
        successToast("Payment Failed");
        print(response.body);
        print(response.statusCode);
      }
    } catch (e) {
      rethrow;
    }
    return transaction;
  }
}
