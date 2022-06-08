import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:psychosomatics/constants/hexcolor_str.dart';
import 'package:psychosomatics/data/cloud_firestore_tool.dart';
import 'package:psychosomatics/data/models/custom_user.dart';
import 'package:psychosomatics/data/models/illness.dart';
import 'package:psychosomatics/presentation/widgets/alert_dialog_filter.dart';
import 'package:psychosomatics/presentation/widgets/character_list_item.dart';
import 'package:psychosomatics/presentation/widgets/character_search_input_silver.dart';

class IllnessScreen extends StatefulWidget {
  final CustomUser customUser;
  final List<int> groups;

  const IllnessScreen({
    Key? key,
    required this.customUser,
    required this.groups,
  }) : super(key: key);

  @override
  _IllnessScreenState createState() => _IllnessScreenState();
}

class _IllnessScreenState extends State<IllnessScreen> {
  final CloudFirestoreTool _cloudFirestoreTool = CloudFirestoreTool();

  static const _pageSize = 12;

  final PagingController<int, Illness> _pagingController =
      PagingController(firstPageKey: 0);

  String _oldSearchTerm = '';
  String _searchTerm = '';
  List<int> typeGroupsInt = [];
  List<int> _oldTypeGroups = [];

  List<DocumentSnapshot> illnessSnapshots = [];

  @override
  void initState() {
    typeGroupsInt = widget.groups;

    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });

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

  Future<void> _fetchPage(pageKey) async {
    try {
      List<Illness> newItems = [];

      newItems = await _cloudFirestoreTool.getIllness(
          pageKey,
          _pageSize,
          _searchTerm,
          typeGroupsInt,
          illnessSnapshots,
          _oldSearchTerm,
          _oldTypeGroups);

      _oldSearchTerm = _searchTerm;
      _oldTypeGroups = typeGroupsInt;

      // print('newItems: ${newItems.length}');
      // print('pageSize: $_pageSize');
      // print('pageKey: $pageKey');

      final isLastPage = newItems.length < _pageSize;

      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + newItems.length;

        // print('nextPageKey: $nextPageKey');

        _pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: HexColor(primaryHexColor),
        appBar: _appBar(context),
        body: Column(
          children: [
            CharacterSearchInputSliver(
              onChanged: (searchTerm) => _updateSearchTerm(searchTerm),
            ),
            const SizedBox(height: 10.0),
            Expanded(
              child: CustomScrollView(
                slivers: <Widget>[
                  // SliverPersistentHeader(
                  //   pinned: true,
                  //   delegate: SliverAppBarDelegate(
                  //     minHeight: 45.0,
                  //     maxHeight: 45.0,
                  //     child: CharacterSearchInputSliver(
                  //       onChanged: (searchTerm) => _updateSearchTerm(searchTerm),
                  //     ),
                  //   ),
                  // ),
                  PagedSliverList<int, Illness>(
                    pagingController: _pagingController,
                    builderDelegate: PagedChildBuilderDelegate<Illness>(
                      animateTransitions: true,
                      noItemsFoundIndicatorBuilder: (context) =>
                          _buildWidgetNoItemsFound(),
                      itemBuilder: (context, item, index) => CharacterListItem(
                        illness: item,
                        favoriteIllness: widget.customUser.favorites,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );

  PreferredSize _appBar(context) {
    return PreferredSize(
      preferredSize: preferredSize + const Offset(0, 20.0),
      child: Padding(
        padding: const EdgeInsets.only(top: 20.0),
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
                      List<TypeGroup> typeGroups = [];

                      for (var type in typeGroupsInt) {
                        typeGroups.add(TypeGroup.values[type]);
                      }

                      return AlertDialogFilter(chosenTypeGroups: typeGroups);
                    },
                  ).then((value) {
                    if (value != null) {
                      typeGroupsInt = value;
                      _pagingController.refresh();
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

  void _updateSearchTerm(String searchTerm) {
    _searchTerm = searchTerm;
    _pagingController.refresh();
  }

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

// class SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
//   SliverAppBarDelegate({
//     required this.minHeight,
//     required this.maxHeight,
//     required this.child,
//   });
//
//   final double minHeight;
//   final double maxHeight;
//   final Widget child;
//
//   @override
//   double get minExtent => minHeight;
//
//   @override
//   double get maxExtent => math.max(maxHeight, minHeight);
//
//   @override
//   Widget build(
//       BuildContext context, double shrinkOffset, bool overlapsContent) {
//     return SizedBox.expand(child: child);
//   }
//
//   @override
//   bool shouldRebuild(SliverAppBarDelegate oldDelegate) {
//     return maxHeight != oldDelegate.maxHeight ||
//         minHeight != oldDelegate.minHeight ||
//         child != oldDelegate.child;
//   }
// }
