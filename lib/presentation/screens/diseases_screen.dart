import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:psychosomatics/constants/hexcolor_str.dart';
import 'package:psychosomatics/constants/routes_str.dart';
import 'package:psychosomatics/presentation/widgets/alert_dialog_filter.dart';
import 'package:showcaseview/showcaseview.dart';

class DiseasesScreen extends StatefulWidget {
  const DiseasesScreen({Key? key}) : super(key: key);

  @override
  State<DiseasesScreen> createState() => _DiseasesScreenState();
}

class _DiseasesScreenState extends State<DiseasesScreen> {
  final _controllerFilter = TextEditingController();
  final keyOne = GlobalKey();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
        (_) => ShowCaseWidget.of(context)!.startShowCase([keyOne]));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return Scaffold(
      backgroundColor: HexColor(primaryHexColor),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            top: 15.0,
            bottom: 20.0,
            left: 20.0,
            right: 20.0,
          ),
          child: _isPortrait
              ? _buildContent(context, _isPortrait)
              : SingleChildScrollView(
                  child: _buildContent(context, _isPortrait),
                ),
        ),
      ),
    );
  }

  Widget _buildContent(context, isPortrait) {
    return Column(
      children: [
        _appBar(context),
        _buildTextField('Поиск болезни', 'Введите название', _controllerFilter),
        Showcase(
          key: keyOne,
          description: 'Test',
          child: _buildCard(context),
        ),
        if (isPortrait) const Spacer(),
        if (!isPortrait) const SizedBox(height: 20.0),
        Align(
          alignment: Alignment.bottomRight,
          child: InkWell(
            borderRadius: BorderRadius.circular(22.0),
            splashFactory: InkSplash.splashFactory,
            onTap: () {
              // showDialog(
              //   context: context,
              //   builder: (ctx) => AlertDialogEditProfile(isChangeName: false),
              // );
            },
            child: Container(
              width: 50.0,
              height: 50.0,
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
        ),
      ],
    );
  }

  Widget _appBar(context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
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
                  builder: (ctx) =>
                      const AlertDialogFilter(chosenTypeGroups: []),
                );
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
    );
  }

  Widget _buildTextField(
    String title,
    String hint,
    TextEditingController controller,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 15.0),
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 5.0),
        Container(
          height: 45.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: HexColor(textFieldHexColor),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 10.0, bottom: 4.0),
            child: TextField(
              controller: controller,
              textCapitalization: TextCapitalization.sentences,
              style: const TextStyle(color: Colors.white),
              cursorColor: Colors.white,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: hint,
                hintStyle: const TextStyle(color: Colors.white70),
              ),
            ),
          ),
        ),
        const SizedBox(height: 30.0),
      ],
    );
  }

  Widget _buildCard(context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(aboutIllnessScreen);
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 90.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: HexColor(textFieldHexColor),
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15.0, right: 15.0),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        'Сердце',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 2.0),
                      Text(
                        'Болезнь',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  SvgPicture.asset(
                    'assets/images/heart_image.svg',
                    height: 40.0,
                  )
                ],
              ),
            ),
            Positioned(
              right: 0.0,
              child: Container(
                width: 30.0,
                height: 20.0,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Icon(
                  Icons.star,
                  color: HexColor(primaryHexColor),
                  size: 15.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
