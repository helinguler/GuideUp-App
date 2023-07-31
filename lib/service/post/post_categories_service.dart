import 'package:guide_up/repository/category/category_repository.dart';
import 'package:guide_up/repository/post/post_categories_repository.dart';

import '../../core/models/category/category_model.dart';

class PostCategoriesService{

  late PostCategoriesRepository _postCategoriesRepository;
  late CategoryRepository _categoryRepository;
  PostCategoriesService(){
    _postCategoriesRepository=PostCategoriesRepository();
    _categoryRepository=CategoryRepository();
  }

  Future<List<Category>> getCategoryListByPostCategoriesPostId(String postId)async{
    List<Category> catList=[];
    var postCategoriesList=await _postCategoriesRepository.getCategoriesPostListByPostId(postId);
    for(var postCat in postCategoriesList){
      var cat=await _categoryRepository.get(postCat.getCategoryId()!);
      if(cat!=null) {
        catList.add(cat);
      }
    }
    return catList;
  }
}