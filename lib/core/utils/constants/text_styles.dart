import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

TextStyle poppinsRegular({Color color = Colors.black, required double fontSize}) {
  return GoogleFonts.poppins(
    color: color,
    fontSize: fontSize,
    fontWeight: FontWeight.w400, // Regular
  );
}

TextStyle poppinsMedium({Color color = Colors.black, required double fontSize}) {
  return GoogleFonts.poppins(
    color: color,
    fontSize: fontSize,
    fontWeight: FontWeight.w500, // Medium

  );
}

TextStyle poppinsSemiBold({Color color = Colors.black, required double fontSize}) {
  return GoogleFonts.poppins(
    color: color,
    fontSize: fontSize,
    fontWeight: FontWeight.w600, // SemiBold
  );
}

TextStyle poppinsBold({Color color = Colors.black, required double fontSize}) {
  return GoogleFonts.poppins(
    color: color,
    fontSize: fontSize,
    fontWeight: FontWeight.w700, // Bold
  );
}

TextStyle poppinsExtraBold({Color color = Colors.black, required double fontSize}) {
  return GoogleFonts.poppins(
    color: color,
    fontSize: fontSize,
    fontWeight: FontWeight.w800, // ExtraBold
  );
}

TextStyle altoysFont({Color color = Colors.black, required double fontSize}) {
  return TextStyle(
    color: color,
    fontSize: fontSize,
    fontFamily: 'Altoys Font',
  );
}

TextStyle metropolisLight({Color color = Colors.black, required double fontSize}) {
  return TextStyle(
    color: color,
    fontSize: fontSize,
    fontFamily: 'Metropolis',
    fontWeight: FontWeight.w300
  );
}

TextStyle metropolisRegular({Color color = Colors.black, required double fontSize}) {
  return TextStyle(
    color: color,
    fontSize: fontSize,
    fontFamily: 'Metropolis',
    fontWeight: FontWeight.w400
  );
}

TextStyle metropolisMedium({Color color = Colors.black, required double fontSize}) {
  return TextStyle(
    color: color,
    fontSize: fontSize,
    fontFamily: 'Metropolis',
    fontWeight: FontWeight.w500
  );
}

TextStyle metropolisBold({Color color = Colors.black, required double fontSize}) {
  return TextStyle(
    color: color,
    fontSize: fontSize,
    fontFamily: 'Metropolis',
    fontWeight: FontWeight.w700
  );
}

TextStyle metropolisExtraBold({Color color = Colors.black, required double fontSize}) {
  return TextStyle(
    color: color,
    fontSize: fontSize,
    fontFamily: 'Metropolis',
    fontWeight: FontWeight.w800
  );
}

TextStyle metropolisBlack({Color color = Colors.black, required double fontSize}) {
  return TextStyle(
    color: color,
    fontSize: fontSize,
    fontFamily: 'Metropolis',
    fontWeight: FontWeight.w900
  );
}