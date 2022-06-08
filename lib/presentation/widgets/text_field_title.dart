import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:psychosomatics/constants/hexcolor_str.dart';

class TextFieldTitle extends StatefulWidget {
  final String title;
  final double? width;
  final int? maxLength;
  final String hint;
  final TextEditingController controller;
  final TextInputType? textInputType;
  final Function? func;
  final List<TextInputFormatter>? inputFormatters;

  const TextFieldTitle({
    Key? key,
    required this.title,
    required this.hint,
    required this.controller,
    this.width,
    this.maxLength,
    this.textInputType,
    this.func,
    this.inputFormatters,
  }) : super(key: key);

  @override
  _TextFieldTitleState createState() => _TextFieldTitleState();
}

class _TextFieldTitleState extends State<TextFieldTitle> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 15.0),
        Text(
          widget.title,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 5.0),
        Container(
          height: 45.0,
          width: widget.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: HexColor(textFieldHexColor),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 10.0, bottom: 4.0),
            child: TextField(
              controller: widget.controller,
              textCapitalization: TextCapitalization.sentences,
              style: const TextStyle(color: Colors.white),
              cursorColor: Colors.white,
              keyboardType: widget.textInputType,
              inputFormatters: widget.inputFormatters,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: widget.hint,
                hintStyle: const TextStyle(color: Colors.white70),
                counterText: "",
              ),
              onChanged: widget.func != null
                  ? (_) {
                      widget.func!();
                    }
                  : null,
              maxLength: widget.maxLength,
            ),
          ),
        ),
      ],
    );
  }
}
