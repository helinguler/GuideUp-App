import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:guide_up/core/models/users/user_detail/user_detail_model.dart';
import 'package:guide_up/core/utils/user_info_helper.dart';
import 'package:guide_up/pages/category/category_list.dart';
import 'package:guide_up/pages/category/helper/category_select_helper.dart';
import 'package:guide_up/ui/material/custom_material.dart';

import '../../core/constant/color_constants.dart';
import '../../core/utils/secure_storage_helper.dart';
import '../../core/utils/user_helper.dart';

class SearchSidePage extends StatefulWidget {
  final CategorySelectHelper selector;

  const SearchSidePage({Key? key, required this.selector}) : super(key: key);

  @override
  State<SearchSidePage> createState() => _SearchSidePageState();
}

class _SearchSidePageState extends State<SearchSidePage> {
  UserDetail? _userDetail;

  @override
  void initState() {
    super.initState();
    getDetailFromSecureStorage();
  }

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.of(context).padding;
    return Container(
        decoration: CustomMaterial.backgroundBoxDecoration,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(0, padding.top, 0, 20),
              decoration: BoxDecoration(
                color: ColorConstants.background,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: ColorConstants.background.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: CircleAvatar(
                      radius: 40,
                      backgroundColor: ColorConstants.textwhite,
                      backgroundImage:
                          UserInfoHelper.getProfilePicture(_userDetail),
                    ),
                  ),
                  const SizedBox(width: 1),
                  Expanded(
                    child: Column(
                      children: [
                        const Padding(padding: EdgeInsets.only(top: 1)),
                        Text(
                          _userDetail != null
                              ? (" ${_userDetail!.getName() ?? ""} ${_userDetail!.getSurname() ?? ""}")
                              : "Hoşgeldiniz!",
                          style: GoogleFonts.nunito(
                            textStyle: const TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: ColorConstants.textwhite,
                            ),
                          ),
                          textAlign: TextAlign.center,
                          softWrap: true,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          UserHelper().auth.currentUser != null
                              ? UserHelper().auth.currentUser!.email!
                              : "",
                          style: GoogleFonts.nunito(
                            textStyle: const TextStyle(
                              fontSize: 15,
                              color: ColorConstants.textwhite,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            CategoryList(widget.selector).getBuildList(context),
          ],
        ));
  }

  void getDetailFromSecureStorage() async {
    _userDetail = await SecureStorageHelper().getUserDetail();
    setState(() {});
  }
}
