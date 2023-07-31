import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constant/color_constants.dart';
import '../../../../core/utils/secure_storage_helper.dart';

class MentorAccountInformation extends StatefulWidget {
  const MentorAccountInformation({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _MentorAccountInformationState createState() =>
      _MentorAccountInformationState();
}

class _MentorAccountInformationState extends State<MentorAccountInformation> {
  String? userId;

  @override
  void initState() {
    super.initState();
    getUserId();
  }

  void getUserId() async {
    if (userId == null) {
      String? tempUserId = await SecureStorageHelper().getUserId();
      if (tempUserId != null) {
        setState(() {
          userId = tempUserId;
        });
      } else {
        // Kullanıcı oturum açmamışsa veya kimlik doğrulama kullanmıyorsanız,
        // userId değerini uygun şekilde ayarlamanız gerekecektir.
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorConstants.darkBack,
        title: Text(
          'Hesap Bilgileri',
          style: GoogleFonts.nunito(
            // Yetenekler yazısının yazı tipi
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: ColorConstants.buttonPurple, // Geri buton rengi
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: ColorConstants.darkBack,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              decoration: InputDecoration(
                labelText: 'IBAN Sahibi Adı Soyadı',
                floatingLabelStyle: GoogleFonts.nunito(
                  color: ColorConstants.textwhite, // Metin rengi
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(color: ColorConstants.background), // Kutunun çevresi rengi
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: ColorConstants.appcolor2), // Odaklandığında kutunun çevresi rengi
                  borderRadius: BorderRadius.circular(8.0),
                ),
                filled: true,
                fillColor: ColorConstants.background, // Kutunun iç dolgu rengi
                labelStyle: GoogleFonts.nunito(
                  color: ColorConstants.textwhite, // Metin rengi
                ),
              ),
              cursorColor: ColorConstants.buttonPurple,
              onChanged: (value) {
                setState(() {});
              },
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'IBAN Numarası',
                floatingLabelStyle: GoogleFonts.nunito(
                  color: ColorConstants.textwhite, // Metin rengi
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(color: ColorConstants.background), // Kutunun çevresi rengi
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: ColorConstants.appcolor2), // Odaklandığında kutunun çevresi rengi
                  borderRadius: BorderRadius.circular(8.0),
                ),
                filled: true,
                fillColor: ColorConstants.background, // Kutunun iç dolgu rengi
                labelStyle: GoogleFonts.nunito(
                  color: ColorConstants.textwhite, // Metin rengi
                ),
              ),
              cursorColor: ColorConstants.buttonPurple,
              onChanged: (value) {
                setState(() {});
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                setState(() {});
              },
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 75),
                backgroundColor: ColorConstants.buttonPurple, // Arka plan rengi
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Güncelle',
                style: GoogleFonts.nunito(
                  fontSize: 16,
                  color: ColorConstants.itemWhite,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 60.0),
              child: Image.asset(
                'assets/logo/guideUpLogo.png',
                width: 400,
                height: 400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
