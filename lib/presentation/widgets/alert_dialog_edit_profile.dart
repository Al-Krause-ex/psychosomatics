import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:psychosomatics/constants/hexcolor_str.dart';
import 'package:psychosomatics/data/models/custom_user.dart';
import 'package:psychosomatics/domain/cubit/user_cubit.dart';

class AlertDialogEditProfile extends StatefulWidget {
  final UserCubit userCubit;

  const AlertDialogEditProfile({Key? key, required this.userCubit})
      : super(key: key);

  @override
  State<AlertDialogEditProfile> createState() => _AlertDialogEditProfileState();
}

class _AlertDialogEditProfileState extends State<AlertDialogEditProfile> {
  final _controller = TextEditingController();
  CustomUser? user;

  var isLoading = false;

  @override
  void initState() {
    user = widget.userCubit.state.customUser;
    _controller.text = user!.name;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserState>(
      builder: (context, state) {
        // print('in state: $state');

        return AlertDialog(
          title: const Text('Редактирование профиля'),
          content: _buildTextField('', 'Имя', _controller),
          actions: [
            isLoading
                ? Container(
                    width: 82.0,
                    alignment: Alignment.center,
                    child: SizedBox(
                      height: 22.0,
                      width: 22.0,
                      child: CircularProgressIndicator(
                        color: HexColor(elevatedButtonHexColor),
                        strokeWidth: 2.5,
                      ),
                    ),
                  )
                : TextButton(
                    onPressed: () async {
                      if (user!.name != _controller.text) {
                        setState(() {
                          isLoading = true;
                        });
                        await widget.userCubit
                            .updateUser(user!.id, _controller.text)
                            .then((value) {
                          setState(() {
                            isLoading = false;
                          });

                          Fluttertoast.showToast(
                            msg: 'Имя изменено!',
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: HexColor(elevatedButtonHexColor),
                            textColor: Colors.white,
                            fontSize: 16.0,
                          );
                        });
                      }

                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'СОХРАНИТЬ',
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
      },
    );
  }

  Widget _buildTextField(
    String title,
    String hint,
    TextEditingController controller,
  ) {
    return Container(
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
    );
  }
}
