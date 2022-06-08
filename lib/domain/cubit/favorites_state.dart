part of 'favorites_cubit.dart';

abstract class FavoritesState extends Equatable {
  final List<Illness> favoriteIllness;
  final List<Illness> filteredFavoriteIllness;
  final String searchText;
  final List<TypeGroup> typeGroups;

  const FavoritesState({
    required this.favoriteIllness,
    required this.filteredFavoriteIllness,
    required this.searchText,
    required this.typeGroups,
  });
}

class FavoritesInitial extends FavoritesState {
  const FavoritesInitial(
    List<Illness> favoriteIllness,
    List<Illness> filteredFavoriteIllness,
    String searchText,
    List<TypeGroup> typeGroups,
  ) : super(
          favoriteIllness: favoriteIllness,
          filteredFavoriteIllness: filteredFavoriteIllness,
          searchText: searchText,
          typeGroups: typeGroups,
        );

  @override
  List<Object> get props => [favoriteIllness, filteredFavoriteIllness];
}

class FavoritesLoading extends FavoritesState {
  const FavoritesLoading({
    required List<Illness> favoriteIllness,
    required List<Illness> filteredFavoriteIllness,
    required String searchText,
    required List<TypeGroup> typeGroups,
  }) : super(
          favoriteIllness: favoriteIllness,
          filteredFavoriteIllness: filteredFavoriteIllness,
          searchText: searchText,
          typeGroups: typeGroups,
        );

  @override
  List<Object> get props => [favoriteIllness, filteredFavoriteIllness];
}

class FavoritesLoaded extends FavoritesState {
  const FavoritesLoaded({
    required List<Illness> favoriteIllness,
    required List<Illness> filteredFavoriteIllness,
    required String searchText,
    required List<TypeGroup> typeGroups,
  }) : super(
          favoriteIllness: favoriteIllness,
          filteredFavoriteIllness: filteredFavoriteIllness,
          searchText: searchText,
          typeGroups: typeGroups,
        );

  @override
  List<Object> get props => [favoriteIllness, filteredFavoriteIllness];
}

class FavoritesFiltered extends FavoritesState {
  const FavoritesFiltered({
    required List<Illness> favoriteIllness,
    required List<Illness> filteredFavoriteIllness,
    required String searchText,
    required List<TypeGroup> typeGroups,
  }) : super(
          favoriteIllness: favoriteIllness,
          filteredFavoriteIllness: filteredFavoriteIllness,
          searchText: searchText,
          typeGroups: typeGroups,
        );

  @override
  List<Object> get props =>
      [favoriteIllness, filteredFavoriteIllness, searchText, typeGroups];
}
