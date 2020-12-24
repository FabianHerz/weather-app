import 'dart:ui';
import 'package:easy_localization/easy_localization.dart';

import 'package:flutter/material.dart';
import 'package:my_weather/helpers/size_config_helper.dart';
import 'package:my_weather/widgets/condition_image.dart';
import 'package:my_weather/styles/main_colors.dart' as clr;

class DetailsItem extends StatelessWidget {
  final String itemName;
  final String itemValue;
  final String iconName;

  DetailsItem({this.itemName, this.itemValue, this.iconName});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: (SizeConfigHelper.screenWidth-80)/2,
      width: (SizeConfigHelper.screenWidth-80)/2,
      decoration: BoxDecoration(
        color: clr.view2,
        borderRadius: BorderRadius.all(Radius.circular(15)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.16),
            offset: Offset(0, 3),
            blurRadius: 6,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              itemName,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: "Segoe",
                fontWeight: FontWeight.w100,
                fontSize: 16,
                color: clr.text,

              ),
            ).tr(),
            Image.asset('assets/images/${iconName}',height: (SizeConfigHelper.screenWidth-80)*0.16,color: clr.text,),
            Text(
              itemValue,
              style: TextStyle(
                fontFamily: "Segoe",
                fontWeight: FontWeight.w100,
                fontSize: 18,
                color: clr.text,

              ),
            ),
          ],
        ),
      ),
    );
  }
}
