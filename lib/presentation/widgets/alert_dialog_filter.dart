import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:psychosomatics/constants/hexcolor_str.dart';
import 'package:psychosomatics/data/models/illness.dart';

enum Organ {
  initial,
  all,
  hand,
  legs,
  head,
  body,
  infections,
  neurology,
  psyche,
  other,
}

class AlertDialogFilter extends StatefulWidget {
  final List<TypeGroup> chosenTypeGroups;

  const AlertDialogFilter({Key? key, required this.chosenTypeGroups})
      : super(key: key);

  @override
  State<AlertDialogFilter> createState() => _AlertDialogFilterState();
}

class _AlertDialogFilterState extends State<AlertDialogFilter> {
  var isAll = false;
  var isHand = false;
  var isLegs = false;
  var isHead = false;
  var isBody = false;
  var isInfections = false;
  var isNeurology = false;
  var isPsyche = false;
  var isOther = false;

  @override
  void initState() {
    for (var chosenTypeGroup in widget.chosenTypeGroups) {
      switch (chosenTypeGroup) {
        case TypeGroup.hands:
          isHand = true;
          break;
        case TypeGroup.legs:
          isLegs = true;
          break;
        case TypeGroup.head:
          isHead = true;
          break;
        case TypeGroup.body:
          isBody = true;
          break;
        case TypeGroup.infection:
          isInfections = true;
          break;
        case TypeGroup.neurology:
          isNeurology = true;
          break;
        case TypeGroup.psyche:
          isPsyche = true;
          break;
        case TypeGroup.other:
          isOther = true;
          break;
      }

      if (isHand &&
          isLegs &&
          isHead &&
          isBody &&
          isInfections &&
          isNeurology &&
          isPsyche &&
          isOther) {
        isAll = true;
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Фильтр по органам',
        style: TextStyle(color: Colors.black),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: Row(
              children: [
                const Text('Все органы'),
                const SizedBox(width: 10.0),
                CupertinoSwitch(
                    activeColor: HexColor(primaryHexColor),
                    value: isAll,
                    onChanged: (isChecked) {
                      setState(() {
                        isAll = isChecked;

                        if (isChecked) {
                          turnOnOffCheckboxes(true);
                        } else {
                          turnOnOffCheckboxes(false);
                        }
                      });
                    }),
              ],
            ),
          ),
          _buildCheckBox(Organ.hand, 'Руки'),
          _buildCheckBox(Organ.legs, 'Ноги'),
          _buildCheckBox(Organ.head, 'Голова'),
          _buildCheckBox(Organ.body, 'Тело'),
          _buildCheckBox(Organ.infections, 'Инфекции'),
          _buildCheckBox(Organ.neurology, 'Неврология'),
          _buildCheckBox(Organ.psyche, 'Психика'),
          _buildCheckBox(Organ.other, 'Остальное'),
        ],
      ),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.of(context).pop(getIdGroups());
            },
            child: Text(
              'ВЫБРАТЬ',
              style: TextStyle(color: HexColor(elevatedButtonHexColor)),
            )),
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              'ОТМЕНА',
              style: TextStyle(color: HexColor(elevatedButtonHexColor)),
            )),
      ],
    );
  }

  Widget _buildCheckBox(Organ organ, String title) {
    var value = _getValueByOrgan(organ);

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Checkbox(
            value: value,
            activeColor: HexColor(primaryHexColor),
            onChanged: (isChecked) {
              setState(() {
                _setValueByOrgan(organ, isChecked!);
              });
            }),
        Text(title),
      ],
    );
  }

  bool _getValueByOrgan(Organ organ) {
    switch (organ) {
      case Organ.hand:
        return isHand;
      case Organ.legs:
        return isLegs;
      case Organ.head:
        return isHead;
      case Organ.body:
        return isBody;
      case Organ.infections:
        return isInfections;
      case Organ.neurology:
        return isNeurology;
      case Organ.psyche:
        return isPsyche;
      case Organ.other:
        return isOther;
      case Organ.initial:
        return isAll;
      case Organ.all:
        return isAll;
    }
  }

  void _setValueByOrgan(Organ organ, bool isChecked) {
    switch (organ) {
      case Organ.hand:
        isHand = isChecked;
        break;
      case Organ.legs:
        isLegs = isChecked;
        break;
      case Organ.head:
        isHead = isChecked;
        break;
      case Organ.body:
        isBody = isChecked;
        break;
      case Organ.infections:
        isInfections = isChecked;
        break;
      case Organ.neurology:
        isNeurology = isChecked;
        break;
      case Organ.psyche:
        isPsyche = isChecked;
        break;
      case Organ.other:
        isOther = isChecked;
        break;
      case Organ.initial:
        break;
      case Organ.all:
        break;
    }
  }

  void turnOnOffCheckboxes(bool isOn) {
    if (isOn) {
      isHand = true;
      isLegs = true;
      isHead = true;
      isBody = true;
      isInfections = true;
      isNeurology = true;
      isPsyche = true;
      isOther = true;
    } else {
      isHand = false;
      isLegs = false;
      isHead = false;
      isBody = false;
      isInfections = false;
      isNeurology = false;
      isPsyche = false;
      isOther = false;
    }
  }

  List<int> getIdGroups() {
    List<int> ids = [];

    if (isHand) ids.add(0);
    if (isLegs) ids.add(1);
    if (isHead) ids.add(2);
    if (isBody) ids.add(3);
    if (isInfections) ids.add(4);
    if (isNeurology) ids.add(5);
    if (isPsyche) ids.add(6);
    if (isOther) ids.add(7);

    return ids;
  }
}
