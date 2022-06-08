import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:psychosomatics/constants/hexcolor_str.dart';
import 'package:psychosomatics/data/models/custom_user.dart';
import 'package:psychosomatics/data/models/illness.dart';
import 'package:psychosomatics/presentation/widgets/character_list_item.dart';

class FavoritePage extends StatefulWidget {
  final CustomUser user;

  const FavoritePage({Key? key, required this.user}) : super(key: key);

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  // final CloudFirestoreTool _cloudFirestoreTool = CloudFirestoreTool();

  final PagingController<int, Illness> _pagingController =
      PagingController(firstPageKey: 0);

  // static const _pageSizeFavorite = 10;
  // String _searchTerm = '';
  Map<String, String> lastFavoriteId = {'last': ''};

  List<int> typeGroups = [];
  List<DocumentSnapshot> illnessSnapshots = [];

  @override
  void initState() {
    // _pagingController.addPageRequestListener((pageKey) {
    //   _fetchPage(pageKey);
    // });

    _pagingController.addStatusListener((status) {
      if (status == PagingStatus.subsequentPageError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'Что-то пошло не так!.',
            ),
            action: SnackBarAction(
              label: 'Повторить',
              onPressed: () => _pagingController.retryLastFailedRequest(),
            ),
          ),
        );
      }
    });

    super.initState();
  }

  // Future<void> _fetchPage(pageKey) async {
  //   try {
  //     List<Illness> newItems = [];
  //
  //     newItems = await _cloudFirestoreTool.getFavorites(
  //       pageKey,
  //       _pageSizeFavorite,
  //       _searchTerm,
  //       typeGroups,
  //       illnessSnapshots,
  //       widget.user,
  //       lastFavoriteId,
  //     );
  //
  //     final isLastPage = newItems.length < _pageSizeFavorite;
  //
  //     if (isLastPage) {
  //       _pagingController.appendLastPage(newItems);
  //     } else {
  //       final nextPageKey = pageKey + newItems.length;
  //       _pagingController.appendPage(newItems, nextPageKey);
  //     }
  //   } catch (error) {
  //     _pagingController.error = error;
  //   }
  // }

  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor(primaryHexColor),
      appBar: _appBar(context),
      body: Column(
        children: [
          // CharacterSearchInputSliver(
          //   onChanged: (searchTerm) => _updateSearchTerm(searchTerm),
          // ),
          // const SizedBox(height: 10.0),
          Expanded(
            child: CustomScrollView(
              slivers: <Widget>[
                PagedSliverList<int, Illness>(
                  pagingController: _pagingController,
                  builderDelegate: PagedChildBuilderDelegate<Illness>(
                    animateTransitions: true,
                    noItemsFoundIndicatorBuilder: (context) =>
                        _buildWidgetNoItemsFound(),
                    itemBuilder: (context, item, index) => CharacterListItem(
                      illness: item,
                      favoriteIllness: const [],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  PreferredSize _appBar(context) {
    return PreferredSize(
      preferredSize: preferredSize + const Offset(0, 20.0),
      child: const Padding(
        padding: EdgeInsets.only(top: 30.0),
        child: Center(
          child: Text(
            'Избранное',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  // void _updateSearchTerm(String searchTerm) {
  //   _searchTerm = searchTerm;
  //   _pagingController.refresh();
  // }

  @override
  void dispose() {
    _pagingController.dispose();
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
