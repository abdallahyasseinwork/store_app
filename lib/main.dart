import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:firsttest/loading_api_screen.dart';
import 'package:firsttest/onboarding/onboarding.dart';
import 'package:firsttest/pages/Home/Homepage.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firsttest/theme/mythemes.dart';
import 'package:firsttest/theme/thememodel.dart';
import 'package:firsttest/common%20class/prefs_name.dart';
import 'package:firsttest/translation/codegen_loader.g.dart';
import 'package:sizer/sizer.dart';
import 'package:package_info_plus/package_info_plus.dart';

int? initscreen;
// const AndroidNotificationChannel channel = AndroidNotificationChannel(
//   'high_importance_channel', // id
//   'High Importance Notifications', // title
//   //'This channel is used for important notifications.', // description
//   importance: Importance.defaultImportance,

//   playSound: true,
// );

// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//     FlutterLocalNotificationsPlugin();

// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp();
// }

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();



  // await Firebase.initializeApp();
  // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // await flutterLocalNotificationsPlugin
  //     .resolvePlatformSpecificImplementation<
  //         AndroidFlutterLocalNotificationsPlugin>()
  //     ?.createNotificationChannel(channel);

  // await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
  //   alert: true,
  //   badge: true,
  //   sound: true,
  // );

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.dark,
      statusBarColor: Colors.white,
      statusBarBrightness: Brightness.dark,
    ),
  );

  SharedPreferences prefs = await SharedPreferences.getInstance();
  initscreen = prefs.getInt(init_Screen);

  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeModel(
        Brightness.light,
      ),
      child: Consumer(
        builder: (context, ThemeModel thememodel, child) {
          return EasyLocalization(
            path: 'Assets/translation',
            supportedLocales: const [Locale('en'), Locale('ar')],
            fallbackLocale: const Locale('en'),
            assetLoader: const CodegenLoader(),
            child: Sizer(
              builder: (context, orientation, deviceType) {
                return Phoenix(
                    child: GetMaterialApp(
                  scrollBehavior: MyBehavior(),
                  supportedLocales: context.supportedLocales,
                  localizationsDelegates: context.localizationDelegates,
                  locale: context.locale,
                  debugShowCheckedModeBanner: false,
                  theme: thememodel.isdark
                      ? MyThemes.DarkTheme
                      : MyThemes.LightTheme,
                      home: const LoadingScreen(),
                  // home: initscreen == 0 || initscreen == null
                  //     ? const OnBoarding()
                  //     : Homepage(0),
                ));
              },
            ),
          );
        },
      ),
    ),
  );
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}




//   commmands for generate localization string file 
//   flutter pub run easy_localization:generate -S "Assets/translation" -O "lib/translation"       
//   flutter pub run easy_localization:generate -S "Assets/translation" -O "lib/translation"       
//   flutter pub run easy_localization:generate -S "Assets/translation" -O "lib/translation" -o "locale_keys.g.dart" -f keys
