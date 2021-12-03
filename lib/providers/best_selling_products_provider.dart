import 'dart:convert';

import 'package:e_card/models/best_selling_products_models.dart';
import 'package:e_card/utils/toast_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:woocommerce/woocommerce.dart';

class BestSellingProvider with ChangeNotifier {
  bool loading = true;
  BestSellingModel bestSellingModel;
  List<WooProduct> bestSellingProducts = [];

  Future<void> getBestSellingProducts() async {
    try {
      final String url =
          "http://ecardsstore.com/ecards/public/api/best_selling";
      Response response = await get(url);

      if (response.statusCode == 200) {
        Map data = json.decode(response.body);
        if (data["response"]) {
          bestSellingModel = bestSellingModelFromJson(response.body);
          loading = false;
        }
      } else {
        successToast(
            "Server Error /best_selling_products/ ${response.statusCode} ");
      }
    } catch (e) {
      rethrow;
    }
    notifyListeners();
  }
}
