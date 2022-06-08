import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:psychosomatics/data/models/custom_user.dart';
import 'package:psychosomatics/data/models/illness.dart';
import 'package:psychosomatics/domain/cubit/favorites_cubit.dart';
import 'package:psychosomatics/domain/cubit/illness_cubit.dart';

class CloudFirestoreTool {
  final fbStore = FirebaseFirestore.instance;

  Future<CustomUser?> createUser(String id, String phone) async {
    CustomUser? newUser;

    await fbStore.collection('users').doc(id).set(
      {
        'name': '',
        'phone': phone,
        'isPro': false,
      },
    ).then((_) {
      newUser = CustomUser(
          id: id,
          name: '',
          phone: phone,
          isPro: false,
          isNewUser: true,
          favorites: []);
    });

    return newUser;
  }

  Future<CustomUser?> getUser(String id) async {
    fbStore.settings = const Settings(persistenceEnabled: true);

    CustomUser? currentUser;

    await fbStore.collection('users').doc(id).get().then((snapshot) {
      var data = snapshot.data();

      List<String> illness = [];

      if (data != null) {
        for (var item in data['favorites']) {
          illness.add(item);
        }

        currentUser = CustomUser(
          id: id,
          name: data['name'],
          phone: data['phone'],
          isPro: data['isPro'],
          isNewUser: false,
          favorites: illness,
        );
      }
    });

    return currentUser;
  }

  Future<void> updateUser(String id, String name) async {
    await fbStore.collection('users').doc(id).update(
      {
        'name': name,
      },
    ).then((_) {});
  }

  Future<List<Illness>> getIllness(
    int offset,
    int limit,
    String searchTerm,
    List<int> typeGroups,
    List<DocumentSnapshot> illnessSnapshots,
    String oldSearchTerm,
    List<int> oldTypeGroups,
  ) async {
    List<Illness> illnesses = [];
    QuerySnapshot<Map<String, dynamic>> illness;

    if (searchTerm != oldSearchTerm) {
      illnessSnapshots.clear();
      oldSearchTerm = searchTerm;
    }

    if (typeGroups != oldTypeGroups) {
      illnessSnapshots.clear();
      oldTypeGroups = typeGroups;
    }

    if (typeGroups.isEmpty) {
      typeGroups.addAll([0, 1, 2, 3, 4, 5, 6, 7]);
    }

    try {
      if (illnessSnapshots.isEmpty) {
        illness = await fbStore
            .collection('illness')
            .orderBy('name')
            .where('type_group', whereIn: typeGroups)
            .startAt([searchTerm])
            .endAt([searchTerm + '\uf8ff'])
            // .where('name', isGreaterThanOrEqualTo: searchTerm)
            // .where('name', isLessThan: searchTerm + 'z')
            .limit(limit)
            .get();
      } else {
        illness = await fbStore
            .collection('illness')
            .orderBy('name')
            .where('type_group', whereIn: typeGroups)
            .startAt([searchTerm])
            .endAt([searchTerm + '\uf8ff'])
            // .where('name', isGreaterThanOrEqualTo: searchTerm)
            // .where('name', isLessThan: searchTerm + 'z')
            .startAfterDocument(illnessSnapshots[offset - 1])
            .limit(limit)
            .get();
      }

      illnessSnapshots.addAll(illness.docs);

      for (var doc in illness.docs) {
        var illnessItem = doc.data();

        illnesses.add(Illness(
          id: doc.id,
          name: illnessItem['name'],
          cause: illnessItem['cause'],
          affirmation: illnessItem['affirmation'],
          typeGroup: TypeGroup.hands,
          typeSubGroup: TypeSubGroup.sg1,
        ));
      }
    } catch (e) {
      // print('get error');
      // print(e);
    }

    return illnesses;
  }

  Future<List<Illness>> getFavorites(
    int offset,
    int limit,
    String searchTerm,
    List<int> typeGroups,
    List<DocumentSnapshot> illnessSnapshots,
    CustomUser user,
    Map<String, String> lastFavoriteId,
  ) async {
    List<Illness> illnesses = [];
    QuerySnapshot<Map<String, dynamic>> illness;
    List<String> nList = [];

    if (typeGroups.isEmpty) {
      typeGroups.addAll([0, 1, 2, 3, 4, 5, 6, 7]);
    }

    try {
      if (lastFavoriteId['last']!.isEmpty) {
        nList = user.favorites.length > 10
            ? user.favorites.getRange(0, 10).toList()
            : user.favorites;
      } else {
        var lastGotIndex = user.favorites.indexOf(lastFavoriteId['last']!) + 1;
        var lastIndex = user.favorites.indexOf(user.favorites.last);
        var lastInList = lastGotIndex + limit;

        if (lastIndex < lastInList) {
          var excess = lastInList - lastIndex;
          lastInList -= excess;
        }

        nList = user.favorites.getRange(lastGotIndex, lastInList).toList();
      }

      if (illnessSnapshots.isEmpty) {
        illness = await fbStore
            .collection('illness')
            .where(FieldPath.documentId, whereIn: nList)
            .limit(nList.length < 11 ? nList.length : limit)
            .get();
      } else {
        illness = await fbStore
            .collection('illness')
            .where(FieldPath.documentId, whereIn: nList)
            .startAt([searchTerm])
            .endAt([searchTerm + '\uf8ff'])
            // .where('name', isGreaterThanOrEqualTo: searchTerm)
            // .where('name', isLessThan: searchTerm + 'z')

            // .startAfterDocument(illnessSnapshots[offset - 1])
            .limit(nList.length < 10 ? nList.length : limit)
            .get();
      }

      illnessSnapshots.addAll(illness.docs);

      for (var doc in illness.docs) {
        var illnessItem = doc.data();

        illnesses.add(Illness(
          id: doc.id,
          name: illnessItem['name'],
          cause: illnessItem['cause'],
          affirmation: illnessItem['affirmation'],
          typeGroup: TypeGroup.hands,
          typeSubGroup: TypeSubGroup.sg1,
        ));
      }

      lastFavoriteId['last'] = nList.last;
      // print(lastFavoriteId);
    } catch (e) {
      // print('get error');
      // print(e);
    }

    return illnesses;
  }

