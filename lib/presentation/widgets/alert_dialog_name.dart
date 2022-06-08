import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:psychosomatics/constants/hexcolor_str.dart';

class AlertDialogName extends StatefulWidget {
  const AlertDialogName({Key? key}) : super(key: key);

  @override
  _AlertDialogNameState createState() => _AlertDialogNameState();
}

class _AlertDialogNameState extends State<AlertDialogName> {
  final controller = TextEditingController();

  var hasError = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: HexColor(primaryHexColor),
      title: const Text(
        'Знакомство',
        style: TextStyle(color: Colors.white),
      ),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 45.0,
            padding: const EdgeInsets.only(left: 10.0, bottom: 4.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Colors.white, //HexColor(textFieldHexColor),
            ),
            child: TextField(
              controller: controller,
              textCapitalization: TextCapitalization.sentences,
              style: const TextStyle(color: Colors.black),
              cursorColor: Colors.black,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Ваше имя',
                hintStyle: TextStyle(
                  color: hasError ? Colors.red.shade300 : Colors.black38,
                ),
              ),
              onChanged: (v) {
                if (hasError && v.isNotEmpty) {
                  setState(() {
                    hasError = false;
                  });
                }
              },
            ),
          ),
          if (hasError) ...[
            const SizedBox(height: 5.0),
            Text(
              '*Пожалуйста, заполните поле',
              style: TextStyle(
                fontSize: 14.0,
                color: Colors.yellow.shade300,
              ),
            ),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            setState(() {
              if (controller.text.isEmpty) {
                hasError = true;
              } else {
                hasError = false;

                FocusManager.instance.primaryFocus?.unfocus();

                Navigator.of(context).pop(controller.text);
              }
            });
          },
          child: Text(
            'СОХРАНИТЬ',
            style: TextStyle(color: Colors.blue.shade200),
          ),
        ),
      ],
    );
  }
}
