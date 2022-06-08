import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:psychosomatics/constants/hexcolor_str.dart';
import 'package:psychosomatics/constants/routes_str.dart';
import 'package:psychosomatics/domain/cubit/auth_cubit.dart';
import 'package:psychosomatics/domain/cubit/user_cubit.dart';
import 'package:psychosomatics/presentation/widgets/alert_dialog_name.dart';

class VerifyScreen extends StatefulWidget {
  final AuthCubit authCubit;

  const VerifyScreen({
    Key? key,
    // required this.isRegister,
    required this.authCubit,
  }) : super(key: key);

  @override
  _VerifyScreenState createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final formKey = GlobalKey<FormState>();

  TextEditingController otpController = TextEditingController();

  // ignore: close_sinks
  StreamController<ErrorAnimationType>? errorController;

  var hasError = false;
  var currentText = "";
  var otpLoading = false;

  Map<String, dynamic> mapData = {
    'otpVisibility': false,
    'verificationID': '',
    'smsCode': '',
    'phone': '',
  };

  @override
  void initState() {
    var authState = widget.authCubit.state;

    // mapData['name'] = (authState as AuthInitial).name;
    mapData['phone'] = (authState as AuthInitial).phone;

    errorController = StreamController<ErrorAnimationType>();
    widget.authCubit.signIn(context, mapData);
    super.initState();
  }

