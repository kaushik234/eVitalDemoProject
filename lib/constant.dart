import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Color kMainColor = Color(0xFF2957a4);
Color kGreyTextColor = Color(0xFF9090AD);
Color kBorderColorTextField = Color(0xFFC2C2C2);
Color kDarkWhite = Color(0xFFF1F7F7);
Color kTitleColor = Color(0xFF22215B);
Color kAlertColor = Color(0xFFFF8919);
Color kBgColor = Color(0xFFFAFAFA);
Color  kHalfDay = Color(0xFFE8B500);
Color  kGreenColor = Color(0xFF08BC85);

final kTextStyle = GoogleFonts.manrope(
  color: kTitleColor,
);
String purchaseCode = '528cdb9a-5d37-4292-a2b5-b792d5eca03a';
BoxDecoration kButtonDecoration = BoxDecoration(
  borderRadius: BorderRadius.all(
    Radius.circular(5),
  ),
);

InputDecoration kInputDecoration = InputDecoration(
  hintStyle: TextStyle(color: kBorderColorTextField),
  filled: true,
  fillColor: Colors.white70,
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(8.0)),
    borderSide: BorderSide(color: kBorderColorTextField, width: 2),
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(6.0)),
    borderSide: BorderSide(color: kBorderColorTextField, width: 2),
  ),
);

OutlineInputBorder outlineInputBorder() {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(5.0),
    borderSide: BorderSide(color: kMainColor.withOpacity(0.1)),
  );
}

final otpInputDecoration = InputDecoration(
  contentPadding:  EdgeInsets.symmetric(vertical: 5.0),
  border: outlineInputBorder(),
  focusedBorder: outlineInputBorder(),
  enabledBorder: outlineInputBorder(),
);



List<String> Language = [
  'English','Hindi','Gujarati'
];





