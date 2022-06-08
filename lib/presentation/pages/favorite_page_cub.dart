import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:psychosomatics/constants/hexcolor_str.dart';
import 'package:psychosomatics/data/models/custom_user.dart';
import 'package:psychosomatics/data/models/illness.dart';
import 'package:psychosomatics/domain/cubit/favorites_cubit.dart';
import 'package:psychosomatics/presentation/widgets/alert_dialog_filter.dart';
import 'package:psychosomatics/presentation/widgets/character_list_item.dart';

class FavoritePageCub extends StatelessWidget {
  final CustomUser user;

  FavoritePageCub({Key? key, required this.user}) : super(key: key);

  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  final TextEditingController _controllerSearch = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var blocProvider = BlocProvider.of<FavoritesCubit>(context);

    // blocProvider.initialize(user.favorites);

    return Scaffold(
      backgroundColor: HexColor(primaryHexColor),
      appBar: _appBar(context, blocProvider),
      body: BlocBuilder<FavoritesCubit, FavoritesState>(
        builder: (context, state) {
          if (state is FavoritesLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            children: [
              Container(
                height: 45.0,
                padding: const EdgeInsets.only(left: 10.0, bottom: 4.0),
                margin: const EdgeInsets.only(left: 14.0, right: 14.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: HexColor(textFieldHexColor),
                ),
                child: TextField(
                  controller: _controllerSearch,
                  textCapitalization: TextCapitalization.sentences,
                  style: const TextStyle(color: Colors.white),
                  cursorColor: Colors.white,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.search, color: Colors.white),
                    hintText: 'Название болезни',
                    hintStyle: TextStyle(color: Colors.white70),
                    border: InputBorder.none,
                  ),
                  onChanged: (_) {
                    blocProvider.filter(
                      _controllerSearch.text,
                      state.typeGroups,
                    );
                  },
                ),
              ),
              const SizedBox(height: 10.0),
              Expanded(
                child: state.filteredFavoriteIllness.isNotEmpty
                    ? ListView.builder(
                        itemBuilder: (ctx, i) {
                          return CharacterListItem(
                            illness: state.filteredFavoriteIllness[i],
                            favoriteIllness: state.filteredFavoriteIllness
                                .map((e) => e.id)
                                .toList(),
                          );
                        },
                        itemCount: state.filteredFavoriteIllness.length,
                      )
                    : _buildWidgetNoItemsFound(),
              ),
            ],
          );
        },
      ),
    );
  }

  PreferredSize _appBar(context, FavoritesCubit blocProvider) {
    return PreferredSize(
      preferredSize: preferredSize + const Offset(0, 20.0),
      child: Padding(
        padding: const EdgeInsets.only(top: 30.0),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(width: 48.0),
              const Center(
                child: Text(
                  'Избранное',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (ctx) {
                        return AlertDialogFilter(
                          chosenTypeGroups: blocProvider.state.typeGroups,
                        );
                      }).then((filtersTypeGroup) {
                    if (filtersTypeGroup != null) {
                      List<TypeGroup> typeGroupsToFilter = [];

                      for (var v in filtersTypeGroup) {
                        typeGroupsToFilter.add(TypeGroup.values[v]);
                      }

                      blocProvider.filter(
                        blocProvider.state.searchText,
                        typeGroupsToFilter,
                      );
                    }
                  });
                },
                icon: const Icon(
                  Icons.filter_list,
                  color: Colors.white,
                  size: 30.0,
                ),
                splashRadius: 25.0,
              ),
            ],
          ),
        ),
      ),
    );
  }

  _buildWidgetNoItemsFound() {
    return Padding(
      padding: const EdgeInsets.only(top: 35.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const [
          Text(
            'Болезни не найдены',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 15.0),
          Text(
            'Список пока пуст...',
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
