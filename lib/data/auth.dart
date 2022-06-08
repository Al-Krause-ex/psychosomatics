import 'package:firebase_auth/firebase_auth.dart';
import 'package:psychosomatics/data/cloud_firestore_tool.dart';
import 'package:psychosomatics/data/models/custom_user.dart';
import 'package:psychosomatics/domain/cubit/favorites_cubit.dart';
import 'package:psychosomatics/domain/cubit/illness_cubit.dart';

import 'models/illness.dart';

// ignore_for_file: avoid_print

class Auth {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CloudFirestoreTool _cfTool = CloudFirestoreTool();

  Future<CustomUser?> loginWithPhone(
      Map<String, dynamic> mapVerification) async {
    CustomUser? user;

    _auth.verifyPhoneNumber(
      phoneNumber: mapVerification['phone'],
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth.signInWithCredential(credential).then(
          (value) async {
            var id = value.user!.uid;

            await createAndGetUser(id, mapVerification['phone']).then((value) {
              user = value;
            });
          },
        );
      },
      verificationFailed: (FirebaseAuthException e) {
        // print(e.message);
      },
      codeSent: (String verificationId, int? resendToken) {
        mapVerification['verificationID'] = verificationId;
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );

    return user;
  }

  Future<CustomUser?> verifyOtpAuth({
    required String verificationID,
    required String smsCode,
    required String phone,
  }) async {
    CustomUser? user;

    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationID, smsCode: smsCode);

    try {
      await _auth.signInWithCredential(credential).then(
        (value) async {
          await createAndGetUser(value.user!.uid, phone).then((value) {
            user = value;
          });

          // if (isRegister) {
          //   //register
          // } else {
          //   await _cfTool.getUser(value.user!.uid).then((value) {
          //     user = value;
          //   });
          // }
        },
      );
    } catch (e) {
      // mapData['verificationID'] = verificationId;

      print(e);
    }

    return user;
  }

  Future<CustomUser?> createAndGetUser(String id, String phone) async {
    CustomUser? user;

    await getUser(id).then((value) {
      user = value;
    });

    // await _cfTool.getUser(id).then((value) {
    //   user = value;
    // });

    if (user == null) {
      await _cfTool.createUser(id, phone).then((value) {
        user = value;
      });
    }

    return user;
  }

  Future<void> updateUser(String id, String name) async {
    await _cfTool.updateUser(id, name);
  }

  // Future<void> _signOut() async {
  //   await _auth.signOut();
  // }

  Future<CustomUser?> isLoggedIn() async {
    // await _cfTool.getIllness();

    var t = _auth.currentUser;
    if (t == null) {
      return null;
    }

    return await getUser(t.uid);
  }

  Future<CustomUser?> getUser(String id) async {
    return await _cfTool.getUser(id);
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<void> loadIllness(IllnessCubit illnessCubit, CustomUser user) async {
    _cfTool.loadIllness(illnessCubit, user);
  }

  Future<List<Illness>> loadFavoriteIllness(
      FavoritesCubit favoritesCubit, List<String> ids) async {
    _cfTool.loadFavoriteIllnessN(favoritesCubit, ids);
    return _cfTool.loadFavoriteIllness(ids);
  }

  Future<void> changeFavoriteIllness(
      String userId, String illnessId, bool isAdd) async {
    await _cfTool.changeFavoriteIllness(userId, illnessId, isAdd);
  }
}
