import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart' as dio;
import 'package:e_card/models/cart_model.dart';
import 'package:e_card/models/order_model.dart';
import 'package:e_card/models/review_model.dart';
import 'package:e_card/providers/wallet_provider.dart';
import 'package:e_card/screens/order_placed.dart';
import 'package:e_card/utils/slide_route.dart';
import 'package:e_card/utils/toast_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:woocommerce/woocommerce.dart';

class WoocommerceProvider with ChangeNotifier {
  ///VARIABLES
  ///
  final String url = "https://ecardsstore.com/beta/wp-json/wc/v3/",
      consumerKey = "ck_d9b31fa60d4dffc9e8451b8489ffb427ac4af511",
      consumerSecret = "cs_7d36d2a164690c804db951e212b6bf53d56ea2cf";
  WooCommerce woocommerce = WooCommerce(
      // baseUrl: "https://auraqatar.com/projects/ecard/wordpress",
      baseUrl: "https://ecardsstore.com/beta",
      consumerKey: "ck_d9b31fa60d4dffc9e8451b8489ffb427ac4af511",
      consumerSecret: "cs_7d36d2a164690c804db951e212b6bf53d56ea2cf",
      apiPath: "/wp-json/wc/v3/",
      isDebug: true);

  ///ProductListHomeBanner
  List<WooProduct> products = [];
  List<WooProduct> productsAll = [];
  List<WooProduct> newReleases = [];

  ///Popular Product List
  List<WooProduct> popularProduct = [];
  List<WooProduct> popularProductAll = [];

  ///CategoryList
  List<WooProductCategory> productCategory = [];
  List<WooProductCategory> productCategoryAll = [];

  ///Product Loading
  bool productLoad = true;
  bool productLoadFuture = true;

  ///Category Loading
  bool categoryLoad = true;

  ///GET APP PRODUCTS
  Future<bool> getAllProducts([int index = 1]) async {
    if (index > 1) {
      productLoad = true;
      notifyListeners();
    }
    products = await woocommerce.getProducts(page: index);

    productsAll.addAll(products);
    if (newReleases.isEmpty) {
      newReleases.addAll(productsAll);
    }
    productLoad = false;
    notifyListeners();
    return productLoad;
  }

  ///GET APP PRODUCTS Future
  Future<bool> getAllProductsFuture([int index = 1]) async {
    if (index > 1) {
      productLoadFuture = true;
      notifyListeners();
    }
    popularProduct = await woocommerce.getProducts(page: index, featured: true);

    popularProductAll.addAll(popularProduct);
    productLoadFuture = false;
    notifyListeners();
    return productLoadFuture;
  }

  ///GET APP CATEGORY
  Future<bool> getCategory([int index = 1]) async {
    if (index > 1) {
      categoryLoad = true;
      notifyListeners();
    }
    productCategory = [];
    productCategory = await woocommerce.getProductCategories(page: index);

    productCategoryAll.addAll(productCategory);
    final ids = productCategoryAll.map((e) => e.id).toSet();
    productCategoryAll.retainWhere((x) => ids.remove(x.id));

    for (int i = 0; i < productCategoryAll.length; i++) {
      print(productCategoryAll[i].name);
      // print(productCategoryAll[i].image.src);
    }

    categoryLoad = false;
    notifyListeners();
    return categoryLoad;
  }

  ///GET POPULAR PRODUCTS
  Future<bool> getPopularProducts([int index = 1]) async {
    if (index > 1) {
      productLoad = true;
      notifyListeners();
    }
    products = await woocommerce.getProducts(
      page: index,
    );

    productsAll.addAll(products);
    productLoad = false;
    notifyListeners();
    return productLoad;
  }

  ///SEARCH PRODUCTS
  List<WooProduct> searchList = [];
  bool searchLoad = false;

  Future<void> searchProduct(
      String keyword, int category, double low, double high) async {
    print("################ Search ###########################");
    searchList = [];
    searchLoad = true;
    notifyListeners();
    searchList = category == 0 && low == 0.0 && high == 0.0
        ? await woocommerce.getProducts(search: keyword)
        : low == 0.0 && high == 0.0
            ? await woocommerce.getProducts(
                search: keyword,
                category: category.toString(),
              )
            : keyword.isNotEmpty
                ? await woocommerce.getProducts(
                    search: keyword,
                    category: category.toString(),
                    minPrice: low.toString(),
                    maxPrice: high.toString(),
                  )
                : await woocommerce.getProducts(
                    category: category.toString(),
                    minPrice: low.toString(),
                    maxPrice: high.toString(),
                  );
    searchList.forEach((element) {
      print(element.name);
    });
    searchLoad = false;

    notifyListeners();
  }

  ///FILTER PRODUCTS
  List<WooProduct> filterProducts = [];
  List<WooProduct> filterProductsAll = [];

