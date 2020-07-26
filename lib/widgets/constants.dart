import 'package:flutter/material.dart';

// const kWhiteColor = Color(ffffff);
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

//  const kButtonTheme = ButtonTheme(
//                               minWidth: 200,
//                               child: RaisedButton(
//                                 color: Colors.white,
//                                 elevation: 5.0,
//                                 padding: EdgeInsets.all(15.0),
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(30.0),
//                                 ),
//                                 child: Text(
//                                   'here',
//                                   style: TextStyle(
//                                       fontSize: 20, color: Color(0xFF5270AA)),
//                                 ),
//                                 onPressed: () {

//                                 },
//                               ),
//                             );
