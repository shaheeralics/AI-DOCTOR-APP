import 'package:flutter/material.dart';

// Medical Theme Colors
const kBackgroundColor = Color(0xFFF7F9FC); // Light medical background
const kBackgroundGradientEnd = Color(0xFFE3F2FD); // Gradient end color
const kPrimaryColor = Color(0xFF2D5D70); // Keep existing dark color for text
const kSecondaryColor = Color(0xFF265DAB); // Keep existing blue
const kMedicalBlue = Color(0xFF00B4D8); // New medical blue
const kMedicalBlueLight = Color(0xFF48CAE4); // Lighter medical blue
const kCardBackground = Color(0xFFFFFFFF); // Pure white for cards
const kTextPrimary = Color(0xFF212121); // Primary text color
const kTextSecondary = Color(0xFF6C757D); // Secondary text color

// Gradient Colors
final kMedicalGradient = LinearGradient(
  colors: [Color.fromARGB(255, 0, 180, 216), kSecondaryColor],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

final kBackgroundGradient = LinearGradient(
  colors: [kBackgroundColor, kBackgroundGradientEnd],
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
);
