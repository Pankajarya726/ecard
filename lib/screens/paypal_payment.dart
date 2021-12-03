// import 'dart:async';
// import 'dart:io';
//
// import 'package:e_card/models/cart_model.dart';
// import 'package:e_card/providers/paypal_provider.dart';
// import 'package:e_card/utils/toast_util.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:webview_flutter/webview_flutter.dart';
//
// class PaypalPayment extends StatefulWidget {
//   final String total;
//   final List<CartModel> list;
//
//   const PaypalPayment({Key key, @required this.total, @required this.list})
//       : super(key: key);
//
//   @override
//   _PaypalPaymentState createState() => _PaypalPaymentState();
// }
//
// class _PaypalPaymentState extends State<PaypalPayment> {
//   bool load = true;
//   final Completer<WebViewController> _controller =
//       Completer<WebViewController>();
//   String url = "https://www.google.com/";
//
//   String checkoutURL;
//   String executeURL;
//   String accessToken;
//
//   @override
//   void initState() {
//     PaypalProvider paypalProvider =
//         Provider.of<PaypalProvider>(context, listen: false);
//     Future.delayed(Duration(seconds: 2), () {
//       setState(() {
//         load = false;
//       });
//     });
//     if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
//     Future.delayed(Duration.zero, () async {
//       try {
//         accessToken = await paypalProvider.getToken();
//         final transactions = paypalProvider.getOrderParams(
//             cartModel: widget.list, total: widget.total);
//         print(transactions);
//         final response =
//             await paypalProvider.creatPaypalPayment(transactions, accessToken);
//
//         if (response != null) {
//           setState(() {
//             checkoutURL = response["approvalUrl"];
//             executeURL = response["executeUrl"];
//           });
//         }
//       } catch (e) {
//         print(e);
//       }
//     });
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     PaypalProvider paypalProvider =
//         Provider.of<PaypalProvider>(context, listen: false);
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Paypal"),
//       ),
//       body: checkoutURL == null
//           ? Center(
//               child: CircularProgressIndicator(),
//             )
//           : Container(
//               child: WebView(
//                 initialUrl: url.toString(),
//                 debuggingEnabled: true,
//                 onPageStarted: (v) async {
//                   if (v.contains(paypalProvider.successUrl)) {
//                     final uri = Uri.parse(v);
//                     final payerId = uri.queryParameters["PayerID"];
//                     if (payerId != null) {
//                       await paypalProvider
//                           .executePayment(executeURL, payerId, accessToken)
//                           .then((value) {
//                         print(value);
//                       });
//                     }
//                   } else {
//                     successToast("Payment Failed");
//                     Navigator.pop(context);
//                   }
//                 },
//                 javascriptMode: JavascriptMode.unrestricted,
//                 onWebViewCreated: (WebViewController webViewController) {
//                   _controller.complete(webViewController);
//                 },
//               ),
//             ),
//     );
//   }
// }
