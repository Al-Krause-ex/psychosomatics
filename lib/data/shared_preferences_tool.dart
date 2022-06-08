import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesTool {
  Future<void> save({
    required bool isMain,
    required bool isIllness,
    required bool isFavorite,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    // print('isMain: $isMain');
    // print('isIllness: $isIllness');
    // print('isFavorite: $isFavorite');

    await prefs.setString(
        'KeyData',
        json.encode({
          'isFirstTime': false,
          'showCaseMain': !isMain,
          'showCaseIllness': !isIllness,
          'showCaseFavorite': !isFavorite,
        }));
  }

  Future<bool> load() async {
    final prefs = await SharedPreferences.getInstance();

    bool isFirstTime = true;

    if (prefs.containsKey('KeyData')) {
      isFirstTime = json.decode(prefs.getString('KeyData')!)['isFirstTime'];
    }

    return isFirstTime;
  }
}
