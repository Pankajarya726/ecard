import 'package:e_card/models/order_details_model.dart';
import 'package:e_card/utils/toast_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';

class OrderDetailsProvider with ChangeNotifier {
  bool load = true;
  OrderDetailsModel orderDetailsModel;

  makeLoad() {
    load = true;
    notifyListeners();
  }

  Future<void> getOrderDetails({@required String orderId}) async {
    try {
      final String url =
          "http://ecardsstore.com/ecards/public/api/order_detail?order_id=$orderId";

      Response response = await get(url);

      print(response.body);
      if (response.statusCode == 200) {
        orderDetailsModel = orderDetailsModelFromJson(response.body);
        load = false;
      } else {
        successToast("server Error /order_detail/ ${response.statusCode}");
      }
    } catch (e) {
      rethrow;
    }
    notifyListeners();
  }
}
