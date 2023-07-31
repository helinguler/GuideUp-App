import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:guide_up/core/utils/secure_storage_helper.dart';
import 'package:intl/intl.dart';
import '../../../../core/constant/color_constants.dart';
import '../../../../core/enumeration/extensions/ExLanguage.dart';
import '../../../../core/models/users/user_education/user_education_model.dart';
import '../../../../core/utils/user_info_helper.dart';
import '../../../../repository/user/user_education/user_education_repository.dart';

class UserEducationInformationPage extends StatefulWidget {
  const UserEducationInformationPage({Key? key}) : super(key: key);

  @override
  State<UserEducationInformationPage> createState() =>
      _UserEducationInformationPageState();
}

class _UserEducationInformationPageState
    extends State<UserEducationInformationPage> {
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();
  final dateFormat = DateFormat('dd.MM.yyyy');
  TextEditingController schoolController = TextEditingController();
  TextEditingController departmentController = TextEditingController();
  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();
  TextEditingController gradeController = TextEditingController();
  TextEditingController activitiesSocietiesController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController linkController = TextEditingController();
  TextEditingController enlanguageController = TextEditingController();

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

  void addEducationInformation() async {
    String school = schoolController.text.trim();
    String department = departmentController.text.trim();
    String startDateText = startDateController.text.trim();
    String endDateText = endDateController.text.trim();
    String grade = gradeController.text.trim();
    String activitiesSocieties = activitiesSocietiesController.text.trim();
    String description = descriptionController.text.trim();
    String link = linkController.text.trim();
    String language = enlanguageController.text.trim();
    String error = "";

    if (school.isEmpty || startDateText.isEmpty || description.isEmpty) {
      error =
          "deneyim kimliği, Proje adı, başlangıç tarihi  ve açıklama alanları boş bırakılamaz.";
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

    UserEducation userEducationInformation = UserEducation();
    userEducationInformation.setUserId(userId!);
    userEducationInformation.setSchoolName(school);
    userEducationInformation.setDepartment(department);
    userEducationInformation.setStartDate(startDate);
    if (endDateText.isNotEmpty) {
      userEducationInformation.setEndDate(endDate);
    }
    userEducationInformation.setGrade(grade);
    userEducationInformation.setActivitiesSocienties(activitiesSocieties);
    userEducationInformation.setDescription(description);
    userEducationInformation.setLink(link);
    userEducationInformation.setEnLanguage(ExLanguage.getEnum(language));

    try {
      await UserEducationInformationRepository().add(userEducationInformation);

      setState(() {
        schoolController.clear();
        departmentController.clear();
        startDateController.clear();
        endDateController.clear();
        gradeController.clear();
        activitiesSocietiesController.clear();
        descriptionController.clear();
        linkController.clear();
        enlanguageController.clear();
      });

      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Başarı',
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
          'EducationInformation added to Firebase: $userEducationInformation');
    } catch (error) {
      print('Failed to add educationInformation to Firebase: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorConstants.darkBack,
        centerTitle: true,
        title: Text(
          'Eğitim Bilgileri',
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
      backgroundColor: ColorConstants.darkBack,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Okul Adı',
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
              controller: schoolController,
              cursorColor: ColorConstants.textwhite, // İmleç rengi
              onChanged: (value) {
                setState(() {});
              },
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Departman (isteğe bağlı)',
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
              controller: departmentController,
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
                labelText: 'Sınıf (isteğe bağlı)',
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
              controller: gradeController,
              cursorColor: ColorConstants.textwhite, // İmleç rengi
              onChanged: (value) {
                setState(() {});
              },
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Aktiviteler/Sosyal Faaliyetler (isteğe bağlı)',
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
              controller: activitiesSocietiesController,
              cursorColor: ColorConstants.textwhite, // İmleç rengi
              onChanged: (value) {
                setState(() {});
              },
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Açıklama',
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
              controller: descriptionController,
              cursorColor: ColorConstants.textwhite, // İmleç rengi
              onChanged: (value) {
                setState(() {});
              },
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Bağlantı (isteğe bağlı)',
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
              cursorColor: ColorConstants.textwhite, // İmleç rengi
              onChanged: (value) {
                setState(() {});
              },
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Dil Bilgisi (isteğe bağlı)',
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
              controller: enlanguageController,
              cursorColor: ColorConstants.textwhite, // İmleç rengi
              onChanged: (value) {
                setState(() {});
              },
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                addEducationInformation();
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
