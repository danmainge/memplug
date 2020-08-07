import 'package:flutter/material.dart';

const kWhiteColor = Colors.white;
final bWhiteColor = Colors.white.withOpacity(0.4);
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
