import 'package:psychosomatics/data/auth.dart';
import 'package:psychosomatics/data/models/custom_user.dart';
import 'package:psychosomatics/data/shared_preferences_tool.dart';
import 'package:psychosomatics/domain/cubit/favorites_cubit.dart';
import 'package:psychosomatics/domain/cubit/illness_cubit.dart';

import 'models/illness.dart';

class Repository {
  final Auth auth;
  final SharedPreferencesTool spTool;

  Repository({required this.auth, required this.spTool});

  ///Авторизация через телефон (вход firebase auth)
  Future<CustomUser?> signIn(Map<String, dynamic> mapVerification) async {
    return auth.loginWithPhone(mapVerification);
  }

  Future<CustomUser?> verifyOtpRepository(
      context, Map<String, dynamic> mapData) async {
    CustomUser? user;

    await auth
        .verifyOtpAuth(
            verificationID: mapData['verificationID'],
            smsCode: mapData['smsCode'],
            phone: mapData['phone'])
        .then((value) {
      user = value;
    });

    return user;
  }

  Future<void> updateUser(String id, String name) async {
    await auth.updateUser(id, name);
  }

  Future<CustomUser?> isLoggedIn() async {
    return await auth.isLoggedIn();
  }

  Future<void> quit() async {
    await auth.signOut();
  }

  Future<bool> firstRunCheck() async {
    return spTool.load();
  }

  Future<void> changeFirstTime() async {
    await spTool.save(isMain: false, isIllness: false, isFavorite: false);
  }

  Future<void> loadIllness(IllnessCubit illnessCubit, CustomUser user) async {
    auth.loadIllness(illnessCubit, user);
  }

  Future<List<Illness>> loadFavoriteIllness(
      FavoritesCubit favoritesCubit, List<String> ids) async {
    return auth.loadFavoriteIllness(favoritesCubit, ids);
  }

  Future<void> changeFavoriteIllness(
      String userId, String illnessId, bool isAdd) async {
    await auth.changeFavoriteIllness(userId, illnessId, isAdd);
  }
}
