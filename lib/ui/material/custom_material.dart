import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/constant/color_constants.dart';

class CustomMaterial {
  static const backgroundBoxDecoration = BoxDecoration(
    gradient: LinearGradient(
      colors: ColorConstants.backgroundGradientColors,
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  );

  static const backgroundRegisterWithLoginDecoration = BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.bottomRight,
      end: Alignment.topCenter,
      colors: ColorConstants.backgroundRegisterWithLoginColors,
    ),
  );
  static const backgroundPinkPurple = BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.bottomRight,
      end: Alignment.topCenter,
      colors: ColorConstants.backgroundGradientColors2,
    ),
  );

  static Container appBarFlexibleSpace=Container(
    decoration: BoxDecoration(
      color: ColorConstants.darkBack, // Sabit arkaplan rengi
      boxShadow: [
        BoxShadow(
          color: ColorConstants.textGray.withOpacity(0.2), // Gölge rengi
          spreadRadius: 5, // Gölge yayılma yarıçapı
          blurRadius: 10, // Gölge bulanıklık yarıçapı
          offset: Offset(0, -2), // Gölge konumu (x,y)
        ),
      ],
    ),
  );

  static sendShortNotification(BuildContext context, String title) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: ColorConstants.buttonPurple,
        duration: const Duration(milliseconds: 200),
        content: Text(
          title,
          style: GoogleFonts.nunito(
            textStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: ColorConstants.background,
            ),
          ),
        ),
      ),
    );
  }

  static sendNotification(BuildContext context, String title) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: ColorConstants.buttonPurple,
        content: Text(
          title,
          style: GoogleFonts.nunito(
            textStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: ColorConstants.background,
            ),
          ),
        ),
      ),
    );
  }
}
