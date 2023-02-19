// ignore_for_file: unrelated_type_equality_checks, prefer_const_constructors, non_constant_identifier_names, unused_local_variable, no_leading_underscores_for_local_identifiers

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart' hide Trans;
import 'package:provider/provider.dart';
import 'package:single_ecommerce/common%20class/icons.dart';
import 'package:single_ecommerce/model/cart/ordersummaryModel.dart';
import 'package:single_ecommerce/model/cart/qtyupdatemodel.dart';
import 'package:single_ecommerce/model/cart/cartlistmodel.dart';
import 'package:single_ecommerce/model/cart/isopenclose.dart';
import 'package:single_ecommerce/model/settings/changepasswordmodel.dart';
import 'package:single_ecommerce/pages/cart/addonslist.dart';
import 'package:single_ecommerce/theme/thememodel.dart';
import 'package:single_ecommerce/widgets/loader.dart';
import 'package:single_ecommerce/common%20class/allformater.dart';
import 'package:single_ecommerce/common%20class/color.dart';
import 'package:single_ecommerce/common%20class/height.dart';
import 'package:single_ecommerce/common%20class/prefs_name.dart';
import 'package:single_ecommerce/config/api/api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:single_ecommerce/pages/Home/Homepage.dart';
import 'package:single_ecommerce/translation/locale_keys.g.dart';
import 'package:sizer/sizer.dart';
import 'ordersummary.dart';

class Viewcart extends StatefulWidget {
  const Viewcart({Key? key}) : super(key: key);

  @override
  State<Viewcart> createState() => _ViewcartState();
}

class _ViewcartState extends State<Viewcart> {
  int showbutton = 0;
  order_summary_model? cartdata;
  String? currency;
  String? currency_position;
  String? userid;
  cartcount count = Get.put(cartcount());

  cartlistAPI(type) async {
    type == 1 ? loader.showLoading() : null;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userid = prefs.getString(UD_user_id);
    currency = (prefs.getString(APPcurrency) ?? "");
    currency_position = (prefs.getString(APPcurrency_position) ?? "");

    try {
      var map = {"user_id": userid};

      var response =
          await Dio().post(DefaultApi.appUrl + PostAPI.Summary, data: map);
      var finalist = await response.data;

      cartdata = order_summary_model.fromJson(finalist);
      count.cartcountnumber(cartdata!.data!.length);
      type == 1 ? loader.hideLoading() : null;
      return cartdata!.data;
    } catch (e) {
      rethrow;
    }
  }