  makeEmpty() {
    filterProductsAll = [];
    notifyListeners();
  }

  bool filterLoad = false;

  Future<void> filter(
      int category, double low, double high, bool price, bool short,
      [int index = 1]) async {
    print("######################$index######################");
    filterProducts = [];
    filterLoad = true;
    notifyListeners();
    if (category == 0 && low == 0.0 && high == 0.0) {
      filterProducts = await woocommerce.getProducts(
        page: index,
        order: "asc",
      );
    } else {
      if (low == 0.0 && high == 0.0) {
        filterProducts = await woocommerce.getProducts(
          page: index,
          category: category.toString(),
          order: "asc",
        );
      } else {
        filterProducts = await woocommerce.getProducts(
          page: index,
          category: category.toString(),
          minPrice: low.toString(),
          maxPrice: high.toString(),
          order: "asc",
        );
      }
    }
    filterProductsAll.addAll(filterProducts);

    filterLoad = false;

    notifyListeners();
  }

  ///SHORT ITEMS
  short(bool price) {
    if (price) {
      filterProductsAll.sort(
        (b, a) => double.parse(
          a.price.toString(),
        ).compareTo(
          double.parse(
            b.price.toString(),
          ),
        ),
      );
      notifyListeners();
    } else {
      filterProductsAll.sort(
        (a, b) => double.parse(
          a.price.toString(),
        ).compareTo(
          double.parse(
            b.price.toString(),
          ),
        ),
      );
      notifyListeners();
    }
  }

  ///CREATE NEW USER
  Future<void> createUser(
      {String userName,
      String password,
      String email,
      String confirmPassword,
      BuildContext context}) async {
    if (!email.contains("@") || !email.contains(".")) {
      successToast("Enter a valid Email");
    } else if (userName.isEmpty) {
      successToast("Enter user Name");
    } else if (password.length < 6) {
      successToast("Password need Minimum 6 Characters");
    } else if (password != confirmPassword) {
      successToast("Password and Confirm Password not Matched");
    } else {
      // WooCustomer user = WooCustomer(
      //   username: userName,
      //   password: password,
      //   email: email,
      // );
      Map userData = {
        "password": confirmPassword,
        "username": userName,
        "email": email
      };
      Map data = await woocommerce.post("customers", userData);
      bool error;
      data.forEach((key, value) {
        if (key == "message") {
          error = true;
          successToast(parseHtmlString(value));
        }
      });

      if (error == null) {
        successToast("Registration Completed");
        Navigator.pop(context);
      }
    }
  }

  String parseHtmlString(String htmlString) {
    final document = parse(htmlString);
    final String parsedString = parse(document.body.text).documentElement.text;

    return parsedString;
  }

  ///LOGIN NEW USER
  Future<void> loginUser(
      {String userName,
      String password,
      @required BuildContext context}) async {
    try {
      final String url =
          "https://ecardsstore.com/beta/wp-json/jwt-auth/v1/token";

      Response response =
          await post(url, body: {"password": password, "username": userName});

      if (response.statusCode == 200) {
        Map data = json.decode(response.body);
        if (data["statusCode"] == 200) {
          successToast("Login Successful");
          setData(
                  id: data["data"]["id"],
                  email: data["data"]["email"],
                  name: data["data"]["displayName"],
                  token: data["data"]["token"])
              .then((value) {
            getData().then((value) {
              Provider.of<WalletProvider>(context, listen: false)
                  .getWalletDetails(userID: userId.toString())
                  .then((value) {
                Navigator.pop(context);
              });
            });
          });
        } else {
          successToast("${data["message"]}");
        }
        print(response.body);
      } else {
        print(response.body);
        successToast("Server Error ${response.statusCode}");
      }
    } catch (e) {
      print(e);
    }
  }

  ///Store user Data
  Future<void> setData(
      {String name, String email, String token, int id}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString("token", token);
    prefs.setInt("id", id);
    prefs.setString("email", email);
    prefs.setString("name", name);
  }

