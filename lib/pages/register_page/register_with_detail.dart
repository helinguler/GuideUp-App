import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:guide_up/core/constant/color_constants.dart';
import 'package:guide_up/core/constant/router_constants.dart';
import 'package:guide_up/core/models/users/user_detail/user_detail_model.dart';
import 'package:guide_up/service/user/user_detail/user_detail_service.dart';
import 'package:guide_up/ui/material/custom_material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class RegisterWithDetail extends StatefulWidget {
  const RegisterWithDetail({Key? key}) : super(key: key);

  @override
  State<RegisterWithDetail> createState() => _RegisterWithDetailState();
}

class _RegisterWithDetailState extends State<RegisterWithDetail> {
  late TextEditingController _nameController;
  late TextEditingController _surnameController;
  late TextEditingController _birthdayController;
  late TextEditingController _aboutController;

  //late TextEditingController _photoController;
  late TextEditingController _phoneController;
  DateTime selectedDate = DateTime.now();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  File? _profilePicture;
  final ImagePicker _imagePicker = ImagePicker();
  late String userId;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _surnameController = TextEditingController();
    _birthdayController = TextEditingController();
    _aboutController = TextEditingController();
    //_photoController = TextEditingController();
    _phoneController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _surnameController.dispose();
    _birthdayController.dispose();
    _aboutController.dispose();
    //_photoController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _submitUserDetail(BuildContext context) async {
    List<String> unfilledFields = [];

    if (_nameController.text.isEmpty) {
      unfilledFields.add("İsim");
    }
    if (_surnameController.text.isEmpty) {
      unfilledFields.add("Soyisim");
    }
    if (_birthdayController.text.isEmpty) {
      unfilledFields.add("Doğum Tarihi");
    }
    if (_aboutController.text.isEmpty) {
      unfilledFields.add("Hakkımda");
    }
    /* if (_photoController.text.isEmpty) {
      unfilledFields.add("Resim Ekle");
    }*/
    if (_phoneController.text.isEmpty) {
      unfilledFields.add("Telefon Numarası");
    }

    if (unfilledFields.isNotEmpty) {
      String unfilledFieldsMessage =
          "Lütfen aşağıdaki alanları doldurun: " + unfilledFields.join(", ");
      CustomMaterial.sendNotification(context, unfilledFieldsMessage);
      _showSnackBar(unfilledFieldsMessage);
      return;
    }

    String name = _nameController.text;
    String surname = _surnameController.text;
    String about = _aboutController.text;
    String phone = _phoneController.text;

    UserDetail userDetail = UserDetail();
    userDetail.setUserId(userId);
    userDetail.setName(name);
    userDetail.setSurname(surname);
    userDetail.setBirthday(selectedDate);
    userDetail.setAbout(about);
    userDetail.setPhone(phone);
    if (_profilePicture != null) {
      userDetail.setPhoto(_profilePicture!.path);
    }

