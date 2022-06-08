import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:psychosomatics/constants/hexcolor_str.dart';
import 'package:psychosomatics/constants/icons_str.dart';
import 'package:psychosomatics/constants/routes_str.dart';
import 'package:psychosomatics/data/models/illness.dart';
import 'package:psychosomatics/presentation/widgets/custom_show_case_widget.dart';

class HomePage extends StatefulWidget {
  final List<GlobalKey> globalKeys;

  const HomePage({Key? key, required this.globalKeys}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final _isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return Scaffold(
      backgroundColor: HexColor(primaryHexColor),
      body: SafeArea(
        child: _isPortrait
            ? _buildContent(context, _isPortrait)
            : SingleChildScrollView(child: _buildContent(context, _isPortrait)),
      ),
    );
  }

  Widget _buildContent(context, bool isPortrait) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 28.0,
        bottom: 20.0,
        left: 5.0,
        right: 5.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Center(
            child: Text(
              'Главная',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          if (isPortrait) const Spacer(),
          if (!isPortrait) const SizedBox(height: 30.0),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Stack(
              children: [
                Center(
                  child: Image.asset(
                    mainImage,
                    height: 365.0,
                  ),
                ),
                Column(
                  children: [
                    _buildRowButtons(
                      context,
                      edgeInsets: EdgeInsets.symmetric(
                        horizontal: (isPortrait ? 40.0 : 140.0),
                      ),
                      leftImage: psycheIconMain,
                      leftId: 6,
                      globalKeyLeft: widget.globalKeys[0],
                      descLeft: 'Болезни по группе "Психика"',
                      rightImage: headIconMain,
                      rightId: 2,
                      globalKeyRight: widget.globalKeys[1],
                      descRight: 'Болезни по группе "Голова"',
                    ),
                    _buildRowButtons(
                      context,
                      edgeInsets: EdgeInsets.only(
                        top: 10.0,
                        left: isPortrait ? 0.0 : 95.0,
                        right: isPortrait ? 0.0 : 95.0,
                      ),
                      leftImage: neurologyIconMain,
                      leftId: 5,
                      globalKeyLeft: widget.globalKeys[2],
                      descLeft: 'Болезни по группе "Неврология"',
                      rightImage: bodyIconMain,
                      rightId: 3,
                      globalKeyRight: widget.globalKeys[3],
                      descRight: 'Болезни по группе "Тело"',
                    ),
                    _buildRowButtons(
                      context,
                      edgeInsets: EdgeInsets.only(
                        top: 10.0,
                        bottom: 10.0,
                        left: isPortrait ? 0.0 : 95.0,
                        right: isPortrait ? 0.0 : 95.0,
                      ),
                      leftImage: infectionIconMain,
                      leftId: 4,
                      globalKeyLeft: widget.globalKeys[4],
                      descLeft: 'Болезни по группе "Инфекция"',
                      rightImage: otherIconMain,
                      rightId: 7,
                      globalKeyRight: widget.globalKeys[5],
                      descRight: 'Болезни по группе "Остальное"',
                    ),
                    _buildRowButtons(
                      context,
                      edgeInsets: EdgeInsets.symmetric(
                          horizontal: isPortrait ? 30.0 : 140.0),
                      leftImage: handIconMain,
                      leftId: 0,
                      globalKeyLeft: widget.globalKeys[6],
                      descLeft: 'Болезни по группе "Рука"',
                      rightImage: legIconMain,
                      rightId: 1,
                      globalKeyRight: widget.globalKeys[7],
                      descRight: 'Болезни по группе "Нога"',
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (isPortrait) const Spacer(),
          if (!isPortrait) const SizedBox(height: 30.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                fixedSize: Size(MediaQuery.of(context).size.width, 40.0),
                primary: HexColor(elevatedButtonHexColor),
              ),
              onPressed: () {
                var listTypeGroups = <TypeGroup>[];

                for (var i = 0; i < 8; i++) {
                  listTypeGroups.add(TypeGroup.values[i]);
                }

                Navigator.of(context)
                    .pushNamed(illnessScreen, arguments: listTypeGroups);
              },
              child: const Text(
                'Все болезни',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRowButtons(
    context, {
    required EdgeInsets edgeInsets,
    required String leftImage,
    required int leftId,
    required GlobalKey globalKeyLeft,
    required String descLeft,
    required String rightImage,
    required int rightId,
    required GlobalKey globalKeyRight,
    required String descRight,
  }) {
    return Padding(
      padding: edgeInsets,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(50.0),
            splashFactory: InkSplash.splashFactory,
            onTap: () {
              Navigator.of(context).pushNamed(illnessScreen,
                  arguments: [TypeGroup.values[leftId]]);
            },
            child: CustomShowCaseWidget(
              globalKey: globalKeyLeft,
              desc: descLeft,
              paddingAll: 1.0,
              isCircle: true,
              child: Container(
                padding: const EdgeInsets.all(10.0),
                child: Image.asset(
                  leftImage,
                  height: 65.0,
                ),
              ),
            ),
          ),
          CustomShowCaseWidget(
            globalKey: globalKeyRight,
            desc: descRight,
            paddingAll: 1.0,
            isCircle: true,
            child: InkWell(
              borderRadius: BorderRadius.circular(50.0),
              splashFactory: InkSplash.splashFactory,
              onTap: () {
                Navigator.of(context).pushNamed(illnessScreen,
                    arguments: [TypeGroup.values[rightId]]);
              },
              child: Container(
                padding: const EdgeInsets.all(10.0),
                child: Image.asset(
                  rightImage,
                  height: 65.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
