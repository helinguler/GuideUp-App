import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:guide_up/core/constant/color_constants.dart';
import 'package:guide_up/core/constant/router_constants.dart';
import 'package:guide_up/core/models/users/user_detail/user_detail_model.dart';
import 'package:guide_up/core/utils/secure_storage_helper.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import '../../core/utils/user_helper.dart';
import '../../core/utils/user_info_helper.dart';
import '../../ui/material/custom_material.dart';

class ProfileMain extends StatefulWidget {
  const ProfileMain({Key? key}) : super(key: key);

  @override
  State<ProfileMain> createState() => _ProfileMainState();
}

class _ProfileMainState extends State<ProfileMain> {
  UserDetail? userDetail;

  @override
  void initState() {
    super.initState();
    getUserDetail();
  }

  void getUserDetail() async {
    UserDetail? detail = await SecureStorageHelper().getUserDetail();
    if (detail == null) {
      detail = null;
    } else {
      userDetail = detail;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorConstants.darkBack,
        centerTitle: true,
        title: Text(
          "Profilim",
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: ColorConstants.textwhite,
              ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: ColorConstants.buttonPurple, // Geri buton rengi
          ),
          onPressed: () {
            Navigator.pushNamed(context, RouterConstants.homePage);
          },
        ),
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Container(
          decoration: BoxDecoration(color: ColorConstants.darkBack),
          child: SingleChildScrollView(
            child: Container(
              padding:
                  const EdgeInsets.all(CupertinoScrollbar.defaultThickness),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: ColorConstants.background,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: ColorConstants.darkBack.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: CircleAvatar(
                            radius: 40,
                            backgroundImage:
                                UserInfoHelper.getProfilePicture(userDetail),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Column(
                          children: [
                            Text(
                              userDetail != null
                                  ? (" ${userDetail!.getName() ?? ""} ${userDetail!.getSurname() ?? ""}")
                                  : "",
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium
                                  ?.copyWith(
                                    color: ColorConstants.textwhite,
                                  ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "${UserHelper().auth.currentUser!.email}",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: ColorConstants.textwhite,
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: ColorConstants.background,
                      boxShadow: [
                        BoxShadow(
                          color: ColorConstants.darkBack.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pushNamed(
                                context, RouterConstants.myProfileAccountPage);
                          },
                          child: ListTile(
                            leading: Container(
                              width: 40,
                              height: 40,
                              decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: ColorConstants.appcolor2),
                              child: const Icon(
                                LineAwesomeIcons.user_check,
                                color: ColorConstants.textwhite,
                              ),
                            ),
                            title: Text(
                              "Hesabım",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                    color: ColorConstants.textwhite,
                                  ),
                            ),
                            trailing: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: ColorConstants.buttonPurple,
                              ),
                              child: const Icon(LineAwesomeIcons.angle_right,
                                  size: 18.0, color: ColorConstants.appcolor4),
                            ),
                          ),
                        ),
                        const Divider(
                          height: 0.01,
                          color: ColorConstants.darkBack,
                        ),
                        /*const SizedBox(height: 16),
                        ListTile(
                          onTap: () {
                            Navigator.pushNamed(
                                context, RouterConstants.generalSettingsPage);
                          },
                          leading: Container(
                            width: 40,
                            height: 40,
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: ColorConstants.appcolor2),
                            child: const Icon(
                              LineAwesomeIcons.cog,
                              color: ColorConstants.textwhite,
                            ),
                          ),
                          title: Text(
                            "Genel Ayarlar",
                            style:
                                Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      color: ColorConstants.textwhite,
                                    ),
                          ),
                          trailing: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: ColorConstants.buttonPurple,
                            ),
                            child: const Icon(
                              LineAwesomeIcons.angle_right,
                              size: 18.0,
                              color: ColorConstants.appcolor4,
                            ),
                          ),
                        ),
                        const Divider(
                          height: 0.01,
                          color: ColorConstants.darkBack,
                        ),*/
                        const SizedBox(height: 16),
                        ListTile(
                          onTap: () {
                            CustomMaterial.sendNotification(
                                context, "Çok Yakında Sizlerle");
                          },
                          leading: Container(
                            width: 40,
                            height: 40,
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: ColorConstants.appcolor2),
                            child: const Icon(
                              LineAwesomeIcons.wallet,
                              color: ColorConstants.textwhite,
                            ),
                          ),
                          title: Text(
                            "Ödeme Yöntemleri",
                            style:
                                Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      color: ColorConstants.textwhite,
                                    ),
                          ),
                          trailing: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: ColorConstants.buttonPurple,
                            ),
                            child: const Icon(
                              LineAwesomeIcons.angle_right,
                              size: 18.0,
                              color: ColorConstants.appcolor4,
                            ),
                          ),
                        ),
                        const Divider(
                          height: 0.01,
                          color: ColorConstants.darkBack,
                        ),
                        const SizedBox(height: 16),
                        InkWell(
                          onTap: () {
                            UserHelper().signOut().then((value) {
                              Navigator.pushReplacementNamed(
                                  context, RouterConstants.homePage);
                            });
                          },
                          child: ListTile(
                            leading: Container(
                              width: 40,
                              height: 40,
                              decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: ColorConstants.appcolor2),
                              child: const Icon(
                                LineAwesomeIcons.alternate_sign_out,
                                color: ColorConstants.textwhite,
                              ),
                            ),
                            title: Text(
                              "Çıkış Yap",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                    color: ColorConstants.textwhite,
                                  ),
                            ),
                            trailing: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: ColorConstants.buttonPurple,
                              ),
                              child: const Icon(
                                LineAwesomeIcons.angle_right,
                                size: 18.0,
                                color: ColorConstants.appcolor4,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: ColorConstants.background,
                      boxShadow: [
                        BoxShadow(
                          color: ColorConstants.darkBack.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        ListTile(
                          leading: Container(
                            width: 40,
                            height: 40,
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: ColorConstants.appcolor2),
                            child: const Icon(
                              LineAwesomeIcons.question_circle,
                              color: ColorConstants.textwhite,
                            ),
                          ),
                          title: Text(
                            "Yardım ve Destek",
                            style:
                                Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      color: ColorConstants.textwhite,
                                    ),
                          ),
                          onTap: () {
                            Navigator.pushNamed(
                                context, RouterConstants.helpAndSupport);
                          },
                          trailing: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: ColorConstants.buttonPurple,
                            ),
                            child: const Icon(
                              LineAwesomeIcons.angle_right,
                              size: 18.0,
                              color: ColorConstants.appcolor4,
                            ),
                          ),
                        ),
                        const Divider(
                          height: 0.01,
                          color: ColorConstants.darkBack,
                        ),
                        const SizedBox(height: 16),
                        ListTile(
                          leading: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: ColorConstants.appcolor2),
                            child: const Icon(
                              LineAwesomeIcons.info_circle,
                              color: ColorConstants.textwhite,
                            ),
                          ),
                          title: Text(
                            "Hakkımızda",
                            style:
                                Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      color: ColorConstants.textwhite,
                                    ),
                          ),
                          onTap: () {
                            Navigator.pushNamed(
                                context, RouterConstants.aboutUs);
                          },
                          trailing: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: ColorConstants.buttonPurple,
                            ),
                            child: const Icon(
                              LineAwesomeIcons.angle_right,
                              size: 18.0,
                              color: ColorConstants.appcolor4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