    try {
      UserDetailService().add(userDetail).then((value) => {
            if (value.getId() != null)
              {
                Navigator.pushReplacementNamed(
                  context,
                  RouterConstants.homePage,
                )
              }
          });
    } catch (e) {
      _showSnackBar('An error occurred while saving user detail');
    }
  }

  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      selectedDate = picked;
      setState(() {
        _birthdayController.text =
            DateFormat('dd-MM-yyyy').format(selectedDate);
      });
    }
  }

  void _showSnackBar(String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await _imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _profilePicture = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    userId = ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        decoration: CustomMaterial.backgroundRegisterWithLoginDecoration,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      ColorConstants.darkBack,
                      ColorConstants.darkBack,
                    ],
                  ),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(50),
                    topLeft: Radius.circular(50),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Text(' KAYIT OLUN ',
                                  style: GoogleFonts.nunito(
                                    textStyle: const TextStyle(
                                      color: ColorConstants.textwhite,
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )),
                              Image.asset(
                                'assets/logo/title.png',
                                height: 100,
                                width: 100,
                                alignment: Alignment.center,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        GestureDetector(
                          onTap: _pickImage,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              CircleAvatar(
                                radius: 60.0,
                                backgroundColor: ColorConstants.buttonPurple,
                                // Arka plan rengi
                                backgroundImage: getImage(),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          height: 50,
                          margin: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 20),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 5),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: ColorConstants.buttonPink, width: 1),
                            boxShadow: const [
                              BoxShadow(
                                color: ColorConstants.buttonPink,
                                blurRadius: 10,
                                offset: Offset(1, 1),
                              ),
                            ],
                            color: ColorConstants.background,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(20),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              ShaderMask(
                                blendMode: BlendMode.srcATop,
                                shaderCallback: (Rect bounds) {
                                  return const LinearGradient(
                                    colors: [
                                      ColorConstants.buttonPurple,
                                      ColorConstants.buttonPink
                                    ],
                                  ).createShader(bounds);
                                },
                                child: const Icon(Icons.person),
                              ),
                              Expanded(
                                child: Container(
                                  margin: const EdgeInsets.only(left: 10),
                                  child: TextFormField(
                                    controller: _nameController,
                                    obscureText: false,
                                    maxLines: 1,
                                    decoration: const InputDecoration(
                                      border: UnderlineInputBorder(),
                                      hintText: "İsim ",
                                      hintStyle: TextStyle(
                                          color: ColorConstants.textwhite),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          width: double.infinity,
                          height: 50,
                          margin: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 20),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 5),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: ColorConstants.buttonPink, width: 1),
                            boxShadow: const [
                              BoxShadow(
                                color: ColorConstants.buttonPink,
                                blurRadius: 10,
                                offset: Offset(1, 1),
                              ),
                            ],
                            color: ColorConstants.background,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(20),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              ShaderMask(
                                blendMode: BlendMode.srcATop,
                                shaderCallback: (Rect bounds) {
                                  return const LinearGradient(
                                    colors: [
                                      ColorConstants.buttonPurple,
                                      ColorConstants.buttonPink
                                    ],
                                  ).createShader(bounds);
                                },
                                child: const Icon(Icons.person),
                              ),
                              Expanded(
                                child: Container(
                                  margin: const EdgeInsets.only(left: 10),
                                  child: TextFormField(
                                    controller: _surnameController,
                                    obscureText: false,
                                    maxLines: 1,
                                    decoration: const InputDecoration(
                                      border: UnderlineInputBorder(),
                                      hintText: "Soyisim  ",
                                      hintStyle: TextStyle(
                                          color: ColorConstants.textwhite),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          width: double.infinity,
                          height: 50,
                          margin: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 20),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 5),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: ColorConstants.buttonPink, width: 1),
                            boxShadow: const [
                              BoxShadow(
                                color: ColorConstants.buttonPink,
                                blurRadius: 10,
                                offset: Offset(1, 1),
                              ),
                            ],
                            color: ColorConstants.background,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(20),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              ShaderMask(
                                blendMode: BlendMode.srcATop,
                                shaderCallback: (Rect bounds) {
                                  return const LinearGradient(
                                    colors: [
                                      ColorConstants.buttonPurple,
                                      ColorConstants.buttonPink
                                    ],
                                  ).createShader(bounds);
                                },
                                child: const Icon(Icons.tab),
                              ),
                              Expanded(
                                child: Container(
                                  margin: const EdgeInsets.only(left: 10),
                                  child: TextFormField(
                                    controller: _aboutController,
                                    obscureText: false,
                                    maxLines: 1,
                                    decoration: const InputDecoration(
                                      border: UnderlineInputBorder(),
                                      hintText: "Hakkımda   ",
                                      hintStyle: TextStyle(
                                          color: ColorConstants.textwhite),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          width: double.infinity,
                          height: 50,
                          margin: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 20),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 5),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: ColorConstants.buttonPink, width: 1),
                            boxShadow: const [
                              BoxShadow(
                                color: ColorConstants.buttonPink,
                                blurRadius: 10,
                                offset: Offset(1, 1),
                              ),
                            ],
                            color: ColorConstants.background,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(20),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              ShaderMask(
                                blendMode: BlendMode.srcATop,
                                shaderCallback: (Rect bounds) {
                                  return const LinearGradient(
                                    colors: [
                                      ColorConstants.buttonPurple,
                                      ColorConstants.buttonPink
                                    ],
                                  ).createShader(bounds);
                                },
                                child: const Icon(Icons.phone),
                              ),
                              Expanded(
                                child: Container(
                                  margin: const EdgeInsets.only(left: 10),
                                  child: TextFormField(
                                    controller: _phoneController,
                                    obscureText: false,
                                    maxLines: 1,
                                    decoration: const InputDecoration(
                                      border: UnderlineInputBorder(),
                                      hintText: "Telefon Numarası  ",
                                      hintStyle: TextStyle(
                                          color: ColorConstants.textwhite),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          width: double.infinity,
                          height: 50,
                          margin: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 20),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 5),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: ColorConstants.buttonPink, width: 1),
                            boxShadow: const [
                              BoxShadow(
                                color: ColorConstants.buttonPink,
                                blurRadius: 10,
                                offset: Offset(1, 1),
                              ),
                            ],
                            color: ColorConstants.background,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(20),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              ShaderMask(
                                blendMode: BlendMode.srcATop,
                                shaderCallback: (Rect bounds) {
                                  return const LinearGradient(
                                    colors: [
                                      ColorConstants.buttonPurple,
                                      ColorConstants.buttonPink
                                    ],
                                  ).createShader(bounds);
                                },
                                child: const Icon(Icons.date_range),
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () => _selectDate(context),
                                  child: AbsorbPointer(
                                    child: TextFormField(
                                      controller: _birthdayController,
                                      obscureText: false,
                                      maxLines: 1,
                                      decoration: const InputDecoration(
                                        border: UnderlineInputBorder(),
                                        hintText: "Doğum Tarihi  ",
                                        hintStyle: TextStyle(
                                            color: ColorConstants.textwhite),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          width: 320,
                          child: ElevatedButton(
                            onPressed: () => _submitUserDetail(context),
                            style: ElevatedButton.styleFrom(
                              shadowColor: ColorConstants.buttonPink,
                              elevation: 18,
                              padding: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: Ink(
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    ColorConstants.buttonPink,
                                    ColorConstants.buttonPurple,
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Container(
                                width: 400,
                                height: 40,
                                alignment: Alignment.center,
                                child: Text('Kayıt Ol',
                                    style: GoogleFonts.nunito(
                                      textStyle: const TextStyle(
                                        fontSize: 25,
                                        color: ColorConstants.textwhite,
                                      ),
                                    )),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  ImageProvider<Object> getImage() {
    if (_profilePicture != null) {
      return FileImage(_profilePicture!);
    } else {
      return const AssetImage("assets/img/unknown_user.png");
    }
  }
}
