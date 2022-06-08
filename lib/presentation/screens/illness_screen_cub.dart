import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:psychosomatics/constants/hexcolor_str.dart';
import 'package:psychosomatics/data/models/custom_user.dart';
import 'package:psychosomatics/data/models/illness.dart';
import 'package:psychosomatics/domain/cubit/illness_cubit.dart';
import 'package:psychosomatics/presentation/widgets/alert_dialog_filter.dart';
import 'package:psychosomatics/presentation/widgets/alert_dialog_suggestion.dart';
import 'package:psychosomatics/presentation/widgets/character_list_item.dart';

class IllnessScreenCub extends StatelessWidget {
  final CustomUser user;
  final List<TypeGroup> typeGroups;

  IllnessScreenCub({Key? key, required this.user, required this.typeGroups})
      : super(key: key);

  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  final TextEditingController _controllerSearch = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var blocProvider = BlocProvider.of<IllnessCubit>(context);

    blocProvider.filter(
        blocProvider.state.illness, _controllerSearch.text, typeGroups, true);

    return Scaffold(
      backgroundColor: HexColor(primaryHexColor),
      appBar: _appBar(context, blocProvider),
      body: BlocBuilder<IllnessCubit, IllnessState>(
        builder: (context, state) {
          // print(state);
          if (state is IllnessLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return Stack(
            children: [
              Column(
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
                          blocProvider.state.illness,
                          _controllerSearch.text,
                          state.typeGroups,
                          true,
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Expanded(
                    child: state.filteredIllness.isNotEmpty
                        ? ListView.builder(
                            itemBuilder: (ctx, i) {
                              return CharacterListItem(
                                illness: state.filteredIllness[i],
                                favoriteIllness: user.favorites,
                              );
                            },
                            itemCount: state.filteredIllness.length,
                          )
                        : _buildWidgetNoItemsFound(),
                  ),
                ],
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: InkWell(
                  borderRadius: BorderRadius.circular(22.0),
                  splashFactory: InkSplash.splashFactory,
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialogSuggestion(
                        userId: user.id,
                        userName: user.name,
                      ),
                    );
                  },
                  child: Container(
                    width: 60.0,
                    height: 60.0,
                    margin: const EdgeInsets.only(
                        bottom: 40.0, top: 40.0, right: 10.0),
                    decoration: BoxDecoration(
                        color: HexColor(elevatedButtonHexColor),
                        borderRadius: BorderRadius.circular(50.0)),
                    alignment: Alignment.center,
                    child: SvgPicture.asset(
                      'assets/icons/plus_icon.svg',
                      height: 25.0,
                    ),
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }

  PreferredSize _appBar(context, IllnessCubit blocProvider) {
    return PreferredSize(
      preferredSize: preferredSize + const Offset(0, 20.0),
      child: Padding(
        padding: const EdgeInsets.only(top: 30.0),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(
                  Icons.arrow_back_ios_outlined,
                  color: Colors.white,
                ),
                splashRadius: 25.0,
              ),
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
                        blocProvider.state.illness,
                        blocProvider.state.searchText,
                        typeGroupsToFilter,
                        true,
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
