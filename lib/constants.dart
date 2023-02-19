import 'package:flutter/material.dart';

class Constants{

   static getWidth(context){
      return MediaQuery.of(context).size.width;
    }

       static getHeight(context){
      return MediaQuery.of(context).size.height;
    }

    static navigateTo(context,page){
        Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) =>
                        page,
                  ),
                );
    }

        static navigateToWithReplacement(context,page){
        Navigator.pushReplacement(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) =>
                        page,
                  ),
                );
    }

}