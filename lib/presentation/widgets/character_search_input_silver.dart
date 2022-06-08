import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:psychosomatics/constants/hexcolor_str.dart';
import 'package:rxdart/rxdart.dart';

class CharacterSearchInputSliver extends StatefulWidget {
  const CharacterSearchInputSliver({
    Key? key,
    this.onChanged,
    this.debounceTime,
  }) : super(key: key);
  final ValueChanged<String>? onChanged;
  final Duration? debounceTime;

  @override
  _CharacterSearchInputSliverState createState() =>
      _CharacterSearchInputSliverState();
}

class _CharacterSearchInputSliverState
    extends State<CharacterSearchInputSliver> {
  final StreamController<String> _textChangeStreamController =
  StreamController();
  late StreamSubscription _textChangesSubscription;

  @override
  void initState() {
    _textChangesSubscription = _textChangeStreamController.stream
        .debounceTime(
      widget.debounceTime ?? const Duration(seconds: 1),
    )
        .distinct()
        .listen((text) {
      final onChanged = widget.onChanged;
      if (onChanged != null) {
        onChanged(text);
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) => Container(
    height: 45.0,
    padding: const EdgeInsets.only(left: 10.0, bottom: 4.0),
    margin: const EdgeInsets.only(left: 14.0, right: 14.0),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10.0),
      color: HexColor(textFieldHexColor),
    ),
    child: TextField(
      textCapitalization: TextCapitalization.sentences,
      style: const TextStyle(color: Colors.white),
      cursorColor: Colors.white,
      decoration: const InputDecoration(
        prefixIcon: Icon(Icons.search, color: Colors.white),
        hintText: 'Название болезни',
        hintStyle: TextStyle(color: Colors.white70),
        border: InputBorder.none,
      ),
      onChanged: _textChangeStreamController.add,
    ),
  );

  @override
  void dispose() {
    _textChangeStreamController.close();
    _textChangesSubscription.cancel();
    super.dispose();
  }
}
