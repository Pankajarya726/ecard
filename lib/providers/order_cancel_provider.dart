import 'dart:convert';

import 'package:e_card/providers/woocommerce_provider.dart';
import 'package:e_card/utils/toast_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

class OrderCancelProvider with ChangeNotifier {
  bool loadTop = false;
  bool loadBottom = false;

  Future<void> cancelOrder({
    @required orderID,
    @required bool from,
    @required BuildContext context,
  }) async {
    try {
      if (from) {
        loadTop = true;
        notifyListeners();
      } else {
        loadBottom = true;
        notifyListeners();
      }

      final String url =
          "http://ecardsstore.com/ecards/public/api/refund_request?order_id=$orderID";
      final Response response = await get(url);

      if (response.statusCode == 200) {
        Map data = json.decode(response.body);

        Provider.of<WoocommerceProvider>(context, listen: false)
            .getOrder()
            .then((value) {
          if (data["response"]) {
            successToast(data["message"]);
          } else {
            successToast(data["message"]);
          }
          Navigator.pop(context);
          loadTop = false;
          loadBottom = false;
        });
      } else {
        loadTop = false;
        loadBottom = false;
        successToast("Server Error refund_request ${response.statusCode}");
      }
    } catch (e) {
      rethrow;
    }

    notifyListeners();
  }
}
