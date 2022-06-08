import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:psychosomatics/constants/hexcolor_str.dart';
import 'package:psychosomatics/data/cloud_firestore_tool.dart';

class AlertDialogSuggestion extends StatefulWidget {
  final String userId;
  final String userName;

  const AlertDialogSuggestion(
      {Key? key, required this.userId, required this.userName})
      : super(key: key);

  @override
  _AlertDialogSuggestionState createState() => _AlertDialogSuggestionState();
}

class _AlertDialogSuggestionState extends State<AlertDialogSuggestion> {
  final controller = TextEditingController();

  var hasError = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Запрос на добавление болезни',
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
              color: HexColor(textFieldHexColor),
            ),
            child: TextField(
              controller: controller,
              textCapitalization: TextCapitalization.sentences,
              style: const TextStyle(color: Colors.white),
              cursorColor: Colors.white,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Название болезни',
                hintStyle: TextStyle(color: Colors.white),
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
                color: Colors.red.shade500,
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

                var cfTool = CloudFirestoreTool();
                cfTool
                    .sendSuggestion(
                  widget.userId,
                  widget.userName,
                  controller.text,
                );

                Fluttertoast.showToast(
                  msg: 'Запрос отправлен!',
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: HexColor(elevatedButtonHexColor),
                  textColor: Colors.white,
                  fontSize: 16.0,
                );

                Navigator.of(context).pop();
              }
            });
          },
          child: Text(
            'ОТПРАВИТЬ',
            style: TextStyle(color: HexColor(elevatedButtonHexColor)),
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            'ОТМЕНА',
            style: TextStyle(color: HexColor(elevatedButtonHexColor)),
          ),
        ),
      ],
    );
  }
}
