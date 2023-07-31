import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constant/color_constants.dart';
import '../../../../core/constant/router_constants.dart';
import '../../../../core/models/users/user_detail/user_detail_model.dart';
import '../../../../core/utils/secure_storage_helper.dart';
import '../../../../core/utils/user_info_helper.dart';

class MentorGuideUpRevenuePage extends StatefulWidget {
  const MentorGuideUpRevenuePage({Key? key}) : super(key: key);

  @override
  State<MentorGuideUpRevenuePage> createState() => _MentorGuideUpRevenuePageState();
}

class _MentorGuideUpRevenuePageState extends State<MentorGuideUpRevenuePage> {
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
        title: Text(
          'My Dashboard',
          style: GoogleFonts.nunito(),
          textAlign: TextAlign.center,
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
        centerTitle: true,
      ),
      backgroundColor: ColorConstants.darkBack,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 60.0,
              backgroundColor: ColorConstants.itemBlack, // Varsayılan arka plan rengi
              backgroundImage: UserInfoHelper.getProfilePicture(userDetail),
            ),
            const SizedBox(height: 16.0),
            Positioned(
              top: 130.0,
              child: Text(
                userDetail != null ? (" ${userDetail!.getName() ?? ""} ${userDetail!.getSurname() ?? ""}") : "",
                style: GoogleFonts.nunito(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: ColorConstants.itemWhite,
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const CircleAvatar(
                  backgroundColor: ColorConstants.success,
                  child: Icon(
                    Icons.attach_money,
                    color: ColorConstants.itemWhite,
                  ),
                ),
                const SizedBox(width: 8.0),
                Expanded(
                  child: Text(
                    '\$0',
                    style: GoogleFonts.nunito(fontSize: 16.0),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            Card(
              color: ColorConstants.success,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Toplam Bakiye',
                          style: GoogleFonts.nunito(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color: ColorConstants.itemWhite,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.pushNamed(context,
                                RouterConstants.mentorBalanceMovements);
                          },
                          icon: const Icon(Icons.arrow_forward_sharp),
                          color: ColorConstants.itemWhite,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      '0 \$',
                      style: GoogleFonts.nunito(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        color: ColorConstants.itemWhite,
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    Text(
                      'Beklenen Ödeme: 0 \$',
                      style: GoogleFonts.nunito(
                        fontSize: 16.0,
                        color: ColorConstants.itemWhite,
                      ),
                    ),
                    Text(
                      'Yapılan Ödeme: 0 \$',
                      style: GoogleFonts.nunito(
                        fontSize: 16.0,
                        color: ColorConstants.itemWhite,
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    Text('Ali Yalçın',
                        style: GoogleFonts.nunito(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: ColorConstants.itemWhite,
                        )),
                    const SizedBox(height: 16.0),
                    Row(
                      children: [
                        Text(
                          'TR39 00001 0090 1024 6113 0050 01',
                          style: GoogleFonts.nunito(
                            fontSize: 14.0,
                            color: ColorConstants.itemWhite,
                          ),
                        ),
                        const SizedBox(width: 8.0),
                        IconButton(
                          onPressed: () {
                            Navigator.pushNamed(context,
                                RouterConstants.mentorAccountInformation);
                          },
                          icon: const Icon(Icons.edit, size: 16.0),
                          color: ColorConstants.itemWhite,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            Row(
              children: [
                const Icon(
                  Icons.account_balance_wallet,
                  color: ColorConstants.success,
                  size: 16.0,
                ),
                const SizedBox(width: 8.0),
                Text(
                  'Toplam ',
                  style: GoogleFonts.nunito(
                    fontSize: 14.0,
                    color: ColorConstants.itemWhite,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '0 \$ ',
                  style: GoogleFonts.nunito(
                    fontSize: 14.0,
                    color: ColorConstants.success,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'kazandın',
                  style: GoogleFonts.nunito(
                    fontSize: 14.0,
                    color: ColorConstants.itemWhite,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            Card(
              color: ColorConstants.theme1White,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.credit_card,
                          color: ColorConstants.success,
                          size: 16.0,
                        ),
                        const SizedBox(width: 8.0),
                        Text(
                          'Banka Hesabına Aktar',
                          style: GoogleFonts.nunito(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: ColorConstants.success,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  backgroundColor:ColorConstants.buttonPurple,
                                  title: Text(
                                    'Banka Hesabına Aktar',
                                    style: GoogleFonts.nunito(
                                      color: ColorConstants.itemWhite,
                                    ),
                                  ),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'GuideUp hesabınızdaki bakiye banka hesabınıza aktarılacaktır. Onaylıyor musunuz ?',
                                        style: GoogleFonts.nunito(
                                          color: ColorConstants.itemWhite,
                                        ),
                                      ),
                                      const SizedBox(height: 16.0),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text(
                                              'İptal',
                                              style: GoogleFonts.nunito(
                                                color: ColorConstants.itemWhite,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 8.0),
                                          ElevatedButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    backgroundColor:ColorConstants.buttonPurple,

                                                    title: const Icon(
                                                      Icons.check_circle,
                                                      color: ColorConstants
                                                          .success,
                                                      size: 48.0,
                                                    ),
                                                    content: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Text(
                                                          'İşeleminiz başarıyla gerçekleştirilmiştir. Ekibimiz işleminizi  inceledikten sonra bakiyeniz banka hesabınıza geçecektir.!',
                                                          style: GoogleFonts
                                                              .nunito(
                                                            color:
                                                                ColorConstants
                                                                    .itemWhite,
                                                          ),
                                                        ),
                                                        const SizedBox(height: 16.0),
                                                        ElevatedButton(
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                          child: Text(
                                                            'Dashboard\'a Dön',
                                                            style: GoogleFonts
                                                                .nunito(
                                                              color: ColorConstants.itemWhite,

                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                },
                                              );
                                            },
                                            style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all<
                                                          Color>(
                                                      ColorConstants.success),
                                              foregroundColor:
                                                  MaterialStateProperty.all<
                                                          Color>(
                                                      ColorConstants.itemWhite),
                                            ),
                                            child: Text('Evet',
                                              style: GoogleFonts.nunito(),),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                          icon: const Icon(Icons.arrow_forward),
                          color: ColorConstants.success,
                        ),
                        // SizedBox(height: 16.0),
                        // ElevatedButton(
                        //   onPressed: () {
                        //     showDialog(
                        //       context: context,
                        //       builder: (BuildContext context) {
                        //         return AlertDialog(
                        //           backgroundColor:
                        //               ColorConstants.theme1DarkBlue,
                        //           title: Text(
                        //             'Bakiyede Para Yok',
                        //             style: GoogleFonts.nunito(
                        //               color: ColorConstants.itemWhite,
                        //             ),
                        //           ),
                        //           content: Text(
                        //             'GuideUp hesabında bakiye olmadığı için aktarım yapamıyorsun',
                        //             style: GoogleFonts.nunito(
                        //               color: ColorConstants.itemWhite,
                        //             ),
                        //           ),
                        //           actions: [
                        //             TextButton(
                        //               onPressed: () {
                        //                 Navigator.pop(context);
                        //               },
                        //               child: Text(
                        //                 'Kapat',
                        //                 style: GoogleFonts.nunito(
                        //                   color: ColorConstants.itemWhite,
                        //                 ),
                        //               ),
                        //             ),
                        //           ],
                        //         );
                        //       },
                        //     );
                        //   },
                        //   style: ButtonStyle(
                        //     backgroundColor:
                        //         MaterialStateProperty.all<Color>(Colors.red),
                        //     foregroundColor:
                        //         MaterialStateProperty.all<Color>(Colors.white),
                        //   ),
                        //   child: Text(
                        //     'Bakiyede para yoksa',
                        //     style: GoogleFonts.nunito(
                        //       fontSize: 3.0,
                        //       fontWeight: FontWeight.bold,
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                    const SizedBox(height: 3.0),
                    Text(
                      'Bakiyen, 5 iş günü içinde otomatik hesabına aktarılacak',
                      style: GoogleFonts.nunito(
                        fontSize: 10.0,
                        color: ColorConstants.itemBlack,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
