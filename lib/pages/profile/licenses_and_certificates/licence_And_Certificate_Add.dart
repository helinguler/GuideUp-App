import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../core/constant/color_constants.dart';
import '../../../core/models/users/user_license_and_certificate/user_license_and_certificate_model.dart';
import '../../../core/utils/secure_storage_helper.dart';
import '../../../core/utils/user_info_helper.dart';
import '../../../repository/user/user_licence_and_certificate/user_licence_and_certificate_repository.dart';

class LicenseAndCertificateAddPage extends StatefulWidget {
  const LicenseAndCertificateAddPage({Key? key}) : super(key: key);

  @override
  State<LicenseAndCertificateAddPage> createState() =>
      _LicenseAndCertificateAddPageState();
}

class _LicenseAndCertificateAddPageState extends State<LicenseAndCertificateAddPage> {
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();
  final dateFormat = DateFormat('dd.MM.yyyy');
  TextEditingController licenseNameController = TextEditingController();
  TextEditingController organizationController = TextEditingController();
  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();
  TextEditingController authorizationIdController = TextEditingController();
  TextEditingController linkController = TextEditingController();

  String? userId;

  @override
  void initState() {
    super.initState();
    getUserId();
    startDateController = TextEditingController(
      text: UserInfoHelper.dateFormat.format(startDate),
    );
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

  Future<void> showDatePickerDialog() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData(
            colorScheme: const ColorScheme.light(
              primary: ColorConstants.theme1Dark,
            ),
            dialogBackgroundColor: ColorConstants.itemWhite,
          ),
          child: child ?? const Text(""),
        );
      },
      initialDate: startDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null && pickedDate != startDate) {
      setState(() {
        startDate = pickedDate;
        startDateController.text = dateFormat.format(startDate);
      });
    }
  }

  Future<void> showDatePickerDialog2() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData(
            colorScheme: const ColorScheme.light(
              primary: ColorConstants.theme1Dark,
            ),
            dialogBackgroundColor: ColorConstants.itemWhite,
          ),
          child: child ?? const Text(""),
        );
      },
      initialDate: endDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null && pickedDate != endDate) {
      setState(() {
        endDate = pickedDate;
        endDateController.text = dateFormat.format(endDate);
      });
    }
  }

  void addLicenseAndCertificate() async {
    String licenseName = licenseNameController.text.trim();
    String organization = organizationController.text.trim();
    String startDateText = startDateController.text.trim();
    String endDateText = endDateController.text.trim();
    String authorizationId = authorizationIdController.text.trim();
    String link = linkController.text.trim();
    String error = "";

    if (licenseName.isEmpty || startDateText.isEmpty || organization.isEmpty) {
      error =
      "Adı, Başlangıç Tarihi ve Veren organizasyon alanları boş bırakılamaz.";
    } else if (link.isNotEmpty && !UserInfoHelper.hasValidUrl(link)) {
      error = "Lütfen URL bilgisini doğru formatta giriniz.";
    }

    if (error.isNotEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Uyarı',
              style: GoogleFonts.nunito(
                color: ColorConstants.dangerDark,
              ),
            ),
            content: Text(
              error,
              style: GoogleFonts.nunito(
                color: ColorConstants.itemWhite,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Tamam',
                  style: GoogleFonts.nunito(
                    color: ColorConstants.itemWhite,
                  ),
                ),
              ),
            ],
            backgroundColor: ColorConstants.buttonPurple,
          );
        },
      );
      return;
    }
    UserLicenseAndCertificate userLicenseAndCertificate =
        UserLicenseAndCertificate();
    userLicenseAndCertificate.setUserId(userId!);
    userLicenseAndCertificate.setLicenseName(licenseName);
    userLicenseAndCertificate.setOrganization(organization);
    userLicenseAndCertificate.setStartDate(startDate);
    if(endDateText.isNotEmpty) {
      userLicenseAndCertificate.setEndDate(endDate); }
    userLicenseAndCertificate.setAuthorizationId(authorizationId);
    userLicenseAndCertificate.setLink(link);

    try {
      await UserLicenseAndCertificateRepository()
          .add(userLicenseAndCertificate);

      setState(() {
        licenseNameController.clear();
        organizationController.clear();
        startDateController.clear();
        endDateController.clear();
        authorizationIdController.clear();
        linkController.clear();
      });

      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Başarılı',
              style: GoogleFonts.nunito(
                color: ColorConstants.itemWhite,
              ),
            ),
            content: Text(
              'Eğitim bilgisi başarıyla eklendi.',
              style: GoogleFonts.nunito(
                color: ColorConstants.success,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Tamam',
                  style: GoogleFonts.nunito(
                    color: ColorConstants.itemWhite,
                  ),
                ),
              ),
            ],
            backgroundColor: ColorConstants.buttonPurple,
          );
        },
      );

      print(
          'LicenseAndCertificate added to Firebase: $userLicenseAndCertificate');
    } catch (error) {
      print('Failed to add licenseAndCertificate to Firebase: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.darkBack,
      appBar: AppBar(
        backgroundColor: ColorConstants.darkBack, // AppBar arka plan rengi
        centerTitle: true,
        title: Text(
          'Lisans ve sertifika',
          style: GoogleFonts.nunito(
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Adı',
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
              controller: licenseNameController,
              cursorColor: ColorConstants.textwhite, // İmleç rengi
              onChanged: (value) {
                setState(() {});
              },
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Veren Organizasyon',
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
              controller: organizationController,
              cursorColor: ColorConstants.textwhite, // İmleç rengi
              onChanged: (value) {
                setState(() {});
              },
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Başlangıç Tarihi',
                floatingLabelStyle: GoogleFonts.nunito(
                  color: ColorConstants.textwhite, // Metin rengi
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(color: ColorConstants.background), // Kutunun çevresi rengi
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: showDatePickerDialog,
                  color: ColorConstants.appcolor2, // Icon rengi
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
              readOnly: true,
              controller: startDateController,
              cursorColor: ColorConstants.textwhite, // İmleç rengi
              onChanged: (value) {
                setState(() {});
              },
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Bitiş Tarihi (isteğe bağlı)',
                floatingLabelStyle: GoogleFonts.nunito(
                  color: ColorConstants.textwhite, // Metin rengi
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(color: ColorConstants.background), // Kutunun çevresi rengi
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: showDatePickerDialog2,
                  color: ColorConstants.appcolor2, // Icon rengi
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
              readOnly: true,
              controller: endDateController,
              cursorColor: ColorConstants.textwhite, // İmleç rengi
              onChanged: (value) {
                setState(() {});
              },
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Yeterlilik kimliği (isteğe bağlı)',
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
              controller: authorizationIdController,
              cursorColor: ColorConstants.textwhite, // İmleç rengi
              onChanged: (value) {
                setState(() {});
              },
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              decoration: InputDecoration(
                labelText: "Yeterlilik URL'si (isteğe bağlı)",
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
              controller: linkController,
              cursorColor: ColorConstants.theme1Dark,
              onChanged: (value) {
                setState(() {});
              },
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                addLicenseAndCertificate();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    ColorConstants.buttonPurple, // Arka plan rengi
              ),
              child: Text(
                'Ekle',
                style: GoogleFonts.nunito(
                  color: ColorConstants.itemWhite, // Yazı rengi
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
