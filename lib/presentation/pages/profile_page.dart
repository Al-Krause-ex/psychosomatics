import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:psychosomatics/constants/hexcolor_str.dart';
import 'package:psychosomatics/data/models/custom_user.dart';
import 'package:psychosomatics/domain/cubit/user_cubit.dart';
import 'package:psychosomatics/presentation/widgets/alert_dialog_edit_profile.dart';

class ProfilePage extends StatelessWidget {
  final UserCubit userCubit;

  const ProfilePage({Key? key, required this.userCubit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return Scaffold(
      backgroundColor: HexColor(primaryHexColor),
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 15.0),
          child: BlocBuilder<UserCubit, UserState>(
            builder: (context, state) {
              final user = userCubit.state.customUser;

              return _isPortrait
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: ListView(
                            children: [
                              ..._getContentWidgets(context, user!),
                            ],
                          ),
                        ),
                        _buildQuit(context),
                      ],
                    )
                  : _buildContent(context, user!);
            },
          ),
        ),
      ),
    );
  }

  List<Widget> _getContentWidgets(context, CustomUser user) {
    var listWidgets = <Widget>[
      _appBar(context),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Center(
          child: SvgPicture.asset(
            'assets/images/profile_image.svg',
            height: 220.0,
          ),
        ),
      ),
      const SizedBox(height: 30.0),
      _buildRowInfo(
        'assets/icons/person_icon.svg',
        user.name,
        width: 30.0,
        height: 28.0,
        sizedWith: 20.0,
      ),
      const SizedBox(height: 30.0),
      _buildRowInfo(
        'assets/icons/phone_icon.svg',
        user.phone,
        width: 40.0,
        height: 30.0,
        sizedWith: 10.0,
      ),
      const SizedBox(height: 30.0),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Align(
          alignment: Alignment.bottomLeft,
          child: TextButton(
            onPressed: () {
              // Navigator.of(context).pushNamed(subscriptionScreenRoute);

              // userCubit.changeStateTest();
            },
            style: TextButton.styleFrom(
              primary: HexColor(textButtonHexColor),
            ),
            child: const Text(
              'Подписка',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    ];

    return listWidgets;
  }

  Widget _buildQuit(context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(left: 15.0,right: 15.0, bottom: 20.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            fixedSize: Size(MediaQuery.of(context).size.width, 40.0),
            primary: HexColor(elevatedButtonHexColor),
          ),
          onPressed: () {
            userCubit.quit(context);
          },
          child: const Text(
            'Выйти',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(context, CustomUser user) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ..._getContentWidgets(context, user),
          const SizedBox(height: 50.0),
          _buildQuit(context),
        ],
      ),
    );
  }

  Widget _appBar(context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30.0),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: null,
              icon: Icon(
                Icons.filter_list,
                color: HexColor(primaryHexColor),
                size: 25.0,
              ),
            ),
            const Center(
              child: Text(
                'Профиль',
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
                    return BlocProvider.value(
                      value: userCubit,
                      child: AlertDialogEditProfile(userCubit: userCubit),
                    );
                  },
                );
              },
              icon: const Icon(
                Icons.edit,
                color: Colors.white,
                size: 25.0,
              ),
              splashRadius: 25.0,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRowInfo(
    String icon,
    String info, {
    required double width,
    required double height,
    required double sizedWith,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        children: [
          Container(
            width: width,
            height: height,
            alignment: Alignment.center,
            child: SvgPicture.asset(icon),
          ),
          SizedBox(width: sizedWith),
          Text(
            info,
            style: const TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
