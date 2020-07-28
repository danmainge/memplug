import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

const kWhiteColor = Colors.white;
// const kWhiteColor = Colors.white.withOpacity(0.4);
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
  fillColor: Colors.white,
  filled: true,
  enabledBorder: UnderlineInputBorder(
    borderSide: BorderSide(color: Colors.grey),
  ),
  focusedBorder: UnderlineInputBorder(
    borderSide: BorderSide(color: Colors.white),
  ),
  border: OutlineInputBorder(),
);
