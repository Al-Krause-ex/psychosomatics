import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:psychosomatics/constants/routes_str.dart';
import 'package:psychosomatics/data/models/custom_user.dart';
import 'package:psychosomatics/data/models/illness.dart';
import 'package:psychosomatics/data/repository.dart';
import 'package:psychosomatics/domain/cubit/favorites_cubit.dart';

part 'illness_state.dart';

class IllnessCubit extends Cubit<IllnessState> {
  final FavoritesCubit favoritesCubit;
  final Repository repository;
  late StreamSubscription<QuerySnapshot>? illnessSub;

  IllnessCubit(this.repository, this.favoritesCubit)
      : super(const IllnessInitial(
          filteredIllness: [],
          searchText: '',
          illness: [],
          typeGroups: [
            TypeGroup.hands,
            TypeGroup.legs,
            TypeGroup.head,
            TypeGroup.body,
            TypeGroup.infection,
            TypeGroup.neurology,
            TypeGroup.psyche,
            TypeGroup.other
          ],
        ));

  void initialize(context, CustomUser user) {
    emit(const IllnessLoading(
      illness: [],
      filteredIllness: [],
      searchText: '',
      typeGroups: [],
    ));

    favoritesCubit.emit(const FavoritesLoading(
      favoriteIllness: [],
      filteredFavoriteIllness: [],
      searchText: '',
      typeGroups: [],
    ));

    repository.loadIllness(this, user);

    Navigator.of(context).pushReplacementNamed(mainScreen);
  }

  void loadedIllness(List<Illness> illness, CustomUser user) {
    var mapResultFiltered =
        filter(illness, state.searchText, state.typeGroups, false);

    var newFilteredIllness = mapResultFiltered['filteredIllness'];
    var currTypeGroups = mapResultFiltered['typeGroups'];

    emit(IllnessLoaded(
      illness: illness,
      filteredIllness: newFilteredIllness,
      searchText: state.searchText,
      typeGroups: currTypeGroups,
    ));

    var favoritesIllness =
        illness.where((ill) => user.favorites.contains(ill.id)).toList();

    var mapResultFilteredFavorite = filter(
        favoritesIllness,
        favoritesCubit.state.searchText,
        favoritesCubit.state.typeGroups,
        false);

    favoritesCubit.loadedFavorite(
        favoritesIllness,
        mapResultFilteredFavorite['filteredIllness'],
        mapResultFilteredFavorite['typeGroups']);
  }

  Map<String, dynamic> filter(
    List<Illness> illness,
    String searchText,
    List<TypeGroup> typeGroups,
    bool isEmit,
  ) {
    List<Illness> currIllness = [];
    List<TypeGroup> currTypeGroups = [];

    if (typeGroups.isEmpty) {
      for (var i = 0; i < 8; i++) {
        currTypeGroups.add(TypeGroup.values[i]);
      }
    } else {
      currTypeGroups = typeGroups;
    }

    currIllness = illness;

    var newFilteredIllness = currIllness.where((il) {
      var filterByText =
          il.name.toLowerCase().contains(searchText.toLowerCase());

      var filterByTypeGroup =
          currTypeGroups.isEmpty ? true : currTypeGroups.contains(il.typeGroup);
      return filterByText && filterByTypeGroup;
    }).toList();

    newFilteredIllness.sort((a, b) => a.name
        .toString()
        .toLowerCase()
        .compareTo(b.name.toString().toLowerCase()));

    if (isEmit) {
      emit(IllnessFiltered(
        illness: currIllness,
        filteredIllness: newFilteredIllness,
        searchText: searchText,
        typeGroups: currTypeGroups,
      ));
    }

    return {
      'filteredIllness': newFilteredIllness,
      'typeGroups': currTypeGroups
    };
  }
}
