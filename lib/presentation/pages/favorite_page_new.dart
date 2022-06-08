import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:psychosomatics/constants/hexcolor_str.dart';
import 'package:psychosomatics/data/cloud_firestore_tool.dart';
import 'package:psychosomatics/data/models/custom_user.dart';
import 'package:psychosomatics/data/models/illness.dart';
import 'package:psychosomatics/domain/cubit/favorites_cubit.dart';
import 'package:psychosomatics/presentation/widgets/alert_dialog_filter.dart';
import 'package:psychosomatics/presentation/widgets/character_list_item.dart';

class FavoritePageNew extends StatefulWidget {
  final CustomUser user;

  const FavoritePageNew({Key? key, required this.user}) : super(key: key);

  @override
  State<FavoritePageNew> createState() => _FavoritePageNewState();
}

class _FavoritePageNewState extends State<FavoritePageNew> {
  final CloudFirestoreTool _cloudFirestoreTool = CloudFirestoreTool();
  final TextEditingController _controllerSearch = TextEditingController();

  var isLoading = false;
  var favoriteIllness = <Illness>[];
  var filteredFavoriteIllness = <Illness>[];

  initStateAsync() async {
    setState(() {
      isLoading = true;
    });

    await _cloudFirestoreTool
        .loadFavoriteIllness(widget.user.favorites)
        .then((value) {
      favoriteIllness = value;

      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  @override
  void initState() {
    initStateAsync();
    super.initState();
  }

  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  String searchText = '';
  List<TypeGroup> typeGroups = [];

  @override
  Widget build(BuildContext context) {
    filteredFavoriteIllness = favoriteIllness.where((il) {
      var filterByText = il.name.startsWith(_controllerSearch.text);
      var filterByTypeGroup =
          typeGroups.isEmpty ? true : typeGroups.contains(il.typeGroup);
      return filterByText && filterByTypeGroup;
    }).toList();

    return BlocBuilder<FavoritesCubit, FavoritesState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: HexColor(primaryHexColor),
          appBar: _appBar(context),
          body: isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
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
                          setState(() {});
                        },
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Expanded(
                      child: filteredFavoriteIllness.isNotEmpty
                          ? ListView.builder(
                              itemBuilder: (ctx, i) {
                                return CharacterListItem(
                                  illness: filteredFavoriteIllness[i],
                                  favoriteIllness: filteredFavoriteIllness
                                      .map((e) => e.id)
                                      .toList(),
                                );
                              },
                              itemCount: filteredFavoriteIllness.length,
                            )
                          : _buildWidgetNoItemsFound(),
                    ),
                  ],
                ),
        );
      },
    );
  }

  PreferredSize _appBar(context) {
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
                  'Список болезней',
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
                        if (typeGroups.isEmpty) {
                          for (var i = 0; i < 8; i++) {
                            typeGroups.add(TypeGroup.values[i]);
                          }
                        }

                        return AlertDialogFilter(
                          chosenTypeGroups: typeGroups,
                        );
                      }).then((filtersTypeGroup) {
                    if (filtersTypeGroup != null) {
                      List<TypeGroup> typeGroupsToFilter = [];

                      for (var v in filtersTypeGroup) {
                        typeGroupsToFilter.add(TypeGroup.values[v]);
                      }

                      setState(() {
                        typeGroups = typeGroupsToFilter;
                      });
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

  @override
  void dispose() {
    _controllerSearch.dispose();
    super.dispose();
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
