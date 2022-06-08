import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:psychosomatics/constants/hexcolor_str.dart';
import 'package:psychosomatics/constants/routes_str.dart';
import 'package:psychosomatics/data/models/illness.dart';

/// List item representing a single Character with its photo and name.
class CharacterListItem extends StatefulWidget {
  const CharacterListItem({
    required this.illness,
    required this.favoriteIllness,
    Key? key,
  }) : super(key: key);

  final Illness illness;
  final List<String> favoriteIllness;

  @override
  State<CharacterListItem> createState() => _CharacterListItemState();
}

class _CharacterListItemState extends State<CharacterListItem> {
  var isFavorite = false;

  @override
  Widget build(BuildContext context) {
    isFavorite = widget.favoriteIllness
            .where((ill) => ill == widget.illness.id)
            .isNotEmpty
        ? true
        : false;

    return ListTile(
      title: InkWell(
        onTap: () {
          Navigator.of(context)
              .pushNamed(aboutIllnessScreen, arguments: widget.illness)
              .then((value) {
                // print(value);
            if (value != null &&
                (value as Map<String, dynamic>)['setState'] == true) {
              setState(() {
                isFavorite = value['isFavorite'];
                // print(isFavorite);
              });
            }
          });
        },
        child: Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.only(bottom: 20.0, top: 20.0),
              margin: const EdgeInsets.only(bottom: 5.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: HexColor(textFieldHexColor),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width - 100.0,
                          child: Text(
                            widget.illness.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4.0),
                        SizedBox(
                          width: MediaQuery.of(context).size.width - 100.0,
                          child: Text(
                            Illness.getGroupName(widget.illness.typeGroup),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    SizedBox(
                      width: MediaQuery.of(context).size.width - (MediaQuery.of(context).size.width - 100.0) - 62.0,
                      child: SvgPicture.asset(
                        Illness.getGroupIconAsset(widget.illness.typeGroup),
                        height: 34.0,
                      ),
                    )
                  ],
                ),
              ),
            ),
            if (isFavorite)
              Positioned(
                top: 0.0,
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
