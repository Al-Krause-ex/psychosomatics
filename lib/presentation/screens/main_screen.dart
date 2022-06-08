import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:psychosomatics/constants/hexcolor_str.dart';
import 'package:psychosomatics/domain/cubit/user_cubit.dart';
import 'package:psychosomatics/presentation/pages/favorite_page_cub.dart';
import 'package:psychosomatics/presentation/pages/home_page.dart';
import 'package:psychosomatics/presentation/pages/profile_page.dart';
import 'package:psychosomatics/presentation/widgets/custom_show_case_widget.dart';
import 'package:showcaseview/showcaseview.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final keyOne = GlobalKey();
  final keyTwo = GlobalKey();
  final keyThree = GlobalKey();
  final keyFour = GlobalKey();
  final keyFive = GlobalKey();
  final keySix = GlobalKey();
  final keySeven = GlobalKey();
  final keyEight = GlobalKey();

  final keyNine = GlobalKey();
  final keyTen = GlobalKey();
  final keyEleven = GlobalKey();

  @override
  void initState() {
    WidgetsBinding.instance
        .addPostFrameCallback((_) => ShowCaseWidget.of(context)!.startShowCase([
              keyOne,
              keyTwo,
              keyThree,
              keyFour,
              keyFive,
              keySix,
              keySeven,
              keyEight,
              keyNine,
              keyTen,
              keyEleven,
            ]));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // print('rebuild mainscreen');

    var blocProvider = BlocProvider.of<UserCubit>(context);

    blocProvider.initialize();

    final _pageNavigation = <Widget>[
      HomePage(globalKeys: [
        keyOne,
        keyTwo,
        keyThree,
        keyFour,
        keyFive,
        keySix,
        keySeven,
        keyEight,
      ]),
      BlocProvider.value(
        value: blocProvider.favoriteCubit,
        child: FavoritePageCub(user: blocProvider.state.customUser!),
      ),
      // FavoritePageNew(user: blocProvider.state.customUser!),
      ProfilePage(userCubit: blocProvider),
    ];

    return BlocBuilder<UserCubit, UserState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: HexColor(primaryHexColor),
          body: IndexedStack(
            index: state.indexPage.index,
            children: _pageNavigation,
          ),
          bottomNavigationBar: Theme(
            data: ThemeData(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
            ),
            child: BottomNavigationBar(
              backgroundColor: HexColor(primaryHexColor),
              selectedItemColor: Colors.white,
              unselectedItemColor: Colors.white54,
              type: BottomNavigationBarType.fixed,
              elevation: 0.0,
              showSelectedLabels: false,
              showUnselectedLabels: false,
              currentIndex: state.indexPage.index,
              onTap: (int index) {
                blocProvider.changePage(index);
              },
              items: [
                BottomNavigationBarItem(
                  icon: CustomShowCaseWidget(
                    globalKey: keyNine,
                    child: const Icon(
                      Icons.home_outlined,
                    ),
                    desc: 'Главное меню',
                    paddingAll: 8.0,
                  ),
                  label: '',
                  tooltip: 'Главная',
                ),
                BottomNavigationBarItem(
                  icon: CustomShowCaseWidget(
                    globalKey: keyTen,
                    child: const Icon(
                      Icons.star_border_outlined,
                    ),
                    desc: 'Избранное',
                    paddingAll: 8.0,
                  ),
                  label: '',
                  tooltip: 'Избранное',
                ),
                BottomNavigationBarItem(
                  icon: CustomShowCaseWidget(
                    globalKey: keyEleven,
                    child: const Icon(
                      Icons.person_outline,
                    ),
                    desc: 'Профиль',
                    paddingAll: 8.0,
                  ),
                  label: '',
                  tooltip: 'Профиль',
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
