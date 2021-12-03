import 'package:e_card/providers/curency_switch_provider.dart';
import 'package:e_card/providers/filter_provider.dart';
import 'package:e_card/providers/woocommerce_provider.dart';
import 'package:e_card/screens/home.dart';
import 'package:e_card/utils/text_style.dart';
import 'package:e_card/widgets/background_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Filter extends StatefulWidget {
  final bool from;
  final bool price;

  const Filter({Key key, @required this.from, @required this.price})
      : super(key: key);
  @override
  _FilterState createState() => _FilterState();
}

class _FilterState extends State<Filter> {
  RangeValues _currentRangeValues = RangeValues(0, 1000);
  int selectedId = 0;
  bool load = false;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BackgroundImage(),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Filter Products",
                        style: TextStylePage.headingHome,
                      ),
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(
                            Icons.close,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(0xff39103E),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: ListView(
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Text(
                                "CATEGORY",
                                style: TextStylePage.productName,
                              )
                            ],
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Consumer<WoocommerceProvider>(
                              builder: (context, snapshot, _) {
                            return ListView.builder(
                              itemBuilder: (ctx, i) {
                                return FilterTile(
                                  name:
                                      "${snapshot.productCategoryAll[i].name}",
                                  id: snapshot.productCategoryAll[i].id,
                                );
                              },
                              itemCount: snapshot.productCategoryAll.length,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                            );
                          }),
                          CustomDivider2(),
                          Consumer<CurrencySwitchProvider>(
                              builder: (context, snapshot, _) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "MIN ${snapshot.currencyName.toUpperCase()}",
                                      style: TextStylePage.headingHomeBold15,
                                    ),
                                    const SizedBox(
                                      height: 4,
                                    ),
                                    Container(
                                      height: 35,
                                      width: 100,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(4),
                                        border: Border.all(
                                            color: Colors.grey.shade700),
                                        color: Colors.white.withOpacity(0.10),
                                      ),
                                      child: Center(
                                        child: Text(
                                          "${_currentRangeValues.start}",
                                          style: TextStylePage.headingHome15,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Expanded(
                                  child: Container(
                                    height: 35,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          "Price Range",
                                          style: TextStylePage.headingHome15,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "MAX ${snapshot.currencyName.toUpperCase()}",
                                      style: TextStylePage.headingHomeBold15,
                                    ),
                                    const SizedBox(
                                      height: 4,
                                    ),
                                    Container(
                                      height: 35,
                                      width: 100,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(4),
                                        border: Border.all(
                                            color: Colors.grey.shade700),
                                        color: Colors.white.withOpacity(0.10),
                                      ),
                                      child: Center(
                                        child: Text(
                                          "${_currentRangeValues.end}+",
                                          style: TextStylePage.headingHome15,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            );
                          }),
                          SizedBox(
                            height: 20,
                          ),
                          RangeSlider(
                            values: _currentRangeValues,
                            min: 0,
                            max: 1000,
                            divisions: 10,
                            onChanged: (RangeValues values) {
                              setState(() {
                                _currentRangeValues = values;
                              });
                            },
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          CustomDivider2(),
                          Padding(
                            padding: const EdgeInsets.all(25.0),
                            child: Container(
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
                              child: load
                                  ? Center(
                                      child: CircularProgressIndicator(),
                                    )
                                  : Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            load = true;
                                          });

                                          if (widget.from) {
                                            Provider.of<FilterProvider>(context,
                                                    listen: false)
                                                .changeLowAndHigh(
                                                    highValue:
                                                        _currentRangeValues.end,
                                                    lowValue:
                                                        _currentRangeValues
                                                            .start);
                                            FilterProvider filter =
                                                Provider.of<FilterProvider>(
                                                    context,
                                                    listen: false);
                                            filter.keyword = "";
                                            Provider.of<WoocommerceProvider>(
                                                    context,
                                                    listen: false)
                                                .makeEmpty();
                                            Provider.of<WoocommerceProvider>(
                                                    context,
                                                    listen: false)
                                                .filter(
                                                    filter.selectedID,
                                                    filter.low,
                                                    filter.high,
                                                    widget.price,
                                                    false)
                                                .then((value) {
                                              setState(() {
                                                load = false;
                                              });
                                              Navigator.pop(context);
                                            });
                                          } else {
                                            Provider.of<FilterProvider>(context,
                                                    listen: false)
                                                .changeLowAndHigh(
                                                    highValue:
                                                        _currentRangeValues.end,
                                                    lowValue:
                                                        _currentRangeValues
                                                            .start);

                                            FilterProvider filter =
                                                Provider.of<FilterProvider>(
                                                    context,
                                                    listen: false);
                                            filter.keyword = "";
                                            Provider.of<WoocommerceProvider>(
                                                    context,
                                                    listen: false)
                                                .searchProduct(
                                                    filter.keyword,
                                                    filter.selectedID,
                                                    filter.low,
                                                    filter.high)
                                                .then((value) {
                                              setState(() {
                                                load = false;
                                              });
                                              Navigator.pop(context);
                                            });
                                          }
                                        },
                                        child: Center(
                                          child: Text(
                                            "APPLY CHANGES",
                                            style:
                                                TextStylePage.headingHomeBold,
                                          ),
                                        ),
                                      ),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class FilterTile extends StatelessWidget {
  final String name;
  final int id;

  const FilterTile({
    Key key,
    this.name,
    this.id,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<FilterProvider>(builder: (context, snapshot, _) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "$name",
            style: TextStylePage.headingHomeBold15,
          ),
          Radio(
            value: id,
            groupValue: snapshot.selectedID,
            activeColor: Colors.white,
            focusColor: Colors.white,
            onChanged: (v) {
              snapshot.changeID(id);
            },
          ),
        ],
      );
    });
  }
}
