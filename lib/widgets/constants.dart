import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

const kSpacingUnit = 10;

const kDarkPrimaryColor = Color(0xFF212121);
const kDarkSecondaryColor = Color(0xFF373737);
const kLightPrimaryColor = Color(0xFFFFFFFFF);
const kLightSecondaryColor = Color(0xFFF3F7FB);
const kAccentColor = Color(0xFFFFC107);
const kWhiteColor = Colors.white;
final bWhiteColor = Colors.white.withOpacity(0.4);

final kTitleTextStyle = TextStyle(
    fontSize: ScreenUtil().setSp(kSpacingUnit.w * 1.3),
    fontWeight: FontWeight.w600);

final kCaptionTextStyle = TextStyle(
    fontSize: ScreenUtil().setSp(kSpacingUnit.w * 1.3),
    fontWeight: FontWeight.w100);

final kButtonTitleTexyStyle = TextStyle(
    fontSize: ScreenUtil().setSp(kSpacingUnit.w * 1.3),
    fontWeight: FontWeight.w400,
    color: kDarkPrimaryColor);

final kDarkTheme = ThemeData(
    brightness: Brightness.dark,
    fontFamily: 'SFProText',
    primaryColor: kDarkPrimaryColor,
    canvasColor: kDarkPrimaryColor,
    backgroundColor: kDarkSecondaryColor,
    accentColor: kAccentColor,
    iconTheme: ThemeData.dark().iconTheme.copyWith(
          color: kLightSecondaryColor,
        ),
    textTheme: ThemeData.dark().textTheme.apply(
        fontFamily: 'SfProText',
        bodyColor: kLightSecondaryColor,
        displayColor: kLightSecondaryColor));

final kLightTheme = ThemeData(
    brightness: Brightness.light,
    fontFamily: 'SFProText',
    primaryColor: kLightPrimaryColor,
    canvasColor: kLightSecondaryColor,
    accentColor: kAccentColor,
    iconTheme: ThemeData.light().iconTheme.copyWith(color: kDarkSecondaryColor),
    textTheme: ThemeData.light().textTheme.apply(
        fontFamily: 'SFProText',
        bodyColor: kDarkSecondaryColor,
        displayColor: kDarkSecondaryColor));
const kDefualtPadding = 20.0;
const kDefualtShadow =
    BoxShadow(offset: Offset(0, 15), blurRadius: 27, color: Colors.black12);

final kBoxDecorationStyle = BoxDecoration(
  color: Colors.white.withOpacity(0.4),
  borderRadius: BorderRadius.circular(20.0),
  boxShadow: [
    BoxShadow(
      color: Colors.black12,
      blurRadius: 6.0,
      offset: Offset(0, 2),
    ),
  ],
);
const kInputDecoration = InputDecoration(
  filled: true,
  enabledBorder: UnderlineInputBorder(
    borderSide: BorderSide(color: Colors.grey),
  ),
  focusedBorder: UnderlineInputBorder(
    borderSide: BorderSide(color: Colors.white),
  ),
  border: OutlineInputBorder(borderSide: BorderSide()),
);

//  const  kInputDecoration: InputDecoration(
//                 // fillColor: Colors.white.withOpacity(0.4),
//                 filled: true,
//                 enabledBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(30.0)),
//                 focusedBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(30.0)),
//                 hintText: 'add an interesting caption',
//                 hintStyle: TextStyle(color: Colors.white),
//                 border: InputBorder.none,
//               );
