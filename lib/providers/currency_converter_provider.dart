import 'package:e_card/models/currency_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';

class CurrencyConverterProvider with ChangeNotifier {
  CurrencyModel usd;

  String getConvertedRate({@required String rate, @required String selectedCurrency}) {
    if (selectedCurrency == "aed" && usd != null) {
      double calculated = double.parse(usd.rates["AED"].rate) * double.parse(rate.isNotEmpty ? rate : "0");
      return calculated.toStringAsFixed(2);
    } else if (selectedCurrency == "usd" && usd != null) {
      double calculated = double.parse(usd.rates["USD"].rate) * double.parse(rate.isNotEmpty ? rate : "0");
      return calculated.toStringAsFixed(2);
    } else if (selectedCurrency == "kwd" && usd != null) {
      double calculated = double.parse(usd.rates["KWD"].rate) * double.parse(rate.isNotEmpty ? rate : "0");
      return calculated.toStringAsFixed(2);
    } else if (selectedCurrency == "uk" && usd != null) {
      double calculated = double.parse(usd.rates["UK"].rate) * double.parse(rate.isNotEmpty ? rate : "0");
      return calculated.toStringAsFixed(2);
    } else if (selectedCurrency == "eu" && usd != null) {
      double calculated = double.parse(usd.rates["EU"].rate) * double.parse(rate.isNotEmpty ? rate : "0");
      return calculated.toStringAsFixed(2);
    } else if (selectedCurrency == "gcc" && usd != null) {
      double calculated = double.parse(usd.rates["GCC"].rate) * double.parse(rate.isNotEmpty ? rate : "0");
      return calculated.toStringAsFixed(2);
    } else if (selectedCurrency == "jod" && usd != null) {
      double calculated = double.parse(usd.rates["JOD"].rate) * double.parse(rate.isNotEmpty ? rate : "0");
      return calculated.toStringAsFixed(2);
    } else {
      return rate;
    }
  }

  final Map<String, String> headers = {
    "x-rapidapi-key": "e08ce7b6b3msh1afeeea3e00a602p1a21aejsn58e2a717be19",
    "x-rapidapi-host": "currency-converter5.p.rapidapi.com",
    "useQueryString": "true"
  };

  ///GET CURRENCY RATE
  Future<void> getRates() async {
    try {
      final String url = "https://currency-converter5.p.rapidapi.com/currency/convert?format=json&from=QAR&to=USD,AED,KWD&amount=1";
      Response response = await get(url, headers: headers);

      if (response.statusCode == 200) {
        print("++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++=");
        print(response.body);
        print("++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++=");
        usd = currencyModelFromJson(response.body);
      } else {
        // successToast("Server Error Currency ${response.statusCode}");
      }
    } catch (e) {
      rethrow;
    }
    notifyListeners();
  }
}
