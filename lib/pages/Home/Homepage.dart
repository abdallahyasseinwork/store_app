// ignore_for_file: prefer_const_constructors, file_names, camel_case_types, prefer_collection_literals, must_be_immutable
import 'dart:async';
import 'dart:convert';
import 'package:badges/badges.dart' as bg;
//import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart' hide Trans;
import 'package:overlay_support/overlay_support.dart';
import 'package:firsttest/common%20class/prefs_name.dart';
import 'package:firsttest/pages/authentication/login.dart';
import 'package:firsttest/widgets/loader.dart';
import 'package:firsttest/common%20class/color.dart';
import 'package:firsttest/common%20class/height.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firsttest/main.dart';
import 'package:firsttest/pages/orders/orderdetails.dart';
import 'package:firsttest/translation/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sizer/sizer.dart';
import '../../theme/thememodel.dart';
import '../cart/cartpage.dart';
import '../favorite/favoritepage.dart';
import '../orders/orders.dart';
import '../profile/profilepage.dart';
import 'homescreen.dart';

class cartcount extends GetxController {
  RxInt cartcountnumber = 0.obs;
}

class payloads {
  dynamic categoryName;
  dynamic categoryId;
  dynamic subType;
  dynamic itemId;
  dynamic type;
  dynamic orderId;

  payloads(
      {this.categoryName,
      this.categoryId,
      this.subType,
      this.itemId,
      this.type,
      this.orderId});

  payloads.fromJson(Map<String, dynamic> json) {
    categoryName = json['category_name'];
    categoryId = json['category_id'];
    subType = json['sub_type'];
    itemId = json['item_id'];
    type = json['type'];
    orderId = json['order_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['category_name'] = categoryName;
    data['category_id'] = categoryId;
    data['sub_type'] = subType;
    data['item_id'] = itemId;
    data['type'] = type;
    data['order_id'] = orderId;
    return data;
  }
}

class Homepage extends StatefulWidget {
  int? count;
  Homepage(this.count, {super.key});
  // const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  // GlobalKey<FormState> homekey = GlobalKey<FormState>();

  late StreamSubscription subscription;
  int? _selectedindex;
  bool isDeviceConnected = false;
  bool isAlertSet = false;

  // getConnectivity() =>
  //     subscription = Connectivity().onConnectivityChanged.listen(
  //       (ConnectivityResult result) async {
  //         isDeviceConnected = await InternetConnectionChecker().hasConnection;
  //         if (!isDeviceConnected && isAlertSet == false) {
  //           showDialogBox();
  //           setState(() => isAlertSet = true);
  //         }
  //       },
  //     );

