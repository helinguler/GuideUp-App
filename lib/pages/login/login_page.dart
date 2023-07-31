import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:guide_up/core/constant/color_constants.dart';
import 'package:guide_up/core/constant/router_constants.dart';
import 'package:guide_up/core/enumeration/enums/EnUserType.dart';
import 'package:guide_up/pages/login/fade_animation.dart';
import 'package:guide_up/repository/user/user_repository.dart';
import 'package:guide_up/service/user/user_service.dart';
import 'package:guide_up/ui/material/custom_material.dart';

import '../../core/utils/user_helper.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool passwordVisible = false;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void signInWithGoogle(BuildContext context) async {
    try {
      Map<EnUserType, UserCredential> userTypeMap =
          await UserService().getUserStatusSignInWithGoogle();

      if (userTypeMap.isNotEmpty) {
        var entryMap = userTypeMap.entries.first;

        EnUserType userType = entryMap.key;
        UserCredential fireUser = entryMap.value;

        if (fireUser.user == null) {
          // Giriş başarısız, hata mesajını ele alabilirsiniz
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                backgroundColor: ColorConstants.buttonPurple,
                title: const Text('Hata'),
                content:
                    const Text('Google ile giriş yaparken bir hata oluştu.'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Tamam',
                      style: TextStyle(
                        color: ColorConstants.textwhite,
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        } else {
          switch (userType) {
            case EnUserType.havenNotUserModel:

              String userId = await UserService().saveUserModelOnlyUidAndEmail(
                  fireUser.user!.uid, fireUser.user!.email!);
              Navigator.pushNamed(
                  context, RouterConstants.registerWithDetailPage,
                  arguments: userId);

              break;
            case EnUserType.havenNotUserDetail:
              UserRepository()
                  .getUserIdByUid(fireUser.user!.uid)
                  .then((value) =>  {
                        if (value != null) {
                          Navigator.pushNamed(
                              context, RouterConstants.registerWithDetailPage,
                              arguments: value)
                        }
                      });

              break;
            case EnUserType.haveUserDetail:
              Navigator.pushReplacementNamed(context, RouterConstants.homePage);
              break;
            default:
              break;
          }
        }
      }
    } catch (e) {
      // Hata oluştu, hata mesajını ele alabilirsiniz
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: ColorConstants.buttonPurple,
            title: const Text('Hata'),
            content: Text('Google ile giriş yaparken bir hata oluştu: $e'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  'Tamam',
                  style: TextStyle(
                    color: ColorConstants.textwhite,
                  ),
                ),
              ),
            ],
          );
        },
      );
    }
  }

  void signUserIn(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) {
        return Material(
          color: ColorConstants.buttonPurple,
          child: Center(
            child: Container(
              decoration: BoxDecoration(
                color: ColorConstants.buttonPink,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    spreadRadius: 5,
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(16),
              child: const CircularProgressIndicator(),
            ),
          ),
        );
      },
    );

    try {
      await UserHelper().login(emailController.text, passwordController.text);
      Navigator.pop(context);
      Navigator.pushNamed(context, RouterConstants.homePage);
    } catch (e) {
      Navigator.pop(context);
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: ColorConstants.buttonPurple,
            title: const Text('Hata'),
            content: Text('Şifre veya E-mail Hatalı Girildi'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  'Tamam',
                  style: TextStyle(color: ColorConstants.textwhite),
                ),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.darkBack,
      body: SafeArea(
        child: Center(
          child: Center(
            child: SingleChildScrollView(
              child: Container(
                decoration:
                    CustomMaterial.backgroundRegisterWithLoginDecoration,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //LOGO
                    const SizedBox(height: 10),
                    FadeAnimation(
                      0.5,
                      Image.asset(
                        scale: 3,
                        'assets/logo/guideUpLogoWithBackground.png',
                      ),
                    ),
                    //WELCOME BACK
                    const SizedBox(height: 5),
                     FadeAnimation(
                      1,
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 40),
                        child:
                          Text('GuideUp',
                       style: GoogleFonts.nunito(
                         textStyle: const TextStyle(
                           color: ColorConstants.textwhite,
                           fontSize: 30,
                           fontWeight: FontWeight.bold,
                         ),
                       ),
                      ),
                    ),
                     ),
                    const SizedBox(height: 10),
                     FadeAnimation(
                      1.5,
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 40),
                        child: Text(
                          'Seni Burada Görmek Güzel  ',
                          style: GoogleFonts.nunito(
                            textStyle: const TextStyle(
                              color: ColorConstants.textwhite,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                      ),
                    ),
                     ),
                    const SizedBox(height: 1),
                    //USERNAME TEXTfield
                    FadeAnimation(
                      2,
                      Container(
                          width: double.infinity,
                          height: 70,
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
                                    offset: Offset(1, 1)),
                              ],
                              color: ColorConstants.background,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(20))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                          ShaderMask(
                            blendMode: BlendMode.srcATop,
                            shaderCallback: (Rect bounds) {
                              return LinearGradient(
                                colors: [ColorConstants.buttonPurple,ColorConstants.buttonPink],
                              ).createShader(bounds);
                            },
                            child: Icon(Icons.email_outlined),
                          ),
                              Expanded(
                                child: Container(
                                  margin: const EdgeInsets.only(left: 10),
                                  child: TextFormField(
                                    controller: emailController,
                                    obscureText: false,
                                    maxLines: 1,
                                    decoration: const InputDecoration(
                                      label: Text(" E-mail ...",
                                      style: TextStyle(
                                        color:  ColorConstants.textwhite,
                                      ),),
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )),
                    ),

                    const SizedBox(height: 1),
                    //FORGOT PASSWORD ?
                    FadeAnimation(
                      2.5,
                      Container(
                        width: double.infinity,
                        height: 70,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 20),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 5),
                        decoration: BoxDecoration(
                            border:
                                Border.all(color: ColorConstants.buttonPink, width: 1),
                            boxShadow: const [
                              BoxShadow(
                                  color: ColorConstants.buttonPink,
                                  blurRadius: 10,
                                  offset: Offset(1, 1)),
                            ],
                            color: ColorConstants.background,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(20))),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            ShaderMask(
                              blendMode: BlendMode.srcATop,
                              shaderCallback: (Rect bounds) {
                                return const LinearGradient(
                                  colors: [ColorConstants.buttonPurple,ColorConstants.buttonPink],
                                ).createShader(bounds);
                              },
                              child: const Icon(Icons.key),
                            ),
                            Expanded(
                              child: Container(
                                margin: const EdgeInsets.only(left: 10),
                                child: TextFormField(
                                  onFieldSubmitted: (value) =>
                                      signUserIn(context),
                                  controller: passwordController,
                                  maxLines: 1,
                                  obscureText: passwordVisible,
                                  decoration: InputDecoration(
                                    fillColor: ColorConstants.background,
                                    border: UnderlineInputBorder(),
                                    hintText: "Password",
                                    suffixIcon: IconButton(
                                      icon: Icon(passwordVisible
                                          ? Icons.visibility
                                          : Icons.visibility_off),
                                      onPressed: () {
                                        setState(
                                          () {
                                            passwordVisible = !passwordVisible;
                                          },
                                        );
                                      },
                                    ),
                                    alignLabelWithHint: false,
                                    filled: true,
                                  ),
                                  keyboardType: TextInputType.visiblePassword,
                                  textInputAction: TextInputAction.done,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 1),
                    FadeAnimation(
                      3,
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () {
                                // Add your logic here for the "Şifremi Unuttum" button
                              },
                              child:  Text(
                                "Şifremi Unuttum",
                                style: GoogleFonts.nunito(
                                  textStyle: const TextStyle(
                                    color: ColorConstants.textwhite,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                            ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    //SİGN İN BUTTON
                    const SizedBox(
                      height: 1,
                    ),
                    FadeAnimation(
                      3.5,
                      ElevatedButton(
                        onPressed: () {
                          signUserIn(context);
                        },
                        style: ElevatedButton.styleFrom(
                            shadowColor: ColorConstants.buttonPurple,
                            elevation: 18,
                            padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20))),
                        child: Ink(
                          decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                  colors: [ColorConstants.buttonPurple,ColorConstants.buttonPink]),
                              borderRadius: BorderRadius.circular(20)),
                          child: Container(
                            width: 300,
                            height: 40,
                            alignment: Alignment.center,
                            child: const Text(
                              'Giriş Yap',
                              style: TextStyle(
                                fontSize: 25,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),
                    //CONTİNUE BUTTON
                    const FadeAnimation(
                      4,
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 25.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Divider(
                                thickness: 2,
                                color: ColorConstants.itemWhite,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10.0),
                              child: Text(
                                'Veya',
                                style: TextStyle(
                                    color: ColorConstants.textwhite,
                                    fontSize: 14,
                                    fontFamily: 'Lato',
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Expanded(
                                child: Divider(
                              thickness: 2,
                              color: ColorConstants.itemWhite,
                            ))
                          ],
                        ),
                      ),
                    ),
                    //Image.asset(
                    // 'assets/img/Google.png',
                    // height: 50,
                    // ),
                    const SizedBox(
                      height: 20,
                      width: 350,
                    ),
                    SizedBox(
                      height: 40,
                      width: 350,
                      child: FadeAnimation(
                        4.5,
                        ElevatedButton(
                          onPressed: () {
                            signInWithGoogle(context);
                          },
                          style: ElevatedButton.styleFrom(
                              shadowColor: ColorConstants.buttonPurple,
                              elevation: 18,
                              padding: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20))),
                          child: Ink(
                            decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                    colors: [ColorConstants.buttonPurple,ColorConstants.buttonPink]),
                                borderRadius: BorderRadius.circular(20)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 30,
                                  height: 30,
                                  child: Image.asset(
                                    'assets/img/Google.png',
                                  ),
                                ),
                                Container(
                                  width: 200,
                                  height: 40,
                                  alignment: Alignment.center,
                                  child: const Text(
                                    'Google İle Giriş Yap',
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),
                    FadeAnimation(
                        5,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Üye değil misiniz ? ',
                              style: TextStyle(
                                  color: ColorConstants.itemWhite,
                                  fontFamily: 'lato'),
                            ),
                            const SizedBox(height: 8),
                            TextButton(
                              onPressed: () {
                                Navigator.pushReplacementNamed(
                                    context, RouterConstants.registerPage);
                              },
                              child: const Text(
                                'Hemen Üye Olun',
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        )),

                    // GOOGLE SİGN BUTTON
                    //REGİSTER
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
