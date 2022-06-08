import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:psychosomatics/constants/routes_str.dart';
import 'package:psychosomatics/data/models/custom_user.dart';
import 'package:psychosomatics/data/models/illness.dart';
import 'package:psychosomatics/data/repository.dart';
import 'package:psychosomatics/domain/cubit/illness_cubit.dart';

import 'favorites_cubit.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  final Repository repository;
  final IllnessCubit illnessCubit;
  final FavoritesCubit favoriteCubit;

  UserCubit({
    required this.repository,
    required this.illnessCubit,
    required this.favoriteCubit,
  }) : super(const UserInitial(
          customUser: null,
          indexPage: IndexPageEnum.home,
        ));

  void auth(CustomUser? customUser) {
    emit(UserAuthorized(
      customUser: customUser,
      indexPage: IndexPageEnum.home,
    ));
  }

  void changeDataFromVerify(String id, String name) {
    var currCustomUser = state.customUser;
    currCustomUser!.name = name;
    currCustomUser.isNewUser = false;

    repository.updateUser(id, name).then((value) {
      emit(UserAuthorized(
        customUser: currCustomUser,
        indexPage: IndexPageEnum.home,
      ));
    });
  }

  void initialize() {
    CustomUser? currUser;
    currUser = state.customUser;

    emit(
      UserRun(
        customUser: currUser,
        indexPage: IndexPageEnum.home,
      ),
    );
  }

  void changePage(index) {
    emit(
      UserRun(
        customUser: state.customUser,
        indexPage: IndexPageEnum.values[index],
      ),
    );
  }

  Future<void> updateUser(String id, String name) async {
    await repository.updateUser(id, name).then((value) {
      state.customUser!.name = name;

      emit(UserChanged(
        newName: name,
        customUser: state.customUser,
        indexPage: state.indexPage,
      ));
    });
  }

  Future<void> quit(context) async {
    await illnessCubit.illnessSub!.cancel();
    await repository.quit().then((value) {
      state.customUser!.clear();
      Navigator.of(context).pushReplacementNamed(authScreen);
    });
  }

  Future<void> changeFavoriteIllness(Illness illness, bool isAdd) async {
    await repository
        .changeFavoriteIllness(state.customUser!.id, illness.id, isAdd)
        .then((value) {
      if (isAdd) {
        state.customUser!.favorites.add(illness.id);
      } else {
        state.customUser!.favorites.removeWhere((f) => f == illness.id);
      }

      favoriteCubit.changedFavorite(illness, isAdd);
    });
  }


}
