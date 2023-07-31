import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:guide_up/pages/conversation/messages/chat_main_page.dart';
import 'package:guide_up/pages/dashboard/mentee/mentee_favourite_mentor_page.dart';
import 'package:guide_up/pages/dashboard/mentee/mentee_my_mentor_page.dart';
import 'package:guide_up/pages/dashboard/mentor/mentor_feedback_page.dart';
import 'package:guide_up/pages/dashboard/mentor/mentor_comments_page.dart';
import 'package:guide_up/pages/guide/guide_add_page.dart';
import 'package:guide_up/pages/guide/guide_detail_page.dart';
import 'package:guide_up/pages/guide/guide_home_page.dart';
import 'package:guide_up/pages/profile/my_profile/experience_page/experience_main_page.dart';
import 'package:guide_up/pages/profile/my_profile/experience_page/experience_page.dart';
import 'package:guide_up/pages/profile/my_profile/my_profile_account.dart';
import 'package:guide_up/pages/register_page/register_with_detail.dart';

import '../../pages/dashboard/mentee/mentee_comments_page.dart';
import '../../pages/dashboard/mentor/mentor_follower_pages/mentor_follower_pages.dart';
import '../../pages/dashboard/mentor/mentor_guideup_revenue/mentor_account_information.dart';
import '../../pages/dashboard/mentor/mentor_guideup_revenue/mentor_balance_movements.dart';
import '../../pages/dashboard/mentor/mentor_guideup_revenue/mentor_guideup_revenue.dart';
import '../../pages/dashboard/mentor/mentor_preview.dart';
import '../../pages/guide/comment/guide_comment_page.dart';
import '../../pages/login/login_page.dart';
import '../../pages/other/error_page.dart';
import '../../pages/profile/about _us/about_us.dart';
import '../../pages/profile/help_and_support/help_and_support.dart';
import '../../pages/profile/licenses_and_certificates/licence_And_Certificate_Add.dart';
import '../../pages/profile/licenses_and_certificates/licences_And_Certificates.dart';
import '../../pages/profile/my_profile/abilities_page/user_abilities_page.dart';
import '../../pages/profile/my_profile/education_information_page/user_education_information.dart';
import '../../pages/profile/my_profile/education_information_page/user_education_information_list.dart';
import '../../pages/profile/my_profile/projects_page/user_projects.dart';
import '../../pages/profile/my_profile/projects_page/user_projects_list.dart';
import '../../pages/profile/profile_main.dart';
import '../../pages/profile/settings/general_settings.dart';
import '../../pages/register_page/register_page.dart';
import '../../pages/splash_screen/splash_screen.dart';
import '../../ui/navigator/navigator_page.dart';
import '../constant/router_constants.dart';

class RouteGenerator {
  static Route<dynamic>? _createRoute(
      Widget routeWidget, RouteSettings settings) {
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return CupertinoPageRoute(
        settings: settings,
        builder: (builder) => routeWidget,
      );
    } else if (defaultTargetPlatform == TargetPlatform.android) {
      return MaterialPageRoute(
        settings: settings,
        builder: (builder) => routeWidget,
      );
    } else {
      return CupertinoPageRoute(
        settings: settings,
        builder: (builder) => routeWidget,
      );
    }
  }

  static Route<dynamic> createExceptRoute(Widget routeWidget,
      {RouteSettings? settings}) {
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return CupertinoPageRoute(
        settings: settings,
        builder: (builder) => routeWidget,
      );
    } else if (defaultTargetPlatform == TargetPlatform.android) {
      return MaterialPageRoute(
        settings: settings,
        builder: (builder) => routeWidget,
      );
    } else {
      return CupertinoPageRoute(
        settings: settings,
        builder: (builder) => routeWidget,
      );
    }
  }

  static Route<dynamic>? routeGeneration(RouteSettings settings) {
    switch (settings.name) {
      case RouterConstants.splashScreenPage:
        return _createRoute(const SplashScreen(), settings);

      case RouterConstants.homePage:
        return _createRoute(const NavigatorPage(), settings);

      case RouterConstants.loginPage:
        return _createRoute(const LoginPage(), settings);
      case RouterConstants.registerPage:
        return _createRoute(const RegisterPage(), settings);
      case RouterConstants.registerWithDetailPage:
        return _createRoute(const RegisterWithDetail(), settings);

      case RouterConstants.messagesPage:
        return _createRoute(const ChatMainPage(), settings);

      case RouterConstants.profilePage:
        return _createRoute(const ProfileMain(), settings);
      case RouterConstants.myProfileAccountPage:
        return _createRoute(const MyProfileAccount(), settings);
      case RouterConstants.generalSettingsPage:
        return _createRoute(const GeneralSettings(), settings);
      case RouterConstants.helpAndSupport:
        return _createRoute(const HelpAndSupport(), settings);
      case RouterConstants.aboutUs:
        return _createRoute(const AboutUs(), settings);

      case RouterConstants.userAbilities:
        return _createRoute(const UserAbilitiesPage(), settings);
      case RouterConstants.userProjectPage:
        return _createRoute(const UserProjectPage(), settings);
      case RouterConstants.userProjectList:
        return _createRoute(const UserProjectList(), settings);
      case RouterConstants.userEducationInformationPage:
        return _createRoute(const UserEducationInformationPage(), settings);
      case RouterConstants.userEducationInformationList:
        return _createRoute(const UserEducationInformationList(), settings);
      case RouterConstants.licensesAndCertificatesPage:
        return _createRoute(const LicensesAndCertificatesPage(), settings);
      case RouterConstants.licenseAndCertificateAddPage:
        return _createRoute(const LicenseAndCertificateAddPage(), settings);
      case RouterConstants.userExperienceMainPage:
        return _createRoute(const ExperienceMainPage(), settings);
      case RouterConstants.userExperiencePage:
        return _createRoute(const ExperiencePage(), settings);

      case RouterConstants.mentorFeedbackPage:
        return _createRoute( const MenteeFeedbackPage(), settings);
      case RouterConstants.mentorPreview:
        return _createRoute(const MentorPreview(), settings);
      case RouterConstants.mentorGuideUpRevenuePage:
        return _createRoute(const MentorGuideUpRevenuePage(), settings);
      case RouterConstants.mentorComments:
        return _createRoute(const MentorCommentsPage(), settings);
      case RouterConstants.menteeFavouriteMentorPage:
        return _createRoute(const MenteeFavouriteMentorPage(), settings);
      case RouterConstants.mentorFollowerPages:
        return _createRoute(const MentorFollowerPages(), settings);
      case RouterConstants.mentorBalanceMovements:
        return _createRoute(const MentorBalanceMovements(), settings);
      case RouterConstants.mentorAccountInformation:
        return _createRoute(const MentorAccountInformation(), settings);


      case RouterConstants.menteeMyMentorPage:
        return _createRoute(const MenteeMyMentorPage(), settings);
      case RouterConstants.menteeComentsPage:
        return _createRoute(const MenteeCommentsPage(), settings);

      case RouterConstants.guideAdd:
        return _createRoute(const GuideAddPage(), settings);
      case RouterConstants.guideHomePage:
        return _createRoute(const GuideHomePage(), settings);
      case RouterConstants.guideDetailPage:
        return _createRoute(const GuideDetailPage(), settings);
      case RouterConstants.guideCommentPage:
        return _createRoute(const GuideCommentPage(), settings);
      case RouterConstants.mentorDashboardFollower:
        return _createRoute(const MentorFollowerPages(), settings);

      default:
        return _createRoute(const ErrorPage(), settings);
    }
  }
}
