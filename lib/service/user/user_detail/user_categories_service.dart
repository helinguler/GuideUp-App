import 'package:guide_up/repository/category/category_repository.dart';
import 'package:guide_up/repository/user/user_detail/user_categories_repository.dart';

import '../../../core/models/category/category_model.dart';
import '../../../core/models/users/user_detail/user_categories_model.dart';

class UserCategoriesService {
  late UserCategoriesRepository _userCategoriesRepository;
  late CategoryRepository _categoryRepository;

  UserCategoriesService() {
    _userCategoriesRepository = UserCategoriesRepository();
    _categoryRepository = CategoryRepository();
  }

  Future<List<Category>> getUserCategoriesList(String userId,int limit) async {
    List<Category> catList = [];

    List<UserCategories> userCatList =
        await _userCategoriesRepository.getUserCategoriesListByUserId(userId,limit);

    for (var userCat in userCatList) {
      if (userCat.getCategoriesId() != null) {
        Category? cat =
            await _categoryRepository.get(userCat.getCategoriesId()!);
        if (cat != null) {
          catList.add(cat);
        }
      }
    }

    return catList;
  }

  Future delete(String categoryId, String userId) async {
    UserCategories? cate = await _userCategoriesRepository
        .getUserCategoriesByUserIdAndCategoryId(userId, categoryId);
    if (cate != null) {
      _userCategoriesRepository.delete(cate);
    }
  }
}