  changeQTYAPI(cartid, type) async {
    try {
      loader.showLoading();
      var map = {
        "user_id": userid.toString(),
        "cart_id": cartid.toString(),
        "type": type,
      };
      print(map);
      var response =
          await Dio().post(DefaultApi.appUrl + PostAPI.Qtyupdate, data: map);
      print(response);
      var finallist = await response.data;
      var QTYdata = QTYupdatemodel.fromJson(finallist);
      loader.hideLoading();
      if (QTYdata.status == 1) {
        setState(() {
          cartlistAPI(1);
          // cartdata.data.removeAt(index)
        });
      } else {
        loader.showErroDialog(
          description: QTYdata.message,
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  deleteitem(cartid, index) async {
    loader.showLoading();
    try {
      var map = {"cart_id": cartid};
      print(map);

      var response = await Dio()
          .post(DefaultApi.appUrl + PostAPI.Deletecartitem, data: map);
      var data = changepasswordmodel.fromJson(response.data);
      setState(() {
        cartdata!.data!.removeAt(index);
      });
      loader.hideLoading();
    } catch (e) {
      rethrow;
    }
  }

  isopencloseMODEL? isopendata;
  isopenAPI() async {
    loader.showLoading();
    var map = {
      "user_id": userid,
    };

    var response = await Dio().post(
      DefaultApi.appUrl + PostAPI.isopenclose,
      data: map,
    );
    isopendata = isopencloseMODEL.fromJson(response.data);
    loader.hideLoading();
    if (isopendata!.status == 1) {
      if (isopendata!.isCartEmpty == "0") {
        Get.to(() => Ordersummary("1"));
      } else {
        Get.to(() => Homepage(0));
      }
    } else {
      loader.showErroDialog(description: isopendata!.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ThemeModel themenofier, child) {
        return SafeArea(
            child: FutureBuilder(
          future: cartlistAPI(0),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Scaffold(
                body: Center(
                  child: CircularProgressIndicator(
                    color: color.primarycolor,
                  ),
                ),
              );
            } else if (cartdata!.data!.isEmpty) {
              return Scaffold(
                body: Center(
                  child: Text(
                    LocaleKeys.No_data_found.tr(),
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 11.sp,
                        color: Colors.grey),
                  ),
                ),
              );
            }
            return Scaffold(
                backgroundColor: Colors.transparent,
                appBar: AppBar(
                  leadingWidth: 40,
                  elevation: 0,
                  centerTitle: true,
                  title: Text(
                    LocaleKeys.Mycart.tr(),
                    style: TextStyle(
                      fontSize: 12.5.sp,
                      fontFamily: 'Poppins_semibold',
                    ),
                  ),
                  automaticallyImplyLeading: false,
                ),
                body: Padding(
                  padding: EdgeInsets.only(bottom: 6.5.h),
                  child: ListView.builder(
                    itemCount: cartdata!.data!.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: EdgeInsets.only(
                          top: 1.h,
                          left: 1.5.h,
                          right: 1.5.h,
                          bottom: 1.h,
                        ),
                        height: 15.5.h,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(7),
                            border: Border.all(
                              color: Colors.grey,
                              width: 0.8.sp,
                            )),
                        child: Row(children: [
                          SizedBox(
                            width: 28.w,
                            height: 15.5.h,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(7),
                              child: Image.network(
                                cartdata!.data![index].itemImage.toString(),
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(
                                right: 2.w,
                                left: 2.w,
                                bottom: 0.8.h,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Row(
                                      children: [
                                        if (cartdata!.data![index].itemType ==
                                            "1") ...[
                                          SizedBox(
                                            height: 2.h,
                                            // color: Colors.black,
                                            child: Image.asset(
                                              Defaulticon.vegicon,
                                            ),
                                          ),
                                        ] else if (cartdata!
                                                .data![index].itemType ==
                                            "2") ...[
                                          SizedBox(
                                            height: 2.h,
                                            // color: Colors.black,
                                            child: Image.asset(
                                              Defaulticon.nonvegicon,
                                            ),
                                          ),
                                        ],
                                        SizedBox(
                                          width: 2.w,
                                        ),
                                        SizedBox(
                                          width: 42.w,
                                          child: Text(
                                            cartdata!.data![index].itemName
                                                .toString(),
                                            maxLines: 1,
                                            softWrap: true,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 11.sp,
                                              fontFamily: 'Poppins_semibold',
                                            ),
                                          ),
                                        ),
                                        Spacer(),
                                        InkWell(
                                          onTap: () {
                                            deleteitem(
                                                cartdata!.data![index].id
                                                    .toString(),
                                                index);
                                          },
                                          child: SvgPicture.asset(
                                            'Assets/svgicon/delete.svg',
                                            color: themenofier.isdark
                                                ? Colors.white
                                                : null,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (cartdata!.data![index].variation ==
                                      "") ...[
                                    Expanded(
                                      child: Text(
                                        "-",
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 9.sp,
                                          // color: Colors.grey,
                                          fontFamily: 'Poppins',
                                        ),
                                      ),
                                    ),
                                  ] else ...[
                                    Expanded(
                                      child: Text(
                                        cartdata!.data![index].variation
                                            .toString(),
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 9.sp,
                                          color: Colors.grey,
                                          fontFamily: 'Poppins',
                                        ),
                                      ),
                                    ),
                                  ],
                                  if (cartdata!.data![index].addonsName ==
                                      "") ...[
                                    Expanded(
                                      child: Text(
                                        "-",
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 9.sp,
                                          fontFamily: 'Poppins',
                                        ),
                                      ),
                                    ),
                                  ] else ...[
                                    Expanded(
                                      child: InkWell(
                                        onTap: () {
                                          modelsheet(
                                              context,
                                              cartdata!.data![index].addonsName,
                                              cartdata!
                                                  .data![index].addonsPrice,
                                              currency,
                                              currency_position);
                                        },
                                        child: Text(
                                          "${LocaleKeys.Add_ons.tr()}>>",
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 9.sp,
                                            color: Colors.grey,
                                            fontFamily: 'Poppins',
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                  Padding(
                                    padding: EdgeInsets.only(top: 0),
                                    child: Row(children: [
                                      SizedBox(
                                        child: Text(
                                          currency_position == "1"
                                              ? "$currency${(numberFormat.format(double.parse(cartdata!.data![index].totalPrice!.toString())))}"
                                              : "${(numberFormat.format(double.parse(cartdata!.data![index].totalPrice!.toString())))}$currency",
                                          style: TextStyle(
                                            fontSize: 12.sp,
                                            fontFamily: 'Poppins_semibold',
                                          ),
                                        ),
                                      ),
                                      Spacer(),
                                      Container(
                                        height: 3.6.h,
                                        width:
                                            MediaQuery.of(context).size.width /
                                                4,
                                        decoration: BoxDecoration(
                                          border:
                                              Border.all(color: Colors.grey),
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          // color: Theme.of(context).accentColor
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            InkWell(
                                                onTap: () {
                                                  if (cartdata!
                                                          .data![index].qty ==
                                                      "1") {
                                                    deleteitem(
                                                      cartdata!.data![index].id,
                                                      index,
                                                    );
                                                  } else {
                                                    changeQTYAPI(
                                                      cartdata!.data![index].id,
                                                      "minus",
                                                      // int.parse(cartdata!
                                                      //         .data![index].qty
                                                      //         .toString()) -
                                                      //     1,  
                                                    );
                                                  }
                                                },
                                                child: Icon(
                                                  Icons.remove,
                                                  color: color.green,
                                                  size: 16,
                                                )),
                                            Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(3),
                                              ),
                                              child: Text(
                                                cartdata!.data![index].qty
                                                    .toString(),
                                                style:
                                                    TextStyle(fontSize: 10.sp),
                                              ),
                                            ),
                                            InkWell(
                                                onTap: () {
                                                  changeQTYAPI(
                                                    cartdata!.data![index].id,
                                                    "plus"
                                                    // int.parse(cartdata!
                                                    //         .data![index].qty
                                                    //         .toString()) +
                                                    //     1,
                                                  );
                                                },
                                                child: Icon(
                                                  Icons.add,
                                                  color: color.green,
                                                  size: 16,
                                                )),
                                          ],
                                        ),
                                      ),
                                    ]),
                                  )
                                ],
                              ),
                            ),
                          )
                        ]),
                      );

                      // return Container(
                      //   margin: EdgeInsets.only(
                      //       top: 1.h, left: 1.5.h, right: 1.5.h, bottom: 1.h),
                      //   height: 15.5.h,
                      //   decoration: BoxDecoration(
                      //       borderRadius: BorderRadius.circular(7),
                      //       border: Border.all(
                      //         color: Colors.grey,
                      //         width: 0.8.sp,
                      //       )),
                      //   child: Row(children: [
                      //     SizedBox(
                      //       width: 28.w,
                      //       height: 15.5.h,
                      //       child: ClipRRect(
                      //         borderRadius: BorderRadius.only(
                      //             topLeft: Radius.circular(7),
                      //             bottomLeft: Radius.circular(7)),
                      //         child: Image.network(
                      //           cartdata!.data![index].itemImage.toString(),
                      //           fit: BoxFit.cover,
                      //         ),
                      //       ),
                      //     ),
                      //     Expanded(
                      //       child: Padding(
                      //         padding: EdgeInsets.only(
                      //             top: 1.h, right: 2.w, left: 2.w, bottom: 0.8.h),
                      //         child: Column(
                      //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //           children: [
                      //             Row(
                      //               children: [
                      //                 Expanded(
                      //                   child: Text(
                      //                     cartdata!.data![index].itemName
                      //                         .toString(),
                      //                     overflow: TextOverflow.ellipsis,
                      //                     style: TextStyle(
                      //                       fontSize: 11.sp,
                      //                       fontFamily: 'Poppins_semibold',
                      //                     ),
                      //                   ),
                      //                 )
                      //               ],
                      //             ),
                      //             Row(
                      //               children: [
                      //                 if (cartdata!.data![index].variation ==
                      //                     "") ...[
                      //                   Expanded(
                      //                     child: Text(
                      //                       "-",
                      //                       overflow: TextOverflow.ellipsis,
                      //                       style: TextStyle(
                      //                         fontSize: 9.sp,
                      //                         color: Colors.grey,
                      //                         fontFamily: 'Poppins',
                      //                       ),
                      //                     ),
                      //                   ),
                      //                 ] else ...[
                      //                   Expanded(
                      //                     child: Text(
                      //                       cartdata!.data![index].variation
                      //                           .toString(),
                      //                       overflow: TextOverflow.ellipsis,
                      //                       style: TextStyle(
                      //                         fontSize: 9.sp,
                      //                         color: Colors.grey,
                      //                         fontFamily: 'Poppins',
                      //                       ),
                      //                     ),
                      //                   ),
                      //                 ]
                      //               ],
                      //             ),
                      //             Row(
                      //               children: [
                      //                 if (cartdata!.data![index].addonsName ==
                      //                     "") ...[
                      //                   Expanded(
                      //                     child: Text(
                      //                       "-",
                      //                       overflow: TextOverflow.ellipsis,
                      //                       style: TextStyle(
                      //                         fontSize: 9.sp,
                      //                         color: Colors.grey,
                      //                         fontFamily: 'Poppins',
                      //                       ),
                      //                     ),
                      //                   ),
                      //                 ] else ...[
                      //                   Expanded(
                      //                     child: Text(
                      //                       cartdata!.data![index].addonsName
                      //                           .toString(),
                      //                       overflow: TextOverflow.ellipsis,
                      //                       style: TextStyle(
                      //                         fontSize: 9.sp,
                      //                         color: Colors.grey,
                      //                         fontFamily: 'Poppins',
                      //                       ),
                      //                     ),
                      //                   ),
                      //                 ]
                      //               ],
                      //             ),
                      //             Padding(
                      //               padding: const EdgeInsets.only(top: 5),
                      //               child: Row(children: [
                      //                 SizedBox(
                      //                   child: Text(
                      //                     currency_position == "1"
                      //                         ? "$currency${(numberFormat.format(double.parse(cartdata!.data![index].totalPrice!.toString()) * int.parse(cartdata!.data![index].qty.toString())))}"
                      //                         : "${(numberFormat.format(double.parse(cartdata!.data![index].totalPrice!.toString()) * int.parse(cartdata!.data![index].qty.toString())))}$currency",
                      //                     // '\$${numberFormat.format(int.parse(${cartdata!.data![index].itemPrice.toString()}* ${cartdata!.data![index].qty)})}',
                      //                     style: TextStyle(
                      //                       fontSize: 12.sp,
                      //                       fontFamily: 'Poppins_semibold',
                      //                     ),
                      //                   ),
                      //                 ),
                      //                 Spacer(),
                      //                 Container(
                      //                   height: 3.6.h,
                      //                   width:
                      //                       MediaQuery.of(context).size.width / 4,
                      //                   decoration: BoxDecoration(
                      //                     border: Border.all(color: Colors.grey),
                      //                     borderRadius: BorderRadius.circular(5),
                      //                     // color: Theme.of(context).accentColor
                      //                   ),
                      //                   child: Row(
                      //                     mainAxisAlignment:
                      //                         MainAxisAlignment.spaceAround,
                      //                     children: [
                      //                       InkWell(
                      //                           onTap: () {
                      //                             if (cartdata!.data![index].qty ==
                      //                                 "1") {
                      //                               deleteitem(
                      //                                   cartdata!.data![index].id);
                      //                             } else {
                      //                               changeQTYAPI(
                      //                                 cartdata!.data![index].id,
                      //                                 "minus",
                      //                               );
                      //                             }
                      //                           },
                      //                           child: Icon(
                      //                             Icons.remove,
                      //                             color: color.green,
                      //                             size: 16,
                      //                           )),
                      //                       Container(
                      //                         decoration: BoxDecoration(
                      //                           borderRadius:
                      //                               BorderRadius.circular(3),
                      //                         ),
                      //                         child: Text(
                      //                           cartdata!.data![index].qty
                      //                               .toString(),
                      //                           style: TextStyle(fontSize: 10.sp),
                      //                         ),
                      //                       ),
                      //                       InkWell(
                      //                           onTap: () {
                      //                             changeQTYAPI(
                      //                               cartdata!.data![index].id,
                      //                               "plus",
                      //                             );
                      //                           },
                      //                           child: Icon(
                      //                             Icons.add,
                      //                             color: color.green,
                      //                             size: 16,
                      //                           )),
                      //                     ],
                      //                   ),
                      //                 ),
                      //               ]),
                      //             )
                      //           ],
                      //         ),
                      //       ),
                      //     )
                      //   ]),
                      // );
                    },
                  ),
                ),
                bottomSheet: Container(
                  margin: EdgeInsets.only(
                    left: 3.w,
                    right: 3.w,
                    top: 1.h,
                  ),
                  height: 6.5.h,
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () {
                      isopenAPI();
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: color.primarycolor,
                    ),
                    child: Text(
                      LocaleKeys.Continue.tr(),
                      style: TextStyle(
                          fontFamily: 'Poppins_semibold',
                          color: Colors.white,
                          fontSize: fontsize.Buttonfontsize),
                    ),
                  ),
                ));
          },
        ));
      },
    );
  }
}
