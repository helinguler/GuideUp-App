import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:guide_up/core/constant/secure_strorage_constant.dart';
import 'package:guide_up/core/models/mentor/mentee_model.dart';
import 'package:guide_up/core/models/users/user_detail/user_detail_model.dart';
import 'package:guide_up/repository/upload/upload_repository.dart';
import 'package:guide_up/repository/user/user_detail/user_categories_repository.dart';
import 'package:guide_up/repository/user/user_detail/user_detail_repository.dart';
import 'package:guide_up/repository/user/user_education/user_education_repository.dart';
import 'package:guide_up/repository/user/user_project/user_project_repository.dart';

import '../../../core/models/mentor/mentor_model.dart';
import '../../../repository/mentee/mentee_repository.dart';
import '../../../repository/mentor/mentor_repository.dart';
import '../../../repository/user/user_experience/user_experience_repository.dart';

class UserDetailService {
  late UploadRepository _uploadRepository;
  late UserDetailRepository _userDetailRepository;
  late MentorRepository _mentorRepository;
  late MenteeRepository _menteeRepository;

  UserDetailService() {
    _uploadRepository = UploadRepository();
    _userDetailRepository = UserDetailRepository();
    _mentorRepository = MentorRepository();
    _menteeRepository = MenteeRepository();
  }

  Future<UserDetail?> updateUserPhotoByPathAndUserDetail(
      String filePath, UserDetail userDetail) async {
    var uploadUrl = await _uploadRepository.addProfilePictureByUserId(
        filePath, userDetail.getUserId()!);
    if (uploadUrl.isNotEmpty) {
      userDetail.setPhoto(uploadUrl);
      userDetail = await update(userDetail);

      return userDetail;
    }

    return null;
  }

  Future<UserDetail> add(UserDetail userDetail) async {
    UserDetail? detail;
    String photo = "";
    photo += userDetail.getPhoto() ?? "";
    userDetail.setPhoto("");
    if (photo.isNotEmpty) {

      _uploadRepository
          .addProfilePictureByUserId(photo, userDetail.getUserId()!)
          .then((value) {
        if (value.isNotEmpty) {
          userDetail.setPhoto(value);

          if (detail != null) {
            _userDetailRepository
                .getUserByUserId(userDetail.getUserId()!)
                .then((tempDetail) {
              if (tempDetail != null) {
                tempDetail.setPhoto(value);
                update(tempDetail);
              }
            });
          }
        }
      });
    }
    detail = await _userDetailRepository.add(userDetail);
    const FlutterSecureStorage().write(
        key: SecureStrogeConstants.USER_DETAIL_KEY, value: detail.toJson());

    return detail;
  }

  Future<UserDetail> update(UserDetail userDetail) async {
    if (userDetail.getName() == null || userDetail.getName()!.trim().isEmpty) {
      throw Exception("Kullanıcı ismi boş olamaz.");
    }
    if (userDetail.getSurname() == null ||
        userDetail.getSurname()!.trim().isEmpty) {
      throw Exception("Kullanıcı soy ismi boş olamaz.");
    }
    if (userDetail.isMentor()) {
      if ((await UserEducationInformationRepository()
              .getUserEducationInformationListByUserId(userDetail.getUserId()!))
          .isEmpty) {
        throw Exception(
            "Eğitim Bilgisi Ekli olmadan Mentor olunamaz.Lütfen önce eğitim bilgisini doldurunuz.");
      }
      if ((await UserProjectRepository()
              .getUserProjectListByUserId(userDetail.getUserId()!))
          .isEmpty) {
        throw Exception(
            "Proje Bilgisi Ekli olmadan Mentor olunamaz.Lütfen önce proje bilgisini doldurunuz.");
      }
      if ((await UserExperienceRepository().getList(userDetail.getUserId()!, 0))
          .isEmpty) {
        throw Exception(
            "Tecrübe Bilgisi Ekli olmadan Mentor olunamaz.Lütfen önce tecrübe bilgisini doldurunuz.");
      }
      if((await UserCategoriesRepository().getUserCategoriesListByUserId(userDetail.getUserId()!, 0))
          .isEmpty) {
        throw Exception(
            "Kategori Bilgisi Ekli olmadan Mentor olunamaz.Lütfen önce kategori bilgisini doldurunuz.");

      }
    }

    var detail = await _userDetailRepository.update(userDetail);
    const FlutterSecureStorage().write(
        key: SecureStrogeConstants.USER_DETAIL_KEY, value: detail.toJson());

    Mentor? mentor =
        await _mentorRepository.getMentorByUserId(userDetail.getUserId()!);
    if (mentor != null) {
      mentor.setName(detail.getName() ?? "");
      mentor.setSurname(detail.getSurname() ?? "");
      mentor.setAbout(detail.getAbout() ?? "");
      mentor.setPhoto(detail.getPhoto() ?? "");
      await _mentorRepository.update(mentor);
    } else if (detail.isMentor()) {
      if(userDetail.getPhoto()!=null) {
        Mentor mentorModel = Mentor();
        mentorModel.setUserId(userDetail.getUserId()!);
        mentorModel.setName(userDetail.getName()!);
        mentorModel.setSurname(userDetail.getSurname()!);
        mentorModel.setPhoto(userDetail.getPhoto()!);
        mentorModel.setAbout(userDetail.getAbout() ?? "");
        mentorModel.setRate(0);
        _mentorRepository.add(mentorModel);
      }else{
        throw Exception(
            "Mentor olmak için fotoğraf yüklemeniz zorunludur.");
      }
    }

    Mentee? mentee =
        await _menteeRepository.getMenteeByUserId(userDetail.getUserId()!);
    if (mentee != null) {
      mentee.setName(detail.getName() ?? "");
      mentee.setSurname(detail.getSurname() ?? "");
      mentee.setPhoto(detail.getPhoto() ?? "");
      await _menteeRepository.update(mentee);
    }

    return detail;
  }

  Future<UserDetail?> getUserByUserId(String userId) async {
    return _userDetailRepository.getUserByUserId(userId);
  }
}
