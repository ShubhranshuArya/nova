import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;


// Reusable text widget
Widget customText({
  required String text,
  required double size,
  required Color color,
  TextAlign alignment = TextAlign.left,
  FontWeight fontWeight = FontWeight.normal,
  bool isFirstCapital = false,
  double textHeight = 1.4,
}) {
  if (isFirstCapital) {
    text = text[0].toUpperCase() + text.substring(1);
  }
  return Text(
    text,
    style: GoogleFonts.poppins(
      color: color,
      fontSize: size,
      fontWeight: fontWeight,
      height: textHeight,
    ),
    textAlign: alignment,
  );
}

// Function to fetch username from email id.
String getUserName(String input) {
  List<String> parts = input.split('.');
  String firstWord = parts[0];
  String capitalizedFirstLetter = firstWord[0].toUpperCase();
  String capitalizedWord = capitalizedFirstLetter + firstWord.substring(1);

  return capitalizedWord;
}


// Function to manipulate balance text
String getCurrencyText(String currency, String value) {
  bool isNegative = false;
  if (value.startsWith('-')) {
    value = value.split('-')[1];
    isNegative = true;
  }
  switch (currency.toUpperCase()) {
    case 'INR':
      return isNegative ? '-₹$value' : '₹$value';
    case 'GBP':
      return isNegative ? '-£$value' : '£$value';
    case 'EUR':
      return isNegative ? '-€$value' : '€$value';
    case 'HKD':
      return isNegative ? '-HK\$$value' : 'HK\$$value';
    default:
      return isNegative
          ? '-$currency$value'
          : '$currency $value';
  }
}


// Function to validate bank logo url
Future<String> validateLogoUrl(String? logoUrl) async {
  try {
    final response = await http.get(Uri.parse(logoUrl!));
    if (response.statusCode == 200) {
      return logoUrl;
    } else {
      throw Exception('Failed to load image: ${response.statusCode}');
    }
  } catch (e) {
    debugPrint(e.toString());
  }
  return 'no_img';
}
