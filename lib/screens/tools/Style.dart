import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  appBarTheme: AppBarTheme(
    color: Color.fromRGBO(57, 57, 75, 1),
    shadowColor: Colors.black,
    actionsIconTheme: IconThemeData(
      color: Colors.indigoAccent,
      opacity: 1.0,
    ),
    elevation: 0,
  ),
  iconTheme: IconThemeData(
    color: Colors.indigoAccent,
    opacity: 1.0,
  ),
  primaryColor: Color(0xff39394B),
  primaryColorBrightness: Brightness.dark,
  primaryColorLight: Color.fromRGBO(57, 57, 75, 1),
  primaryColorDark: Color.fromRGBO(42, 42, 55, 1.0),
  accentColor: Color.fromRGBO(57, 57, 75, 1),
  accentColorBrightness: Brightness.dark,
  shadowColor: Colors.black,
  scaffoldBackgroundColor: Color.fromRGBO(57, 57, 75, 1),
  cardColor: Color.fromRGBO(60, 60, 90, 1),
  dividerColor: Colors.white,
  hoverColor: Colors.indigoAccent,
  splashColor: Colors.indigoAccent,
  disabledColor: Color.fromRGBO(57, 57, 75, 1),
  buttonColor: Colors.indigoAccent,
  cursorColor: Colors.indigoAccent,
  backgroundColor: Color(0xFF48485D),
  dialogBackgroundColor: Color.fromRGBO(57, 57, 75, 1.0),
  indicatorColor: Colors.indigoAccent,
  toggleableActiveColor: Colors.indigoAccent,
  textTheme:TextTheme(
    bodyText1: GoogleFonts.poppins(
      color: Colors.white,
      fontSize: 12,
    ),
    bodyText2: GoogleFonts.poppins(
      color: Colors.white,
      fontSize: 17,
    ),
    headline6: GoogleFonts.poppins(
      color: Colors.white,
      fontSize: 10,
    ),
    headline5: GoogleFonts.poppins(
      color: Colors.white,
      fontSize: 12,
    ),
    headline4: GoogleFonts.poppins(
      color: Colors.white,
      fontSize: 15,
      fontWeight: FontWeight.w500,
    ),
    headline3: GoogleFonts.poppins(
      color: Colors.white,
      fontSize: 18,
    ),
    headline2: GoogleFonts.poppins(
      color: Colors.white,
      fontSize: 20,
    ),
    headline1: GoogleFonts.poppins(
      color: Colors.white,
      fontSize: 25,
    ),
  ),
//#292938
//#39394B
);

ThemeData lightTheme = ThemeData(
  appBarTheme: AppBarTheme(
    color: Colors.white,
    shadowColor: Colors.grey,
    actionsIconTheme: IconThemeData(
      color: Colors.indigoAccent,
      opacity: 1.0,
    ),
    elevation: 0,
  ),
  iconTheme: IconThemeData(
    color: Colors.indigoAccent,
    opacity: 1.0,
  ),
  brightness: Brightness.light,
  primaryColor: Colors.white,
  primaryColorBrightness: Brightness.light,
  primaryColorLight: Colors.white,
  primaryColorDark: Color.fromRGBO(172, 193, 255, 1.0),
  accentColor: Colors.white,
  accentColorBrightness: Brightness.light,
  shadowColor: Colors.grey,
  scaffoldBackgroundColor: Colors.white,
  cardColor: Colors.white,
  dividerColor: Colors.grey,
  hoverColor: Colors.indigoAccent,
  splashColor: Colors.indigoAccent,
  disabledColor: Colors.grey,
  buttonColor: Colors.indigoAccent,
  cursorColor: Colors.indigoAccent,
  backgroundColor: Colors.white,
  dialogBackgroundColor: Colors.white,
  indicatorColor: Colors.indigoAccent,
  toggleableActiveColor: Colors.indigoAccent,
  textTheme:TextTheme(
    bodyText1: GoogleFonts.poppins(
      color: Colors.black45,
      fontSize: 12,
    ),
    bodyText2: GoogleFonts.poppins(
      color: Colors.black45,
      fontSize: 17,
    ),
    headline6: GoogleFonts.poppins(
      color: Colors.grey,
      fontSize: 10,
    ),
    headline5: GoogleFonts.poppins(
      color: Colors.grey,
      fontSize: 12,
    ),
    headline4: GoogleFonts.poppins(
      color: Colors.grey,
      fontSize: 15,
      fontWeight: FontWeight.w500,
    ),
    headline3: GoogleFonts.poppins(
      color: Colors.grey,
      fontSize: 18,
    ),
    headline2: GoogleFonts.poppins(
      color: Color(0xFF474747),
      fontSize: 20,
    ),
    headline1: GoogleFonts.poppins(
      color: Color(0xFF151515),
      fontSize: 25,
    ),
  ),
);
