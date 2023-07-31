import 'package:flutter/material.dart';

import '../../repository/category/category_repository.dart';
import 'card/category_card.dart';
import 'helper/category_select_helper.dart';
import 'helper/list_size_control.dart';

class CategoryList {
  final CategorySelectHelper selector;

  CategoryList(this.selector);

  Widget getBuildList(BuildContext context) {
    return Expanded(
      child: FutureBuilder(
        builder: (context, categorySnap) {
          if (categorySnap.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (categorySnap.hasError) {
            return const Center(
              child: Text('Kategoriler alınırken bir hata oluştu.'),
            );
          } else {
            return ListView.builder(
              itemBuilder: (context, index) {
                final category = categorySnap.data![index];
                ListSizeControl listSizeControl = ListSizeControl();
                listSizeControl.setListSize(categorySnap.data!.length);
                return CategoryCard(
                  headerCount: 0,
                  category: category,
                  mainListSizeControl: listSizeControl,
                  selector: selector,
                );
              },
              itemCount: categorySnap.data!.length,
              padding: const EdgeInsets.all(0),
            );
          }
        },
        future: CategoryRepository().getMainCategoryList(),
      ),
    );
  }
}
