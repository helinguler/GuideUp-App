import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constant/color_constants.dart';
import '../../../core/constant/router_constants.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'General Settings',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.light, // Varsayılan olarak açık tema
        textTheme: GoogleFonts.nunitoTextTheme(),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark, // Koyu tema ayarı
        textTheme: GoogleFonts.nunitoTextTheme(),
      ),
      home: const GeneralSettings(),
    );
  }
}

class GeneralSettings extends StatefulWidget {
  const GeneralSettings({Key? key}) : super(key: key);

  @override
  State<GeneralSettings> createState() => _GeneralSettingsState();
}

class _GeneralSettingsState extends State<GeneralSettings> {
  bool _isPasswordChanged = false;
  bool _isDarkThemeEnabled = false; // Koyu tema durumu

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorConstants.darkBack,
        title: Text(
          'Genel Ayarlar',
          style: GoogleFonts.nunito(
              fontSize: 24.0,
              fontWeight: FontWeight.bold
          ),

        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: ColorConstants.buttonPurple, // Geri buton rengi
          ),
          onPressed: () {
            Navigator.pushNamed(context, RouterConstants.profilePage);
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Image.asset(
              'assets/logo/guideUpLogo.png', // Logo
              width: 62,
              height: 62,
            ),
          ),
        ],
      ),
      body: Container(
        color: ColorConstants.darkBack ,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16.0),
              _buildPasswordSection(),
              const SizedBox(height: 16.0),
              _buildLanguageSection(),
              const SizedBox(height: 16.0),
              _buildPhoneNumberSection(),
              const SizedBox(height: 16.0),
              _buildThemeSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Şifre Yenile',
          style: GoogleFonts.nunito(
              fontSize: 18.0,
              fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8.0),
        TextField(
          decoration: InputDecoration(
            labelText: 'Mevcut şifre',
            floatingLabelStyle: GoogleFonts.nunito(
              color: ColorConstants.textwhite, // Metin rengi
            ),
            border: const OutlineInputBorder(
              borderSide: BorderSide(color: ColorConstants.background), // Kutunun çevresi rengi
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: ColorConstants.appcolor2), // Odaklandığında kutunun çevresi rengi
            ),
            prefixIcon: const Icon(
              Icons.lock_outlined,
              color: ColorConstants.appcolor2, // Icon rengi
            ),
            filled: true,
            fillColor: ColorConstants.background, // Kutunun iç dolgu rengi
            labelStyle: GoogleFonts.nunito(
              color: ColorConstants.textwhite, // Metin rengi
            ),
          ),
          cursorColor: ColorConstants.textwhite, // İmleç rengi
        ),
        const SizedBox(height: 8.0),
        TextField(
          decoration: InputDecoration(
            labelText: 'Yeni şifre',
            floatingLabelStyle: GoogleFonts.nunito(
              color: ColorConstants.textwhite, // Metin rengi
            ),
            border: const OutlineInputBorder(
              borderSide: BorderSide(color: ColorConstants.background), // Kutunun çevresi rengi
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: ColorConstants.appcolor2), // Odaklandığında kutunun çevresi rengi
            ),
            prefixIcon: const Icon(
              Icons.lock,
              color: ColorConstants.appcolor2, // Icon rengi
            ),
            filled: true,
            fillColor: ColorConstants.background, // Kutunun iç dolgu rengi
            labelStyle: GoogleFonts.nunito(
              color: ColorConstants.textwhite, // Metin rengi
            ),
          ),
          cursorColor: ColorConstants.textwhite, // İmleç rengi
        ),
        const SizedBox(height: 8.0),
        TextField(
          decoration: InputDecoration(
            labelText: 'Şifreyi tekrar yaz',
            floatingLabelStyle: GoogleFonts.nunito(
              color: ColorConstants.textwhite, // Metin rengi
    ),
            border: const OutlineInputBorder(
              borderSide: BorderSide(color: ColorConstants.background), // Kutunun çevresi rengi
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: ColorConstants.appcolor2), // Odaklandığında kutunun çevresi rengi
            ),
            prefixIcon: const Icon(
              Icons.lock_outlined,
              color: ColorConstants.appcolor2, // Icon rengi
            ),
            filled: true,
            fillColor: ColorConstants.background, // Kutunun iç dolgu rengi
            labelStyle: GoogleFonts.nunito(
              color: ColorConstants.textwhite, // Metin rengi
            ),
          ),
          cursorColor: ColorConstants.textwhite, // İmleç rengi
        ),
        const SizedBox(height: 1.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: () {

              },
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(ColorConstants.appcolor2), // Buton metin rengi
              ),
              child: Text('Şifremi Unuttum',
                style: GoogleFonts.nunito(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _isPasswordChanged = true;
                });
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(ColorConstants.buttonPurple), // Buton arkaplan rengi
                foregroundColor: MaterialStateProperty.all<Color>(ColorConstants.textwhite), // Buton yazı rengi
              ),
              child: Text('Şifreyi Yenile',
                style: GoogleFonts.nunito(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),),
            ),

          ],
        ),
        const SizedBox(height: 8.0),
        if (_isPasswordChanged)
          Text(
            'Şifre değiştirme başarılı!',
            style: GoogleFonts.nunito(
                color: ColorConstants.appcolor2),
          ),
      ],
    );
  }

  Widget _buildLanguageSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Dil Değiştir',
          style: GoogleFonts.nunito(
              fontSize: 18.0,
              fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8.0),
        DropdownButton<String>(
          value: 'Türkçe', // Varsayılan dil seçeneği
          onChanged: (String? newValue) {
            // Dil seçildiğinde yapılacak işlemler
          },
          items: <String>['Türkçe', 'İngilizce']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildPhoneNumberSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Telefon Numarası',
          style: GoogleFonts.nunito(
              fontSize: 18.0,
              fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8.0),
        TextField(
          decoration: InputDecoration(
            labelText: 'Telefon Numarası Gir',
            floatingLabelStyle: GoogleFonts.nunito(
              color: ColorConstants.textwhite, // Metin rengi
            ),
            border: const OutlineInputBorder(
              borderSide: BorderSide(color: ColorConstants.background), // Kutunun çevresi rengi
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: ColorConstants.appcolor2), // Odaklandığında kutunun çevresi rengi
            ),
            prefixIcon: const Icon(
              Icons.phone,
              color: ColorConstants.appcolor2, // Icon rengi
            ),
            filled: true,
            fillColor: ColorConstants.background, // Kutunun iç dolgu rengi
            labelStyle: GoogleFonts.nunito(
              color: ColorConstants.textwhite, // Metin rengi
            ),
          ),
          cursorColor: ColorConstants.textwhite, // İmleç rengi
        ),
      ],
    );
  }

  Widget _buildThemeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tema Ayarları',
          style: GoogleFonts.nunito(fontSize: 18.0, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8.0),
        SwitchListTile(
          title: Text('Koyu Tema',
            style: GoogleFonts.nunito(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),),
          value: _isDarkThemeEnabled,
          onChanged: (bool newValue) {
            setState(() {
              _isDarkThemeEnabled = newValue;
            });
          },
          secondary: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: ColorConstants.itemBlack.withOpacity(0.14),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: IconTheme(
              data: IconThemeData(
                color: _isDarkThemeEnabled ? ColorConstants.appcolor1 : ColorConstants.appcolor2, // Icon rengi
              ),
              child: const Icon(Icons.brightness_4),
            ),
          ),
          activeColor: ColorConstants.buttonPurple, // Koyu tema etkinleştirildiğindeki renk
          activeTrackColor: ColorConstants.background, // Koyu tema etkinleştirildiğindeki renk
          inactiveThumbColor: ColorConstants.background, // Koyu tema devre dışı bırakıldığında başlığın rengi
          inactiveTrackColor: ColorConstants.buttonPurple, // Koyu tema devre dışı bırakıldığında iz sürücü rengi
        ),

      ],
    );
  }
}
