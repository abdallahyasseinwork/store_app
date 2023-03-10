// ignore_for_file: prefer_const_constructors, file_names, must_be_immutable, non_constant_identifier_names, use_key_in_widget_constructors, use_build_context_synchronously, avoid_print

import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firsttest/model/cart/isopenclose.dart';
import 'package:firsttest/model/cart/orderplaceMODEL.dart';
import 'package:firsttest/model/settings/paymentoptionmodel.dart';
import 'package:firsttest/widgets/loader.dart';
import 'package:firsttest/common%20class/color.dart';
import 'package:firsttest/common%20class/prefs_name.dart';
import 'package:firsttest/config/api/api.dart';
import 'package:firsttest/pages/cart/orderpayment/orderflutterwave.dart';
import 'package:firsttest/pages/cart/orderpayment/orderpaystack.dart';
import 'package:firsttest/pages/cart/orderpayment/orderrazorpay.dart';
import 'package:firsttest/pages/cart/orderpayment/orderstripe.dart';
import 'package:firsttest/pages/cart/ordersucess.dart';
import 'package:firsttest/pages/Home/Homepage.dart';
import 'package:firsttest/translation/locale_keys.g.dart';
import 'package:sizer/sizer.dart';
import 'package:easy_localization/easy_localization.dart';

class Paymentoption extends StatefulWidget {
  dynamic ordertotal;
  dynamic ordertype;
  dynamic offer_code;
  dynamic discount_amount;
  dynamic tax_amount;
  dynamic delivery_charge;
  //address
  dynamic addresstype;
  dynamic address;
  dynamic area;
  dynamic houseno;
  dynamic lang;
  dynamic lat;
  //
  dynamic ordernote;

  // const Paymentoption({Key? key}) : super(key: key);

  @override
  State<Paymentoption> createState() => _PaymentoptionState();
  Paymentoption([
    this.ordertotal,
    this.ordertype,
    this.offer_code,
    this.discount_amount,
    this.tax_amount,
    this.delivery_charge,
    // address
    this.addresstype,
    this.address,
    this.area,
    this.houseno,
    this.lang,
    this.lat,
    this.ordernote,
  ]);
}

class _PaymentoptionState extends State<Paymentoption> {
  int? selectedindex;
  dynamic userid;
  paymentoptionModel? paymentlist;
  bool iscome = true;
  dynamic namepay;
  dynamic environment;
  orderplaceMODEL? placedorederdata;
  dynamic public_key;
  dynamic secret_key;
  // String? live_public_key;
  // String? live_secret_key;
  dynamic encryption_key;
  dynamic currency;
  dynamic appcurrency;

  // selectpayment select = Get.put(selectpayment());
  paymentoptionAPI() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userid = prefs.getString(UD_user_id);
    appcurrency = prefs.getString(APPcurrency);
    var map = {
      "user_id": userid,
      "type": "order",
    };

