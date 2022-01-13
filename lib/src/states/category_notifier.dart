import 'package:flutter/material.dart';

CategoryNotifier categoryNotifier = CategoryNotifier();

class CategoryNotifier extends ChangeNotifier {
  String _selectedCategoryInEng = 'none';

  String get currentCategoryInEng => _selectedCategoryInEng;
  String get currentCategoryInKor => categoriesMapEngToKor[_selectedCategoryInEng]!;

  void setNewCategoryWithEng(String newCategory){
    if(categoriesMapEngToKor.keys.contains(newCategory)){
      _selectedCategoryInEng = newCategory;
      notifyListeners();
    }
  }

  void setNewCategoryWithKor(String newCategory){
    if(categoriesMapEngToKor.values.contains(newCategory)){
      _selectedCategoryInEng = categoriesMapKorToEng[newCategory]!;
      notifyListeners();
    }
  }


}

const Map<String, String> categoriesMapEngToKor = {
  'none': '선택',
  'furniture': '가구',
  'electronics': '전자기기',
  'kids': '유아동',
  'sports': '스포츠',
  'woman': '여성',
  'man': '남성',
  'makeup': '메이크업',
};

Map<String, String> categoriesMapKorToEng =
    categoriesMapEngToKor.map((key, value) => MapEntry(value, key));

