import 'package:e_card/models/wallet_model.dart';
import 'package:e_card/utils/toast_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';

class WalletProvider with ChangeNotifier {
  bool load = true;
  WalletModel walletModel;

  makeNull() {
    walletModel = null;
    notifyListeners();
  }

  Future<void> getWalletDetails({@required String userID}) async {
    try {
      final String url =
          "http://ecardsstore.com/ecards/public/api/wallet?user_id=$userID";
      final Response response = await get(url);
      print(response.body);
      if (response.statusCode == 200) {
        walletModel = walletModelFromJson(response.body);
        load = false;
      } else {
        successToast("Server Error Wallet ${response.statusCode}");
      }
    } catch (e) {
      rethrow;
    }

    notifyListeners();
  }

  ///url -  http://ecardsstore.com/ecards/public/api/reduce_wallet
// post method
// params - user_id,amount
// response
// --------
// {
//     "response": true,
//     "balance": 4648.22
// }
  Future<void> reduceWalletAmount({
    @required String userId,
    @required String amount,
  }) async {
    try {
      final String url =
          "http://ecardsstore.com/ecards/public/api/reduce_wallet";

      final Response response = await post(url, body: {
        "user_id": userId,
        "amount": amount,
      });
      if (response.statusCode == 200) {
        print(response.body);
      } else {
        successToast("Server Error /reduce_wallet/ ${response.statusCode}");
      }
    } catch (e) {
      rethrow;
    }
  }
}