    var response = await Dio()
        .post(DefaultApi.appUrl + PostAPI.Paymentmethodlist, data: map);
    print(response);
    var finalist = await response.data;
    print(finalist);
    paymentlist = paymentoptionModel.fromJson(finalist);
    iscome = false;
    return paymentlist;
  }

  placeorderAPI(type) async {
    try {
      loader.showLoading();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      userid = prefs.getString(UD_user_id);
      var map = {
        "user_id": userid,
        "grand_total": widget.ordertotal,
        "transaction_type": type,
        "transaction_id": "",
        "order_type": widget.ordertype,
        "address_type": widget.address,
        "address": widget.address,
        "area": widget.area,
        "house_no": widget.houseno,
        "lang": widget.lang,
        "lat": widget.lat,
        "offer_code": widget.offer_code == "0" ? "" : widget.offer_code,
        "discount_amount": widget.discount_amount,
        "tax_amount": double.parse(widget.tax_amount.toString()),
        "delivery_charge": widget.delivery_charge,
        "order_notes": widget.ordernote,
        "order_from": "flutter",
        "card_number": "",
        "card_exp_month": "",
        "card_exp_year": "",
        "card_cvc": ""
      };
      print(map);
      var response =
          await Dio().post(DefaultApi.appUrl + PostAPI.Order, data: map);
          print("1");
      placedorederdata = orderplaceMODEL.fromJson(response.data);
      log(response.data.toString());
      loader.hideLoading();
      if (placedorederdata!.status == 1) {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => Ordersucesspage()));
      } else {
        loader.showErroDialog(description: placedorederdata!.message);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leadingWidth: 40,
          elevation: 0,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(
                  context,
                );
              },
              icon: Icon(
                Icons.arrow_back_ios_outlined,
                size: 20,
              )),
          title: Text(
            LocaleKeys.Payment_Option.tr(),
            textAlign: TextAlign.center,
            style: TextStyle(fontFamily: 'Poppins_semibold', fontSize: 12.sp),
          ),
          centerTitle: true,
        ),
        body: FutureBuilder(
          future: iscome == true ? paymentoptionAPI() : null,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                padding: EdgeInsets.only(left: 4.w, right: 4.w),
                itemCount: paymentlist!.paymentmethods!.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      InkWell(
                        onTap: () {
                          print(index);

                          setState(() {
                            environment =
                                paymentlist!.paymentmethods![index].environment;
                            namepay =
                                paymentlist!.paymentmethods![index].paymentName;
                            currency =
                                paymentlist!.paymentmethods![index].currency;
                            selectedindex = index;

                            public_key =
                                paymentlist!.paymentmethods![index].publicKey;
                            secret_key =
                                paymentlist!.paymentmethods![index].secretKey;

                            print(secret_key);
                            print(public_key);
                          });
                        },
                        child: SizedBox(
                          height: 7.h,
                          child: Row(
                            children: [
                              SizedBox(
                                width: 13.w,
                                child: Image.network(
                                  paymentlist!.paymentmethods![index].image!,
                                  height: 4.h,
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                  left: 1.w,
                                ),
                                child: Text(
                                  paymentlist!.paymentmethods![index]
                                              .paymentName ==
                                          "Wallet"
                                      ? "${paymentlist!.paymentmethods![index].paymentName.toString()} ($appcurrency${paymentlist!.totalWallet})"
                                      : paymentlist!
                                          .paymentmethods![index].paymentName
                                          .toString(),
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 11.sp,
                                  ),
                                ),
                              ),
                              Spacer(),
                              Container(
                                height: 3.3.h,
                                width: 3.3.h,
                                decoration: BoxDecoration(
                                  color: selectedindex == index
                                      ? color.green
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: Icon(Icons.done,
                                    color: selectedindex == index
                                        ? Colors.white
                                        : Colors.transparent,
                                    size: 13.sp),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        // margin: EdgeInsets.only(top: 1.h, bottom: 2.5.w),
                        color: Colors.grey,
                        height: 0.8.sp,
                      ),
                    ],
                  );
                },
              );
            }
            return Center(
              child: CircularProgressIndicator(
                color: color.primarycolor,
              ),
            );
          },
        ),
        bottomSheet: Container(
          margin: EdgeInsets.only(bottom: 1.h, left: 4.w, right: 4.w),
          height: 6.5.h,
          width: double.infinity,
          child: TextButton(
            onPressed: () async {
              isopencloseMODEL? isopendata;
              if (selectedindex == null) {
                loader.showErroDialog(
                    description: LocaleKeys.Please_select_payment_option.tr());
              } else {
                loader.showLoading();
                var map = {
                  "user_id": userid,
                };
                print(map);
                var response = await Dio().post(
                  DefaultApi.appUrl + PostAPI.isopenclose,
                  data: map,
                );
                print(response);
                isopendata = isopencloseMODEL.fromJson(response.data);
                loader.hideLoading();
                if (isopendata.status == 1) {
                  if (isopendata.isCartEmpty == "0") {
                    if (namepay == "COD") {
                      placeorderAPI("1");
                    } else if (namepay == "Wallet") {
                      print(widget.ordertotal!);
                      print(paymentlist!.totalWallet);
                      if (double.parse(widget.ordertotal!) >=
                          double.parse(paymentlist!.totalWallet.toString())) {
                        loader.showErroDialog(
                          description: LocaleKeys
                                  .You_dont_have_sufficient_wallet_amonut_Please_select_another_payment_option
                              .tr(),
                        );
                      } else {
                        placeorderAPI("2");
                      }
                    } else if (namepay == "RazorPay") {
                      Get.to(() => orderrazorpay(
                            // order
                            widget.ordertotal,
                            widget.ordertype,
                            widget.offer_code,
                            widget.discount_amount,
                            widget.tax_amount,
                            widget.delivery_charge,
                            //address
                            widget.addresstype,
                            widget.address,
                            widget.area,
                            widget.houseno,
                            widget.lang,
                            widget.lat,
                            // extra
                            widget.ordernote,
                            //key
                            public_key,
                            secret_key,
                            currency,
                          ));
                    } else if (namepay == "Stripe") {
                      print("object");
                      Get.to(() => orderstripe(
                            //order
                            widget.ordertotal,
                            widget.ordertype,
                            widget.offer_code,
                            widget.discount_amount,
                            widget.tax_amount,
                            widget.delivery_charge,
                            // address
                            widget.addresstype,
                            widget.address,
                            widget.area,
                            widget.houseno,
                            widget.lang,
                            widget.lat,
                            //extra
                            widget.ordernote,
                          ));
                    } else if (namepay == "Flutterwave") {
                      print(currency);
                      Get.to(() => orderflutterwave(
                            widget.ordertotal,
                            widget.ordertype,
                            widget.offer_code,
                            widget.discount_amount,
                            widget.tax_amount,
                            widget.delivery_charge,
                            //address
                            widget.addresstype,
                            widget.address,
                            widget.area,
                            widget.houseno,
                            widget.lang,
                            widget.lat,
                            //
                            widget.ordernote,
                            //key
                            public_key,
                            secret_key,

                            encryption_key,
                            currency,
                            environment,
                          ));
                      print("Flutterwave");
                    } else if (namepay == "Paystack") {
                      Get.to(() => order_paystack(
                            widget.ordertotal,
                            widget.ordertype,
                            widget.offer_code,
                            widget.discount_amount,
                            widget.tax_amount,
                            widget.delivery_charge,
                            //address
                            widget.addresstype,
                            widget.address,
                            widget.area,
                            widget.houseno,
                            widget.lang,
                            widget.lat,
                            //
                            widget.ordernote,
                            //key
                            public_key,
                            secret_key,
                            encryption_key,
                            currency,
                          ));
                      print("Paystack");
                    }
                  } else {
                    Get.to(() => Homepage(0));
                  }
                } else {
                  loader.showErroDialog(
                    description: isopendata.message,
                  );
                }
              }
            },
            style: TextButton.styleFrom(
              backgroundColor: color.primarycolor,
            ),
            child: Text(
              LocaleKeys.Place_Order.tr(),
              style: TextStyle(
                  fontFamily: 'Poppins',
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 12.sp),
            ),
          ),
        ),
      ),
    );
  }
}
