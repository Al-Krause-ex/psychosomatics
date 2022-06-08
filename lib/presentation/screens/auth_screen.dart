import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:psychosomatics/constants/hexcolor_str.dart';
import 'package:psychosomatics/constants/routes_str.dart';
import 'package:psychosomatics/domain/cubit/auth_cubit.dart';
import 'package:psychosomatics/presentation/widgets/phone_text_field.dart';

class AuthScreen extends StatelessWidget {
  AuthScreen({Key? key}) : super(key: key);

  final _phoneController = TextEditingController();
  final Map<String, String> mapPhone = {'code': '+7', 'phone': ''};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor(primaryHexColor),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            top: 30.0,
            bottom: 15.0,
            left: 20.0,
            right: 20.0,
          ),
          child: BlocBuilder<AuthCubit, AuthState>(
            builder: (context, state) {
              if (state is AuthInitial) {
                return _buildMain(context, false);
              }

              if (state is AuthError) {
                // var nameError = state.name.isEmpty ? true : false;
                var phoneError = state.phone.isEmpty && state.phone.length < 10
                    ? true
                    : false;

                return _buildMain(context, phoneError);
              }

              return const SizedBox();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildMain(context, bool phoneError) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: ListView(
            children: [
              const Text(
                'Вход по номеру телефона',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20.0),
              Center(
                  child: SvgPicture.asset(
                'assets/images/auth_image.svg',
                height: 240.0,
              )),
              const SizedBox(height: 10.0),
              // TextFieldTitle(
              //   title: 'Имя',
              //   hint: 'Введите имя',
              //   controller: _nameController,
              // ),
              // if (nameError) ...[
              //   const SizedBox(height: 8.0),
              //   Text(
              //     '*Пожалуйста, введите корректное имя',
              //     style: TextStyle(color: Colors.yellow.shade300),
              //   ),
              // ],
              PhoneTextField(
                phoneController: _phoneController,
                size: MediaQuery.of(context).size,
                mapPhone: mapPhone,
              ),
              if (phoneError) ...[
                const SizedBox(height: 8.0),
                Text(
                  '*Пожалуйста, введите корректный номер',
                  style: TextStyle(color: Colors.yellow.shade300),
                ),
              ],
              // TextFieldTitle(
              //   title: 'Пароль',
              //   hint: 'Введите пароль',
              //   controller: _passwordController,
              // ),
              // _buildTextButton(context, true),
              const SizedBox(height: 10.0),
              const Text(
                'Регистрируя аккаунт, вы подтверждаете, что принимаете условия',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              SizedBox(
                height: 30.0,
                child: _buildTextButton(context, false),
              ),
              const SizedBox(height: 10.0),
            ],
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            fixedSize: Size(MediaQuery.of(context).size.width, 40.0),
            primary: HexColor(elevatedButtonHexColor),
          ),
          onPressed: () {
            _checkPhone(context);

            // BlocProvider.of<AuthCubit>(context).isLoggedIn(context);

            // Navigator.of(context).pushNamed(
            //   verifyScreenRoute,
            //   arguments: '${mapPhone['code']}${_phoneController.text}',
            // );
          },
          child: const Text(
            'Войти или зарегистрироваться',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _buildTextButton(context, bool isAuth) {
    return Align(
      alignment: Alignment.centerLeft,
      child: TextButton(
        onPressed: () {
          if (isAuth) {
            Navigator.pushNamed(context, authScreen);
            //Navigator.pushReplacementNamed(context, authScreenRoute);
          } else {}
        },
        style: TextButton.styleFrom(
          primary: HexColor(textButtonHexColor),
          padding:
              isAuth ? const EdgeInsets.only(bottom: 10.0) : EdgeInsets.zero,
        ),
        child: Text(
          isAuth ? 'Есть аккаунт' : 'Пользовательское соглашение',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  void _checkPhone(context) {
    mapPhone['phone'] = _phoneController.text;

    BlocProvider.of<AuthCubit>(context).checkPhone(
      context,
      phoneCode: mapPhone['code']!,
      phone: mapPhone['phone']!,
    );
  }
}