  String token, email, name;
  int userId;
  Future<void> getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    token = prefs.getString("token");
    userId = prefs.getInt("id");
    email = prefs.getString("email");
    name = prefs.getString("name");
    notifyListeners();
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("token");
    prefs.remove("id");
    prefs.remove("email");
    prefs.remove("name");
    token = null;
    email = null;
    name = null;
    userId = null;
    notifyListeners();
  }

  ///GET PRODUCTS BY ID
  Future<WooProduct> getProduct(String id) async {
    Map data = await woocommerce.get("products/$id");

    bool error = false;
    data.forEach((key, value) {
      if (key == "data") {
        error = true;
        data[key].forEach((k, v) {
          if (v == 404) {
            successToast("Product Removed By Admin");
          }
        });
      }
    });
    WooProduct wooProduct;
    if (!error) {
      wooProduct = WooProduct.fromJson(data);
    }

    return wooProduct;
  }

  ///GET RATINGS AND REVIEWS
  List<ReviewModel> reviewModel = [];
  List<ReviewModel> reviewModelAll = [];

  bool load = true;
  bool paginationLoad = false;
  int rating = 5;
  changeRating(int rate) {
    rating = rate;
    notifyListeners();
  }

  Future<void> getReview({@required int id, @required int index}) async {
    load = true;
    paginationLoad = true;
    reviewModel = [];
    notifyListeners();
    final String fullUrl =
        "${url}products/reviews?consumer_secret=$consumerSecret&consumer_key=$consumerKey&product=$id&page=$index";

    Response response = await get(fullUrl);
    if (response.statusCode == 200) {
      print(response.body);
      reviewModel = reviewModelFromJson(response.body);
      reviewModelAll.addAll(reviewModel);
      load = false;
      paginationLoad = false;
    } else {
      load = false;
      paginationLoad = false;
      successToast("Server Error ${response.statusCode}");
    }
    notifyListeners();
  }

  ///CREATE RATING
  bool creatingLoad = false;
  Future<void> createRating(
      {@required String email,
      @required String name,
      @required String ratings,
      @required String review,
      @required String id,
      @required BuildContext context}) async {
    final String fullUrl =
        "${url}products/reviews?consumer_secret=$consumerSecret&consumer_key=$consumerKey";

    try {
      creatingLoad = true;
      notifyListeners();
      Response response = await post(fullUrl, body: {
        "product_id": id,
        "review": review,
        "reviewer": name,
        "reviewer_email": email,
        "rating": ratings,
      });

      if (response.statusCode == 200 || response.statusCode == 201) {
        print(response.body);

        load = true;
        reviewModelAll = [];
        notifyListeners();
        getReview(id: int.parse(id), index: 1).then((value) {
          creatingLoad = false;
        }).then((value) {
          Navigator.pop(context);
        });
      } else {
        creatingLoad = false;
        successToast("Server Error ${response.statusCode}");
      }
    } catch (e) {
      print(e);
    }

    notifyListeners();
  }

  ///CART QUANTITY UPDATE
  int cartQuantity = 0;
  changeQuantity(int qua) {
    cartQuantity = qua;
    print("###################  $qua   #################################");
    notifyListeners();
  }

  ///Place Order
  bool orderPlace = false;

  change(bool v) {
    orderPlace = v;
    notifyListeners();
  }

  Future<void> createOrder(
      {@required Map billingAddress,
      @required String total,
      @required List<CartModel> list,
      String transactionId = "",
      @required BuildContext context,
      @required String paymentType}) async {
    orderPlace = true;
    notifyListeners();
    var authToken =
        base64.encode(utf8.encode(consumerKey + ":" + consumerSecret));

    final String fullUrl = "${url}orders";
    Map<String, dynamic> data = {
      "payment_method": paymentType,
      "payment_method_title": paymentType,
      "set_paid": true,
      "transaction_id": transactionId,
      "customer_id": userId,
      "billing": billingAddress,
      "shipping": billingAddress,
      "line_items": List.generate(
        list.length,
        (index) => {
          "product_id": list[index].id,
          "quantity": list[index].quantity,
        },
      ),
      "shipping_lines": [
        {
          "method_id": "flat_rate",
          "method_title": "Flat Rate",
          "total": "0",
        }
      ]
    };

    dio.Response response = await dio.Dio().post(fullUrl,
        data: json.encode(data),
        options: dio.Options(headers: {
          HttpHeaders.authorizationHeader: "Basic $authToken",
          HttpHeaders.contentTypeHeader: "application/json"
        }));

    if (response.statusCode == 201) {
      print(response.data);
      Hive.box<CartModel>("cart").clear();
      Map data = response.data;
      Navigator.push(
        context,
        SlideRightRoute(
          page: OrderPlaced(
            id: data["id"].toString(),
          ),
        ),
      );
      orderPlace = false;
    } else {
      orderPlace = false;
      print(response.data);
      successToast("Server Error ${response.statusCode}");
    }
    notifyListeners();
  }

  ///CHANGE ORDER PLACE
  void changeOrderPlace() {
    orderPlace = true;
    notifyListeners();
  }

  ///GET ORDER BY USER
  List<OrderModel> orderList = [];
  bool orderLoad = true;
  Future<void> getOrder() async {
    try {
      final String fullUrl =
          "${url}orders?consumer_secret=$consumerSecret&consumer_key=$consumerKey&customer=$userId";
      print(fullUrl);
      Response response = await get(fullUrl);

      if (response.statusCode == 200) {
        print(response.body);
        orderList = orderModelFromJson(response.body);
        orderLoad = false;
      } else {
        print(response.body);
        orderLoad = false;
      }
    } catch (e) {
      rethrow;
    }
    notifyListeners();
  }
}
