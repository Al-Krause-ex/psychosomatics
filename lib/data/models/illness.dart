import 'package:psychosomatics/constants/icons_str.dart';

enum TypeGroup { hands, legs, head, body, infection, neurology, psyche, other }

enum TypeSubGroup { sg1, sg2, sg3, sg4, sg5, sg6, sg7, sg8, sg9, sg10 }

class Illness {
  String id;
  String name;
  String cause;
  String affirmation;
  TypeGroup typeGroup;
  TypeSubGroup typeSubGroup;

  Illness({
    required this.id,
    required this.name,
    required this.cause,
    required this.affirmation,
    required this.typeGroup,
    required this.typeSubGroup,
  });

  Illness.fromJson(this.id, Map json)
      : name = json['name'],
        cause = json['cause'],
        affirmation = json['affirmation'],
        typeGroup = TypeGroup.values[json['type_group']],
        typeSubGroup = TypeSubGroup.values[json['sub_group']];

  static String getGroupName(TypeGroup typeGroup) {
    switch (typeGroup) {
      case TypeGroup.hands:
        return 'Рука';
      case TypeGroup.legs:
        return 'Нога';
      case TypeGroup.head:
        return 'Голова';
      case TypeGroup.body:
        return 'Тело';
      case TypeGroup.infection:
        return 'Инфекция';
      case TypeGroup.neurology:
        return 'Неврология';
      case TypeGroup.psyche:
        return 'Психика';
      case TypeGroup.other:
        return 'Остальное';
      default:
        return '';
    }
  }

  static String getGroupIconAsset(TypeGroup typeGroup) {
    switch (typeGroup) {
      case TypeGroup.hands:
        return handIcon;
      case TypeGroup.legs:
        return legIcon;
      case TypeGroup.head:
        return headIcon;
      case TypeGroup.body:
        return bodyIcon;
      case TypeGroup.infection:
        return infectionIcon;
      case TypeGroup.neurology:
        return neurologyIcon;
      case TypeGroup.psyche:
        return psycheIcon;
      case TypeGroup.other:
        return otherIcon;
      default:
        return '';
    }
  }
}