  Future<List<Illness>> loadFavoriteIllness(List<String> ids) async {
    List<Illness> loadedIllness = [];
    List<List<String>> globalListIds = [];

    var cnt = 0;
    List<String> listIds = [];

    for (var id in ids) {
      listIds.add(id);
      cnt++;

      if (cnt == 10) {
        globalListIds.add(listIds);
        listIds = [];
        cnt = 0;
      }
    }

    if (listIds.isNotEmpty) globalListIds.add(listIds);

    // for (var doneIds in globalListIds) {
      // QuerySnapshot<Map<String, dynamic>> illness = await fbStore
      //     .collection('illness')
      //     .where(FieldPath.documentId, whereIn: doneIds)
      //     .get();
      //
      // for (var doc in illness.docs) {
      //   loadedIllness.add(Illness.fromJson(doc.id, doc.data()));
      // }

      // fbStore
      //     .collection('illness')
      //     .where(FieldPath.documentId, whereIn: doneIds)
      //     .snapshots()
      //     .listen((event) {
      //   var loadedIllnessLimited = event.docs.map((doc) {
      //     return Illness.fromJson(doc.id, doc.data());
      //   }).toList();
      //
      //   loadedIllness.addAll(loadedIllnessLimited);
      //
      //   // for (var element in event.docChanges) {
      //   //   if (element.type == DocumentChangeType.modified) {
      //   //     var index =
      //   //         loadedIllness.indexWhere((il) => il.id == element.doc.id);
      //   //     var doc = element.doc.data();
      //   //     loadedIllness[index].name = doc!['name'];
      //   //     loadedIllness[index].cause = doc['cause'];
      //   //     loadedIllness[index].affirmation = doc['affirmation'];
      //   //     loadedIllness[index].typeGroup =
      //   //         TypeGroup.values[doc['type_group']];
      //   //     loadedIllness[index].typeSubGroup =
      //   //         TypeSubGroup.values[doc['sub_group']];
      //   //
      //   //     //func();
      //   //   }
      //   // }
      // });
    // }

    return loadedIllness;
  }

  Future<void> loadIllness(IllnessCubit illnessCubit, CustomUser user) async {
    List<Illness> loadedIllness = [];

    StreamSubscription<QuerySnapshot> streamSub =
        fbStore.collection('illness').snapshots().listen((event) {
      loadedIllness = event.docs.map((doc) {
        return Illness.fromJson(doc.id, doc.data());
      }).toList();

      illnessCubit.loadedIllness(loadedIllness, user);
    });

    illnessCubit.illnessSub = streamSub;
  }

  Future<void> loadFavoriteIllnessN(
      FavoritesCubit favoritesCubit, List<String> ids) async {
    List<Illness> loadedIllness = [];
    List<List<String>> globalListIds = [];

    var cnt = 0;
    List<String> listIds = [];

    for (var id in ids) {
      listIds.add(id);
      cnt++;

      if (cnt == 10) {
        globalListIds.add(listIds);
        listIds = [];
        cnt = 0;
      }
    }

    if (listIds.isNotEmpty) globalListIds.add(listIds);

    var cntCircle = 0;
    // var isFirst = true;

    for (var doneIds in globalListIds) {
      // QuerySnapshot<Map<String, dynamic>> illness = await fbStore
      //     .collection('illness')
      //     .where(FieldPath.documentId, whereIn: doneIds)
      //     .get();
      //
      // for (var doc in illness.docs) {
      //   loadedIllness.add(Illness.fromJson(doc.id, doc.data()));
      // }

      fbStore
          .collection('illness')
          .where(FieldPath.documentId, whereIn: doneIds)
          .snapshots()
          .listen((event) {
        var loadedIllnessLimited = event.docs.map((doc) {
          return Illness.fromJson(doc.id, doc.data());
        }).toList();

        loadedIllness.removeWhere((ill) => doneIds.contains(ill.id));
        loadedIllness.addAll(loadedIllnessLimited);

        cntCircle++;

        if (cntCircle == globalListIds.length) {
          //favoritesCubit.loadedFavorite(loadedIllness);

          // print(loadedIllness.length);

          cntCircle = globalListIds.length - 1;
          // isFirst = false;
        }
      });
    }
  }

  Future<void> sendSuggestion(
      String id, String name, String nameIllness) async {
    await fbStore.collection('suggestions').add(
      {
        'name': nameIllness,
        'offering': name,
        'offering_id': id,
      },
    );
  }

  Future<void> changeFavoriteIllness(
      String userId, String illnessId, bool isAdd) async {
    if (isAdd) {
      await fbStore.collection('users').doc(userId).update({
        'favorites': FieldValue.arrayUnion([illnessId]),
      });
    } else {
      await fbStore.collection('users').doc(userId).update({
        'favorites': FieldValue.arrayRemove([illnessId]),
      });
    }
  }
}
