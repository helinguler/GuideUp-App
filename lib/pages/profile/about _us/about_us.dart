import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:guide_up/core/constant/color_constants.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({Key? key}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorConstants.darkBack,
        title: Text('Hakkımızda',
          style: GoogleFonts.nunito(
            color: ColorConstants.textwhite
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: ColorConstants.darkBack,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Guide UP Hakkında',
                  style: GoogleFonts.nunito(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: ColorConstants.appcolor2
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Guide UP, mentorluk hizmetleri sunan bir platformdur. '
                      'Amacımız, insanların yeteneklerini geliştirmelerine yardımcı olmak ve '
                      'birbirleriyle bilgi ve deneyim paylaşımını sağlamaktır. '
                      'Guide UP ile kullanıcılar, deneyimli mentörlerle iletişim kurabilir, '
                      'rehberlik alabilir ve hedeflerine ulaşmak için gerekli kaynaklara erişebilir.',
                  style: GoogleFonts.nunito(
                      color: ColorConstants.textwhite
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Misyonumuz',
                  style: GoogleFonts.nunito(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                      color: ColorConstants.appcolor2
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Misyonumuz, insanların potansiyellerini keşfetmelerine yardımcı olmak '
                      've yeteneklerini geliştirerek hedeflerine ulaşmalarını sağlamaktır. '
                      'Mentorluk ve rehberlik aracılığıyla kullanıcılara ilham vermek, '
                      'bilgi ve deneyim paylaşımını teşvik etmek ve başarıya giden yolculuklarında '
                      'yanlarında olmak en önemli hedeflerimizdendir.',
                  style: GoogleFonts.nunito(
                      color: ColorConstants.textwhite
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Guide UP Farklı Kılanlar',
                  style: GoogleFonts.nunito(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                      color: ColorConstants.appcolor2
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '- Geniş mentor ağı ve çeşitli uzmanlık alanları\n'
                      '- Kişiselleştirilmiş mentor seçimi ve öneriler\n'
                      '- İletişim ve mesajlaşma araçları\n'
                      '- Zengin içerik kaynakları ve rehberlik materyalleri\n'
                      '- Kullanıcı deneyimine odaklı kullanıcı arayüzü ve kolay kullanım',
                  style: GoogleFonts.nunito(
                      color: ColorConstants.textwhite
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 0, left: 85),
                  child: Image.asset(
                    'assets/logo/guideUpLogo.png',
                    width: 180,
                    height: 180,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
