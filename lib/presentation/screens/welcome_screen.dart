import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:psychosomatics/constants/hexcolor_str.dart';
import 'package:psychosomatics/constants/routes_str.dart';
import 'package:psychosomatics/constants/welcome_text_str.dart';
import 'package:psychosomatics/domain/cubit/logo_cubit.dart';

class WelcomeScreen extends StatelessWidget {
  final LogoCubit logoCubit;

  WelcomeScreen({Key? key, required this.logoCubit}) : super(key: key);

  final _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    final bool _isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return Scaffold(
      backgroundColor: HexColor(primaryHexColor),
      body: SafeArea(
        child: PageView.builder(
          controller: _pageController,
          itemCount: listInfo.length,
          itemBuilder: (ctx, i) {
            return _isPortrait
                ? _buildContent(context, i, _isPortrait)
                : SingleChildScrollView(
                    child: _buildContent(context, i, _isPortrait));
          },
        ),
      ),
    );
  }

  Widget _buildContent(context, int i, bool _isPortrait) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 30.0,
        bottom: 20.0,
        left: 20.0,
        right: 20.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 30.0),
          Center(
            child: SvgPicture.asset(
              'assets/images/welcome_image.svg',
              height: 260.0,
            ),
          ),
          const SizedBox(height: 30.0),
          const Text(
            '"SANITY" познакомит тебя с психосоматикой',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          _buildInfo(context, i),
          if (_isPortrait) const Spacer(),
          if (!_isPortrait) const SizedBox(height: 30.0),
          _buildRowCircles(context, i, _isPortrait),
          _buildSkipButton(context, i),
        ],
      ),
    );
  }

  Widget _buildInfo(context, int page) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (listInfo[page]['subtitle'].isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Text(
              listInfo[page]['subtitle'],
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        if (listInfo[page]['info'].isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Text(
              listInfo[page]['info'],
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        if (listInfo[page]['enumeration'].length > 0) ...[
          const SizedBox(height: 10.0),
          ...listInfo[page]['enumeration'].map(
            (info) => Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 5.0, right: 10.0),
                    child: Icon(
                      Icons.circle,
                      color: Colors.white,
                      size: 6.0,
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 56.0,
                    child: Text(
                      info,
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ]
      ],
    );
  }

  Widget _buildRowCircles(context, int page, bool _isPortrait) {
    var listCircles = <Widget>[];

    for (var i = 0; i < 4; i++) {
      if (page < i) {
        listCircles.add(Icon(
          Icons.circle,
          color: HexColor(primaryOpacityHexColor),
          size: 20.0,
        ));
      } else {
        listCircles.add(const Icon(
          Icons.circle,
          color: Colors.white,
          size: 20.0,
        ));
      }
    }

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal:
            MediaQuery.of(context).size.width / (_isPortrait ? 3.5 : 2.5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ...listCircles,
        ],
      ),
    );
  }

  Widget _buildSkipButton(context, int page) {
    return Center(
      child: TextButton(
        style: TextButton.styleFrom(primary: HexColor(textButtonHexColor)),
        onPressed: () {
          logoCubit.changeFirstTime();
          Navigator.pushReplacementNamed(context, authScreen);
        },
        child: Text(page == 3 ? 'Завершить' : 'Пропустить'),
      ),
    );
  }
}
