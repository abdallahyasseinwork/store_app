import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:lottie/lottie.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firsttest/config/api/api.dart';
import 'package:firsttest/constants.dart';
import 'package:firsttest/model/base_api_model.dart';
import 'package:firsttest/onboarding/onboarding.dart';
import 'package:firsttest/pages/Home/Homepage.dart';

import 'common class/prefs_name.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {


  
 
  int? initscreen;

  @override
  void initState() {
   getBaseUrl();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: Constants.getWidth(context),
        height: Constants.getHeight(context),
        child: Center(
          child: Lottie.asset("Assets/Image/loading.json",width:Constants.getWidth(context)*0.6,height: Constants.getWidth(context)*0.6 ),
        ),
      ),
    );
  }

  checkFirst()async{
     SharedPreferences prefs = await SharedPreferences.getInstance();

     initscreen = prefs.getInt(init_Screen);

     if(initscreen == 0 || initscreen == null){
        Constants.navigateToWithReplacement(context, OnBoarding());
     }else{

        Constants.navigateToWithReplacement(context,  Homepage(0));
     
     }


     
             
  }


  getBaseUrl()async{

    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    try{

 
    var response = await Dio().post(
        "https://kenda-jo.online/api/central-domain",
        data: {
          "app_id" : packageInfo.packageName
        },
      );
        
      var baseApiData = await response.data;
      log(baseApiData.toString());
      BaseApiModel baseApiModel = BaseApiModel.fromMap(baseApiData);
      log("converted");
      DefaultApi.baseUrl = "https://" + baseApiModel.domain + "/";
      log(DefaultApi.baseUrl);
      checkFirst();


  }catch(e){
          log(e.toString());
         }
  }
}