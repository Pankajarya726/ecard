import 'package:e_card/models/cart_model.dart';
import 'package:e_card/providers/curency_switch_provider.dart';
import 'package:e_card/providers/currency_converter_provider.dart';
import 'package:e_card/providers/wallet_provider.dart';
import 'package:e_card/providers/woocommerce_provider.dart';
import 'package:e_card/screens/paypal_view.dart';
import 'package:e_card/utils/colors_data.dart';
import 'package:e_card/utils/text_style.dart';
import 'package:e_card/utils/toast_util.dart';
import 'package:e_card/widgets/background_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class Payment extends StatefulWidget {
  final Map<String, String> billingAddress;
  final String total;
  final List<CartModel> list;

  const Payment(
      {Key key,
      @required this.billingAddress,
      @required this.total,
      @required this.list})
      : super(key: key);

  @override
  _PaymentState createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  bool check = false;

  @override
  void initState() {
    Future.delayed(Duration(milliseconds: 20), () {
      Provider.of<WoocommerceProvider>(context, listen: false).change(false);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    WalletProvider walletProvider = Provider.of<WalletProvider>(context);
    return Stack(
      children: [
        BackgroundImage(),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Text(
              "Payment",
              style: GoogleFonts.poppins(),
            ),
          ),
          body: Container(
            decoration: BoxDecoration(
              color: Color(0xff0f0211),
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(50),
                topLeft: Radius.circular(50),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 15, right: 15, top: 25),
              child: ListView(
                children: [
                  SizedBox(
                    height: 25,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Text(
                      "Amount to be Paid",
                      style: TextStylePage.productName,
                    ),
                  ),
                  Consumer<CurrencySwitchProvider>(
                      builder: (context, snapshot, _) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Text(
                        "${Provider.of<CurrencyConverterProvider>(context, listen: false).getConvertedRate(rate: widget.total.toString(), selectedCurrency: snapshot.currencyName)} ${snapshot.currencyName.toUpperCase()}",
                        style: TextStylePage.headingHomeBig,
                      ),
                    );
                  }),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Theme(
                        data: ThemeData(
                            unselectedWidgetColor: Colors.white,
                            primaryColor: ColorsData.textFieldColor),
                        child: Checkbox(
                            activeColor: ColorsData.textFieldColor,
                            value: check,
                            onChanged: (v) {
                              setState(() {
                                check = v;
                              });
                            }),
                      ),
                      Consumer<WalletProvider>(
                          builder: (context, walletData, _) {
                        return Consumer<CurrencyConverterProvider>(
                            builder: (context, currency, _) {
                          return Consumer<CurrencySwitchProvider>(
                              builder: (context, snapshot, _) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "Wallet".toUpperCase(),
                                  style: TextStylePage.headingHomeBig18,
                                ),
                                Text(
                                  "${snapshot.currencyName.toUpperCase()} ${currency.getConvertedRate(rate: walletData.walletModel.data.balance.toString(), selectedCurrency: snapshot.currencyName)}"
                                      .toUpperCase(),
                                  style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600),
                                )
                              ],
                            );
                          });
                        });
                      }),
                    ],
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Consumer<WoocommerceProvider>(
                      builder: (context, snapshot, _) {
                    return Padding(
                      padding: const EdgeInsets.all(25.0),
                      child: snapshot.orderPlace
                          ? Center(child: CircularProgressIndicator())
                          : Container(
                              width: MediaQuery.of(context).size.width * 0.85,
                              height: 55,
                              decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                      colors: [
                                        Color(0xFF0FA3E4),
                                        Color(0xFF841981),
                                      ],
                                      begin: FractionalOffset(0.0, 0.0),
                                      end: FractionalOffset(1.0, 0.0),
                                      stops: [0.0, 1.0]),
                                  borderRadius: BorderRadius.circular(100)),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () async {
                                    if (check &&
                                        double.parse(widget.total) <=
                                            double.parse(walletProvider
                                                .walletModel.data.balance
                                                .toString())) {
                                      Future.delayed(Duration(microseconds: 20),
                                          () {
                                        snapshot.changeOrderPlace();
                                        walletProvider
                                            .reduceWalletAmount(
                                                userId:
                                                    snapshot.userId.toString(),
                                                amount: widget.total)
                                            .then((value) {
                                          snapshot.createOrder(
                                              billingAddress:
                                                  widget.billingAddress,
                                              total: widget.total,
                                              list: widget.list,
                                              paymentType: "Wallet",
                                              context: context);
                                        });
                                      });
                                    } else if (check &&
                                        double.parse(widget.total) >
                                            double.parse(
                                              walletProvider
                                                  .walletModel.data.balance
                                                  .toString(),
                                            )) {
                                      double balance =
                                          double.parse(widget.total) -
                                              double.parse(
                                                walletProvider
                                                    .walletModel.data.balance
                                                    .toString(),
                                              );

                                      // final String clintToken =
                                      //     await Provider.of<BraintreeProvider>(
                                      //             context,
                                      //             listen: false)
                                      //         .getClintToken(context);

                                      // var request = BraintreeDropInRequest(
                                      //   clientToken: clintToken,
                                      //   tokenizationKey:
                                      //       'sandbox_pgkx6xzk_qyh7mzvj9k82d42b',
                                      //   collectDeviceData: true,
                                      //   cardEnabled: false,
                                      //   paypalRequest: BraintreePayPalRequest(
                                      //     amount:
                                      //         "${Provider.of<CurrencyConverterProvider>(context, listen: false).getConvertedRate(rate: balance.toString(), selectedCurrency: "usd")}",
                                      //     displayName: "E Cards",
                                      //     currencyCode: "USD",
                                      //   ),
                                      // );

                                      // BraintreeDropInResult response =
                                      //     await BraintreeDropIn.start(request);
                                      // if (response != null) {
                                      if (1 == 1) {
                                        //
                                        // Provider.of<BraintreeProvider>(context,
                                        //         listen: false)
                                        //     .createTransaction(
                                        //         amount:
                                        //             "${Provider.of<CurrencyConverterProvider>(context, listen: false).getConvertedRate(rate: balance.toString(), selectedCurrency: "usd")}",
                                        //         nonce: response
                                        //             .paymentMethodNonce.nonce,
                                        //         device: response.deviceData,
                                        //         context: context)
                                        Navigator.of(context)
                                            .push(
                                          MaterialPageRoute(
                                            builder: (BuildContext ctx) =>
                                                PaypalPayment(
                                              amount:
                                                  "${Provider.of<CurrencyConverterProvider>(context, listen: false).getConvertedRate(rate: balance.toString(), selectedCurrency: "usd")}",
                                              onFinish: (number) async {
                                                if (number != null) {
                                                  // payment done
                                                  print(
                                                      "&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&");
                                                  print('order id: ' + number);
                                                  print(
                                                      "&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&");
                                                  Future.delayed(
                                                      Duration(
                                                          microseconds: 20),
                                                      () {
                                                    snapshot.changeOrderPlace();
                                                    walletProvider
                                                        .reduceWalletAmount(
                                                            userId: snapshot
                                                                .userId
                                                                .toString(),
                                                            amount:
                                                                walletProvider
                                                                    .walletModel
                                                                    .data
                                                                    .balance
                                                                    .toString())
                                                        .then((value) {
                                                      snapshot.createOrder(
                                                          billingAddress: widget
                                                              .billingAddress,
                                                          total: widget.total,
                                                          list: widget.list,
                                                          transactionId: number,
                                                          paymentType:
                                                              "Wallet & Paypal",
                                                          context: context);
                                                    });
                                                  });
                                                } else {
                                                  successToast(
                                                      "Payment Failed");
                                                }
                                              },
                                            ),
                                          ),
                                        )
                                            .then((value) {
                                          // if (value) {
                                          //   Future.delayed(
                                          //       Duration(microseconds: 20), () {
                                          //     snapshot.changeOrderPlace();
                                          //     walletProvider
                                          //         .reduceWalletAmount(
                                          //             userId: snapshot.userId
                                          //                 .toString(),
                                          //             amount: walletProvider
                                          //                 .walletModel
                                          //                 .data
                                          //                 .balance
                                          //                 .toString())
                                          //         .then((value) {
                                          //       snapshot.createOrder(
                                          //           billingAddress:
                                          //               widget.billingAddress,
                                          //           total: widget.total,
                                          //           list: widget.list,
                                          //           transactionId:
                                          //               "response.paymentMethodNonce.nonce",
                                          //           paymentType:
                                          //               "Wallet & Paypal",
                                          //           context: context);
                                          //     });
                                          //   });
                                          // }
                                        });
                                      } else {
                                        successToast("Payment Canceled");
                                      }
                                    } else {
                                      // final String clintToken =
                                      //     await Provider.of<BraintreeProvider>(
                                      //             context,
                                      //             listen: false)
                                      //         .getClintToken(context);
                                      //
                                      // var request = BraintreeDropInRequest(
                                      //   clientToken: clintToken,
                                      //   tokenizationKey:
                                      //       'sandbox_pgkx6xzk_qyh7mzvj9k82d42b',
                                      //   collectDeviceData: true,
                                      //   cardEnabled: false,
                                      //   paypalRequest: BraintreePayPalRequest(
                                      //     amount:
                                      //         "${Provider.of<CurrencyConverterProvider>(context, listen: false).getConvertedRate(rate: widget.total.toString(), selectedCurrency: "usd")}",
                                      //     displayName: "E Cards",
                                      //     currencyCode: "USD",
                                      //   ),
                                      // );
                                      //
                                      // BraintreeDropInResult response =
                                      //     await BraintreeDropIn.start(request);
                                      // if (response != null) {
                                      //   print(response
                                      //       .paymentMethodNonce.description);
                                      //   print(
                                      //       response.paymentMethodNonce.nonce);
                                      //   print(response
                                      //       .paymentMethodNonce.typeLabel);
                                      //
                                      //   Provider.of<BraintreeProvider>(context,
                                      //           listen: false)
                                      //       .createTransaction(
                                      //           amount:
                                      //               "${Provider.of<CurrencyConverterProvider>(context, listen: false).getConvertedRate(rate: widget.total.toString(), selectedCurrency: "usd")}",
                                      //           nonce: response
                                      //               .paymentMethodNonce.nonce,
                                      //           device: response.deviceData,
                                      //           context: context)
                                      //       .then((value) {
                                      //     if (value) {
                                      //       Future.delayed(
                                      //           Duration(microseconds: 20), () {
                                      //         snapshot.changeOrderPlace();
                                      //         snapshot.createOrder(
                                      //             billingAddress:
                                      //                 widget.billingAddress,
                                      //             total: widget.total,
                                      //             list: widget.list,
                                      //             transactionId: response
                                      //                 .paymentMethodNonce.nonce,
                                      //             paymentType: "Paypal",
                                      //             context: context);
                                      //       });
                                      //     }
                                      //   });
                                      // } else {
                                      //   successToast("Payment Canceled");
                                      // }

                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (BuildContext ctx) =>
                                              PaypalPayment(
                                            amount:
                                                "${Provider.of<CurrencyConverterProvider>(context, listen: false).getConvertedRate(rate: widget.total, selectedCurrency: "usd")}",
                                            onFinish: (number) async {
                                              if (number != null) {
                                                // payment done
                                                print(
                                                    "&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&");
                                                print('order id: ' + number);
                                                print(
                                                    "&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&");
                                                Future.delayed(
                                                    Duration(microseconds: 20),
                                                    () {
                                                  snapshot.changeOrderPlace();

                                                  snapshot.createOrder(
                                                      billingAddress:
                                                          widget.billingAddress,
                                                      total: widget.total,
                                                      list: widget.list,
                                                      transactionId: number,
                                                      paymentType: "Paypal",
                                                      context: context);
                                                });
                                              } else {
                                                successToast("Payment Failed");
                                              }
                                            },
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                  child: Center(
                                    child: Text(
                                      "PAY ONLINE",
                                      style: TextStylePage.headingHomeBold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                    );
                  }),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
