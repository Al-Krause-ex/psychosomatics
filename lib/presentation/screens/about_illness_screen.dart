import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:psychosomatics/constants/hexcolor_str.dart';
import 'package:psychosomatics/data/models/illness.dart';
import 'package:psychosomatics/domain/cubit/user_cubit.dart';

class AboutIllnessScreen extends StatefulWidget {
  final UserCubit userCubit;
  final Illness illness;

  const AboutIllnessScreen(
      {Key? key, required this.userCubit, required this.illness})
      : super(key: key);

  @override
  State<AboutIllnessScreen> createState() => _AboutIllnessScreenState();
}

class _AboutIllnessScreenState extends State<AboutIllnessScreen> {
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
  var isSetState = false;
  var isLoading = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => !isLoading,
      child: Scaffold(
        appBar: _appBar(context),
        backgroundColor: HexColor(primaryHexColor),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(
              left: 15.0,
              right: 15.0,
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _buildSection('Проблема', widget.illness.name),
                  _buildDivider(),
                  _buildSection('Вероятная причина', widget.illness.cause),
                  _buildDivider(),
                  _buildSection('Аффирмация', widget.illness.affirmation),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  PreferredSize _appBar(context) {
    var isFavorite = widget.userCubit.state.customUser!.favorites
            .where((f) => f == widget.illness.id)
            .toList()
            .isEmpty
        ? false
        : true;

    return PreferredSize(
      preferredSize: preferredSize + const Offset(0, 20.0),
      child: Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: isLoading
                    ? null
                    : () {
                        Navigator.of(context).pop({
                          'setState': isSetState,
                          'isFavorite': !isFavorite
                        });
                      },
                icon: const Icon(
                  Icons.arrow_back_ios_outlined,
                  color: Colors.white,
                ),
                splashRadius: 25.0,
              ),
              const Center(
                child: Text(
                  'Подробнее о болезни',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              if (isLoading)
                Container(
                    width: 22.0,
                    height: 22.0,
                    margin: const EdgeInsets.only(left: 12.0, right: 14.0),
                    child: const CircularProgressIndicator(strokeWidth: 3.0))
              else
                IconButton(
                  onPressed: () async {
                    setState(() {
                      isLoading = true;
                    });

                    await widget.userCubit
                        .changeFavoriteIllness(widget.illness, !isFavorite)
                        .then((value) {
                      // widget.userCubit.favoriteCubit
                      //     .changedFavorite(widget.illness, !isFavorite);

                      setState(() {
                        isSetState = true;
                        isLoading = false;
                      });
                    });
                  },
                  icon: Icon(
                    isFavorite ? Icons.star : Icons.star_border,
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

  Widget _buildSection(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16.0,
          ),
        ),
        const SizedBox(height: 5.0),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18.0,
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.only(
        top: 10.0,
        bottom: 10.0,
      ),
      child: Divider(
        color: HexColor('#E1F6FB'),
      ),
    );
  }
}
