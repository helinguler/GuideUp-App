import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:guide_up/core/enumeration/enums/EnEmploymentType.dart';
import 'package:guide_up/core/enumeration/enums/EnLocationType.dart';
import 'package:guide_up/core/enumeration/extensions/ExEmploymentType.dart';
import 'package:guide_up/core/enumeration/extensions/ExLocationType.dart';

import '../../../../core/constant/color_constants.dart';
import '../../../../core/models/users/user_experience/user_experience_model.dart';
import '../../../../core/utils/control_helper.dart';
import '../../../../core/utils/secure_storage_helper.dart';
import '../../../../core/utils/user_info_helper.dart';
import '../../../../repository/user/user_experience/user_experience_repository.dart';
import '../../../../ui/material/custom_material.dart';

class ExperiencePage extends StatefulWidget {
  const ExperiencePage({Key? key}) : super(key: key);

  @override
  State<ExperiencePage> createState() => _ExperiencePageState();
}

class _ExperiencePageState extends State<ExperiencePage> {
  UserExperience? userExperience;
  EnEmploymentType? selectedEmploymentType;
  EnLocationType? selectedLocationType;
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();
  TextEditingController companyNameController = TextEditingController();
  TextEditingController jobTitleController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController industryController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController linkController = TextEditingController();

  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();

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
        userId = tempUserId;
        setState(() {});
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
        startDateController.text = UserInfoHelper.dateFormat.format(startDate);
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
        endDateController.text = UserInfoHelper.dateFormat.format(endDate);
      });
    }
  }

  void addUserExperience(BuildContext contextMain) async {
    String companyName = companyNameController.text.trim();
    String jobTitle = jobTitleController.text.trim();
    String locationTitle = locationController.text.trim();
    String industryTitle = industryController.text.trim();
    String startDateText = startDateController.text.trim();
    String endDateText = endDateController.text.trim();
    String description = descriptionController.text.trim();
    String link = linkController.text.trim();
    String error = "";

    if (companyName.isEmpty ||
        locationTitle.isEmpty ||
        industryTitle.isEmpty ||
        jobTitle.isEmpty ||
        description.isEmpty ||
        startDateText.isEmpty ||
        selectedEmploymentType == null ||
        selectedLocationType == null) {
      error = "Lütfen Tüm alanları doldurunuz.";
    } else if (link.isNotEmpty && !UserInfoHelper.hasValidUrl(link)) {
      error = "Lütfen URL bilgisini doğru formatta giriniz.";
    }
    if (error.isNotEmpty) {
      showDialog(
        context: contextMain,
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

    UserExperience userExperience = UserExperience();
    userExperience.setUserId(userId!);
    userExperience.setJobTitle(jobTitle);
    userExperience.setCompanyName(companyName);
    userExperience.setLocation(locationTitle);
    userExperience.setEnLocationType(selectedLocationType!);
    userExperience.setEnEmploymentType(selectedEmploymentType!);
    userExperience.setIndustry(industryTitle);
    userExperience.setStartDate(startDate);
    if (endDateText.isNotEmpty) {
      userExperience.setEndDate(endDate);
    }
    userExperience.setDescription(description);
    userExperience.setLink(link);

    try {
      await UserExperienceRepository().add(userExperience);

      setState(() {
        jobTitleController.clear();
        companyNameController.clear();
        locationController.clear();
        industryController.clear();
        startDateController.clear();
        endDateController.clear();
        descriptionController.clear();
        linkController.clear();
        selectedLocationType = null;
        selectedEmploymentType = null;
      });

      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (BuildContext context2) {
          return AlertDialog(
            title: Text(
              'Başarılı',
              style: GoogleFonts.nunito(
                color: ColorConstants.itemWhite,
              ),
            ),
            content: Text(
              'Tecrübe başarıyla eklendi.',
              style: GoogleFonts.nunito(
                color: ColorConstants.success,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context2).pop();
                  Navigator.of(contextMain).pop();
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

      print('Experience added to Firebase: $userExperience');
    } catch (error) {
      print('Failed to add experience to Firebase: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorConstants.darkBack, // AppBar arka plan rengi
        title: Text(
          'Tecrübe',
          style: GoogleFonts.nunito(
            // Yetenekler yazısının yazı tipi
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        decoration: CustomMaterial.backgroundBoxDecoration,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Başlık',
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
                controller: jobTitleController,
                cursorColor: ColorConstants.textwhite, // İmleç rengi
                onChanged: (value) {
                  setState(() {});
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Firma Adı',
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
                controller: companyNameController,
                cursorColor: ColorConstants.textwhite, // İmleç rengi
                onChanged: (value) {
                  setState(() {});
                },
              ),
              const SizedBox(height: 16.0),
              Text(
                "istihdam Şekli :",
                style: GoogleFonts.nunito(
                  fontSize: 15,
                  //fontWeight: FontWeight.bold,
                  color: ColorConstants.buttonPurple,
                ),
              ),
              DropdownButton<EnEmploymentType>(
                focusColor: ColorConstants.buttonPurple,
                value: selectedEmploymentType,
                style: GoogleFonts.nunito(color: ColorConstants.buttonPurple),
                dropdownColor: ColorConstants.background,
                isExpanded: true,
                onChanged: (EnEmploymentType? value) {
                  selectedEmploymentType = value!;
                  setState(() {});
                },
                items: EnEmploymentType.values
                    .map<DropdownMenuItem<EnEmploymentType>>(
                        (EnEmploymentType value) {
                  return DropdownMenuItem<EnEmploymentType>(
                    value: value,
                    child: Text(value.getDisplayname()),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Konum',
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
                controller: locationController,
                cursorColor: ColorConstants.textwhite, // İmleç rengi
                onChanged: (value) {
                  setState(() {});
                },
              ),
              const SizedBox(height: 16.0),
              Text(
                "Konum Türü :",
                style: GoogleFonts.nunito(
                  fontSize: 15,
                  //fontWeight: FontWeight.bold,
                  color: ColorConstants.buttonPurple,
                ),
              ),
              DropdownButton<EnLocationType>(
                focusColor: ColorConstants.buttonPurple,
                value: selectedLocationType,
                style: GoogleFonts.nunito(color: ColorConstants.buttonPurple),
                dropdownColor: ColorConstants.background,
                isExpanded: true,
                onChanged: (EnLocationType? value) {
                  selectedLocationType = value!;
                  setState(() {});
                },
                items: EnLocationType.values
                    .map<DropdownMenuItem<EnLocationType>>(
                        (EnLocationType value) {
                  return DropdownMenuItem<EnLocationType>(
                    value: value,
                    child: Text(value.getDisplayName()),
                  );
                }).toList(),
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
                  labelText: 'Sektör',
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
                controller: industryController,
                cursorColor: ColorConstants.textwhite, // İmleç rengi
                onChanged: (value) {
                  setState(() {});
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Tecrübe linki (isteğe bağlı)',
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
              ElevatedButton(
                onPressed: () {
                  addUserExperience(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      ColorConstants.appcolor2, // Arka plan rengi
                ),
                child: Text(
                  'Kaydet',
                  style: GoogleFonts.nunito(
                    color: ColorConstants.textwhite, // Yazı rengi
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void setValues() {
    if (userExperience!.getStartDate() != null) {
      startDate = userExperience!.getStartDate()!;
      startDateController.text = ControlHelper.checkInputValue(
          UserInfoHelper.dateFormat.format(userExperience!.getStartDate()!));
    }
    if (userExperience!.getEndDate() != null) {
      endDate = userExperience!.getEndDate()!;
      endDateController.text = ControlHelper.checkInputValue(
          UserInfoHelper.dateFormat.format(userExperience!.getEndDate()!));
    }
  }
}