  @override
  void dispose() {
    errorController!.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    var padding = MediaQuery.of(context).padding;
    double height = MediaQuery.of(context).size.height -
        padding.top -
        padding.bottom -
        50.0;

    return Scaffold(
      backgroundColor: HexColor(primaryHexColor),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(
              top: 30.0,
              bottom: 20.0,
              left: 20.0,
              right: 20.0,
            ),
            child: _isPortrait
                ? SizedBox(
                    height: height,
                    child: _buildContent(context, _isPortrait),
                  )
                : _buildContent(context, _isPortrait),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(context, bool isPortrait) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 10.0),
                const Text(
                  'Верификация профиля',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20.0),
            Center(
                child: SvgPicture.asset(
              'assets/images/verify_image.svg',
              height: 260.0,
            )),
            const SizedBox(height: 20.0),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 30.0, vertical: 8),
              child: RichText(
                text: TextSpan(
                  text: "Введите код, отправленный на номер: ",
                  children: [
                    TextSpan(
                      text: mapData['phone'],
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ],
                  style: const TextStyle(color: Colors.white, fontSize: 15),
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20.0),
            Form(
              key: formKey,
              child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: PinCodeTextField(
                    appContext: context,
                    pastedTextStyle: TextStyle(
                      color: Colors.green.shade600,
                      fontWeight: FontWeight.bold,
                    ),
                    length: 6,
                    obscureText: false,
                    blinkWhenObscuring: true,
                    animationType: AnimationType.fade,
                    validator: null,
                    pinTheme: PinTheme(
                      shape: PinCodeFieldShape.box,
                      borderRadius: BorderRadius.circular(5),
                      fieldHeight: 50,
                      fieldWidth: 40,
                      activeFillColor: Colors.white,
                      inactiveFillColor: HexColor(textFieldHexColor),
                      selectedFillColor: HexColor(textFieldHexColor),
                      activeColor: HexColor(textFieldHexColor),
                      selectedColor: Colors.white,
                      inactiveColor: HexColor(textFieldHexColor),
                    ),
                    cursorColor: Colors.black,
                    animationDuration: const Duration(milliseconds: 300),
                    enableActiveFill: true,
                    errorAnimationController: errorController,
                    controller: otpController,
                    keyboardType: TextInputType.number,
                    boxShadows: const [
                      BoxShadow(
                        offset: Offset(0, 1),
                        color: Colors.black12,
                        blurRadius: 10,
                      )
                    ],
                    onCompleted: (v) {},
                    onChanged: (value) {
                      setState(() {
                        currentText = value;

                        if (currentText.isNotEmpty) {
                          hasError = false;
                        }
                      });
                    },
                    beforeTextPaste: (text) {
                      //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                      //but you can show anything you want here, like your pop up saying wrong paste format or etc
                      return true;
                    },
                  )),
            ),
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                child: Text(
                  'Очистить',
                  style: TextStyle(color: Colors.blue.shade200),
                ),
                onPressed: () {
                  setState(() {
                    otpController.clear();
                    hasError = false;
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(
                hasError ? "*Пожалуйста, заполните все ячейки правильно" : "",
                style: const TextStyle(
                  color: Colors.yellow,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            const SizedBox(height: 20),
            if (otpLoading)
              const Padding(
                padding: EdgeInsets.only(top: 16.0),
                child: Center(
                  child: CircularProgressIndicator(color: Colors.white),
                ),
              ),
            if (!otpLoading)
              Container(
                margin:
                    const EdgeInsets.symmetric(vertical: 16.0, horizontal: 30),
                child: ButtonTheme(
                  height: 50,
                  child: TextButton(
                    onPressed: otpController.text.length >= 6
                        ? () async {
                            formKey.currentState!.validate();

                            setState(() {
                              otpLoading = true;
                            });

                            mapData['smsCode'] = otpController.text;

                            await widget.authCubit
                                .verifyOtp(context, mapData)
                                .then((value) {
                              hasError = value;

                              setState(() {
                                otpLoading = false;
                              });

                              if (hasError) {
                                errorController!.add(ErrorAnimationType.shake);
                              } else {
                                // snackBar(context, "Вы верифицированы!");

                                var newCustomUser = (widget.authCubit.userCubit
                                        .state as UserAuthorized)
                                    .customUser;

                                if (newCustomUser!.isNewUser) {
                                  showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (ctx) => const AlertDialogName(),
                                  ).then((value) {
                                    widget.authCubit.userCubit
                                        .changeDataFromVerify(
                                            newCustomUser.id, value);

                                    widget.authCubit.userCubit.illnessCubit
                                        .initialize(
                                            context,
                                            widget.authCubit.userCubit.state
                                                .customUser!);

                                    Navigator.of(context)
                                        .pushReplacementNamed(mainScreen);
                                  });
                                } else {
                                  widget.authCubit.userCubit.illnessCubit
                                      .initialize(
                                          context,
                                          widget.authCubit.userCubit.state
                                              .customUser!);

                                  Navigator.of(context)
                                      .pushReplacementNamed(mainScreen);
                                }
                              }
                            });
                          }
                        : null,
                    child: Center(
                        child: Text(
                      "ВЕРИФИКАЦИЯ".toUpperCase(),
                      style: TextStyle(
                        color: otpController.text.length >= 6
                            ? Colors.white
                            : Colors.blueGrey,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    )),
                  ),
                ),
                decoration: BoxDecoration(
                    color: otpController.text.length >= 6
                        ? Colors.blue.shade300
                        : Colors.blueGrey.shade300,
                    borderRadius: BorderRadius.circular(5),
                    boxShadow: [
                      BoxShadow(
                          color: otpController.text.length >= 6
                              ? Colors.blue.shade200
                              : Colors.blueGrey.shade200,
                          offset: const Offset(1, -2),
                          blurRadius: 5),
                      BoxShadow(
                          color: otpController.text.length >= 6
                              ? Colors.blue.shade200
                              : Colors.blueGrey.shade200,
                          offset: const Offset(-1, 2),
                          blurRadius: 5)
                    ]),
              ),
          ],
        );
      },
    );
  }

  snackBar(context, String? message) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message!),
        duration: const Duration(seconds: 2),
      ),
    );
  }

// Row(
//   mainAxisAlignment: MainAxisAlignment.center,
//   children: [
//     const Text(
//       "Не пришёл код? ",
//       style: TextStyle(color: Colors.white, fontSize: 14),
//     ),
//     TextButton(
//       onPressed: () {
//         if (otpVisibility) {
//           verifyOTP();
//           snackBar("Вы верифицированы!");
//         } else {
//           loginWithPhone();
//           snackBar("Код отправлен!");
//         }
//       },
//       child: const Text(
//         "Повторно отправить",
//         style: TextStyle(
//           color: Colors.white,
//           fontWeight: FontWeight.bold,
//           fontSize: 16,
//         ),
//       ),
//     )
//   ],
// ),
}
