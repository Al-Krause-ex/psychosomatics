import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:psychosomatics/data/models/illness.dart';
import 'package:psychosomatics/data/repository.dart';

part 'favorites_state.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  final Repository repository;

  FavoritesCubit(this.repository)
      : super(const FavoritesInitial(
          [],
          [],
          '',
          [
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

  void initialize(List<String> ids) {
    emit(const FavoritesLoading(
      favoriteIllness: [],
      filteredFavoriteIllness: [],
      searchText: '',
      typeGroups: [],
    ));

    // repository.loadFavoriteIllness(this, ids).then((value) {
    //   value.sort((a, b) => a.name
    //       .toString()
    //       .toLowerCase()
    //       .compareTo(b.name.toString().toLowerCase()));
    //
    //   // emit(FavoritesLoaded(
    //   //   favoriteIllness: value,
    //   //   filteredFavoriteIllness: value,
    //   //   searchText: '',
    //   //   typeGroups: const [],
    //   // ));
    // });
  }

  void loadedFavorite(
    List<Illness> favoriteIllness,
    List<Illness> filteredFavoritesIllness,
    List<TypeGroup> typeGroups,
  ) {
    emit(FavoritesLoaded(
      favoriteIllness: favoriteIllness,
      filteredFavoriteIllness: filteredFavoritesIllness,
      searchText: state.searchText,
      typeGroups: typeGroups,
    ));
  }

  void changedFavorite(Illness illness, bool isAdd) {
    if (isAdd) {
      state.favoriteIllness.add(illness);
    } else {
      state.favoriteIllness.removeWhere((f) => f.id == illness.id);
    }

    state.favoriteIllness.sort((a, b) => a.name
        .toString()
        .toLowerCase()
        .compareTo(b.name.toString().toLowerCase()));

    filter(state.searchText, state.typeGroups);
  }

  void filter(String searchText, List<TypeGroup> typeGroups) {
    List<TypeGroup> currTypeGroups = [];

    if (typeGroups.isEmpty) {
      for (var i = 0; i < 8; i++) {
        currTypeGroups.add(TypeGroup.values[i]);
      }
    } else {
      currTypeGroups = typeGroups;
    }

    var newFilteredIllness = state.favoriteIllness.where((il) {
      var filterByText =
          il.name.toLowerCase().contains(searchText.toLowerCase());

      var filterByTypeGroup =
          currTypeGroups.isEmpty ? true : currTypeGroups.contains(il.typeGroup);
      return filterByText && filterByTypeGroup;
    }).toList();

    emit(FavoritesFiltered(
      favoriteIllness: state.favoriteIllness,
      filteredFavoriteIllness: newFilteredIllness,
      searchText: searchText,
      typeGroups: currTypeGroups,
    ));
  }
}