  // showDialogBox() => showCupertinoDialog<String>(
  //       context: context,
  //       builder: (BuildContext context) => CupertinoAlertDialog(
  //         title: const Text('No Connection'),
  //         content: const Text('Please check your internet connectivity'),
  //         actions: <Widget>[
  //           TextButton(
  //             onPressed: () async {
  //               Navigator.pop(context, 'Cancel');
  //               setState(() => isAlertSet = false);
  //               isDeviceConnected =
  //                   await InternetConnectionChecker().hasConnection;
  //               if (!isDeviceConnected && isAlertSet == false) {
  //                 showDialogBox();
  //                 setState(() => isAlertSet = true);
  //               }
  //             },
  //             child: const Text('OK'),
  //           ),
  //         ],
  //       ),
  //     );
  //
  //
  Future<dynamic> onSelectNotification(payload) async {
    if (mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => Homepage(3),
        ),
      );
    }
  }

  @override
  void initState() {
    _selectedindex = widget.count;
    // getConnectivity();
    super.initState();
    getdata();
   // FirebaseMessaging.instance;

    // var initializationsettingsAndroid =
    //     const AndroidInitializationSettings('@drawable/ic_notification');
    // final InitializationSettings initializationSettings =
    //     InitializationSettings(android: initializationsettingsAndroid);
    // FlutterLocalNotificationsPlugin().initialize(
    //   initializationSettings,
    // );

    // flutterLocalNotificationsPlugin.initialize(initializationSettings,
    //     onSelectNotification: onSelectNotification);
    // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    //   RemoteNotification? notification = message.notification;
    //   AndroidNotification? android = message.notification?.android;

    //   if (notification != null && android != null) {
    //     String action = jsonEncode(message.data);

    //     flutterLocalNotificationsPlugin.show(
    //       notification.hashCode,
    //       notification.title,
    //       notification.body,
    //       NotificationDetails(
    //           android: AndroidNotificationDetails(
    //             icon: '@drawable/ic_notification',
    //             channel.id,
    //             channel.name,
    //           ),
    //           iOS: IOSNotificationDetails()),
    //       payload: action,
    //     );
    //   }
    // });

    // FirebaseMessaging.onMessageOpenedApp.listen(
    //   (RemoteMessage message) {
    //     RemoteNotification? notification = message.notification;
    //     AndroidNotification? android = message.notification?.android;
    //     if (notification != null && android != null) {
    //       Get.to(() => Orderdetails("171"));
    //       loader.showErroDialog(description: "sfggfgdfdsd");
    //       showDialog(
    //         context: context,
    //         builder: (context) {
    //           return AlertDialog(
    //               title: Text(notification.title!),
    //               content: SingleChildScrollView(
    //                 child: Column(
    //                   crossAxisAlignment: CrossAxisAlignment.start,
    //                   children: [
    //                     Text(notification.body!),
    //                   ],
    //                 ),
    //               ));
    //         },
    //       );
    //     }
    //   },
    // );
  }

  String? userid;
  PageController pageController = PageController();
  int cardcount = 0;
  cartcount count = Get.put(cartcount());

  getdata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedindex = widget.count;
      userid = (prefs.getString(UD_user_id) ?? "");
      if (widget.count == 2 || widget.count == 3) {
        pageController.animateToPage(
          widget.count!,
          duration: const Duration(milliseconds: 1),
          curve: Curves.ease,
        );
      }
    });
  }

  void onTapped(int index) {
    if (userid != "") {
      setState(() {
        _selectedindex = index;
        widget.count = index;
        pageController.animateToPage(
          index,
          duration: const Duration(milliseconds: 1),
          curve: Curves.ease,
        );
      });
    } else if (index == 1) {
      if (userid == "") {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (c) => Login()), (r) => false);
      }
    } else if (index == 2) {
      if (userid == "") {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (c) => Login()), (r) => false);
      }
    } else if (index == 3) {
      if (userid == "") {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (c) => Login()), (r) => false);
      }
    } else {
      setState(() {
        _selectedindex = index;
        widget.count = index;
        pageController.animateToPage(
          index,
          duration: const Duration(milliseconds: 1),
          curve: Curves.ease,
        );
      });
    }
  }

  List pages = [
    Homescreen(),
    Favorite(),
    Viewcart(),
    Orderhistory(),
    Profilepage()
  ];

  @override
  Widget build(BuildContext context) {
    // connections().conect();
    return Consumer(builder: (context, ThemeModel themenofier, child) {
      return OverlaySupport(
        child: WillPopScope(
          onWillPop: () async {
            final value = await showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text(
                    LocaleKeys.ecommerce_User.tr(),
                    style: TextStyle(
                        fontSize: 14.sp, fontFamily: 'Poppins_semibold'),
                  ),
                  content: Text(
                    LocaleKeys.Are_you_sure_to_exit_from_this_app.tr(),
                    style: TextStyle(fontSize: 12.sp, fontFamily: 'Poppins'),
                  ),
                  actions: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: color.primarycolor,
                      ),
                      child: Text(
                        LocaleKeys.No.tr(),
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.white,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: color.primarycolor,
                      ),
                      child: Text(
                        LocaleKeys.Yes.tr(),
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.white,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
            if (value != null) {
              return Future.value(value);
            } else {
              return Future.value(false);
            }
          },
          child: Scaffold(
            body: PageView(
              controller: pageController,
              physics: NeverScrollableScrollPhysics(),
              children: const [
                Homescreen(),
                Favorite(),
                Viewcart(),
                Orderhistory(),
                Profilepage()
              ],
            ),
            bottomNavigationBar: BottomNavigationBar(
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    'Assets/Icons/Home.svg',
                    height: height.bottombaricon,
                    color: themenofier.isdark ? Colors.white : Colors.black,
                  ),
                  label: "",
                  activeIcon: SvgPicture.asset(
                    'Assets/Icons/Homedark.svg',
                    height: height.bottombaricon,
                    color: themenofier.isdark ? Colors.white : Colors.black,
                  ),
                ),
                BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    'Assets/Icons/Favorite.svg',
                    height: height.bottombaricon,
                    color: themenofier.isdark ? Colors.white : Colors.black,
                  ),
                  label: "",
                  activeIcon: SvgPicture.asset(
                    'Assets/Icons/Favoritedark.svg',
                    height: height.bottombaricon,
                    color: themenofier.isdark ? Colors.white : Colors.black,
                  ),
                ),
                BottomNavigationBarItem(
                    icon: Obx(
                      () => count.cartcountnumber.value == 0
                          ? SvgPicture.asset(
                              'Assets/Icons/Cart.svg',
                              height: height.bottombaricon,
                              color: themenofier.isdark
                                  ? Colors.white
                                  : Colors.black,
                            )
                          : bg.Badge(
                              padding: EdgeInsets.all(5),
                              toAnimate: false,
                              elevation: 0,
                              badgeColor: color.red,
                              badgeContent: Text(
                                count.cartcountnumber.value.toString(),
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12),
                              ),
                              child: SvgPicture.asset(
                                'Assets/Icons/Cart.svg',
                                height: height.bottombaricon,
                                color: themenofier.isdark
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                    ),
                    label: "",
                    activeIcon: Obx(
                      () => count.cartcountnumber.value == 0
                          ? SvgPicture.asset(
                              'Assets/Icons/Cartdark.svg',
                              height: height.bottombaricon,
                              color: themenofier.isdark
                                  ? Colors.white
                                  : Colors.black,
                            )
                          : bg.Badge(
                              padding: const EdgeInsets.all(5),
                              toAnimate: false,
                              elevation: 0,
                              badgeColor: color.red,
                              badgeContent: Text(
                                count.cartcountnumber.value.toString(),
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12),
                              ),
                              child: SvgPicture.asset(
                                'Assets/Icons/Cartdark.svg',
                                height: height.bottombaricon,
                                color: themenofier.isdark
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                    )),
                BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    'Assets/Icons/Order.svg',
                    height: height.bottombaricon,
                    color: themenofier.isdark ? Colors.white : Colors.black,
                  ),
                  label: "",
                  activeIcon: SvgPicture.asset(
                    'Assets/Icons/Orderdark.svg',
                    height: height.bottombaricon,
                    color: themenofier.isdark ? Colors.white : Colors.black,
                  ),
                ),
                BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    'Assets/Icons/Profile.svg',
                    height: height.bottombaricon,
                    color: themenofier.isdark ? Colors.white : Colors.black,
                  ),
                  label: "",
                  activeIcon: SvgPicture.asset(
                    'Assets/Icons/Profiledark.svg',
                    height: height.bottombaricon,
                    color: themenofier.isdark ? Colors.white : Colors.black,
                  ),
                ),
              ],
              currentIndex: _selectedindex!,
              type: BottomNavigationBarType.fixed,
              backgroundColor: themenofier.isdark ? Colors.black : Colors.white,
              onTap: onTapped,
              selectedFontSize: 1,
              unselectedFontSize: 1,
              showSelectedLabels: false,
              showUnselectedLabels: false,
            ),
          ),
        ),
      );
    });
  }
}
