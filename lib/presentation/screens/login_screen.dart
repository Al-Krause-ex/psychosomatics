import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:psychosomatics/constants/hexcolor_str.dart';
import 'package:psychosomatics/domain/cubit/auth_cubit.dart';
import 'package:psychosomatics/presentation/widgets/phone_text_field.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);

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
              bottom: 20.0,
              left: 20.0,
              right: 20.0,
            ),
            child: BlocBuilder<AuthCubit, AuthState>(
              builder: (context, state) {
                if (state is AuthInitial) {
                  return _buildMain(context, false);
                }

                if (state is AuthError) {
                  return _buildMain(context, true);
                }

                return const SizedBox();
              },
            )),
      ),
    );
  }

  Widget _buildMain(context, bool hasError) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          child: ListView(
            children: [
              const Text(
                'Авторизация',
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
                height: 210.0,
              )),
              const SizedBox(height: 10.0),
              PhoneTextField(
                phoneController: _phoneController,
                size: MediaQuery.of(context).size,
                mapPhone: mapPhone,
              ),
              const SizedBox(height: 8.0),
              if (hasError)
                Text(
                  '*Пожалуйста, введите корректный номер',
                  style: TextStyle(color: Colors.yellow.shade300),
                ),
              // TextFieldTitle(
              //   title: 'Пароль',
              //   hint: 'Введите пароль',
              //   controller: _passwordController,
              // ),
              _buildTextButton(context),
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

            if (_phoneController.text.length >= 10) {
              // Navigator.of(context)
              //     .pushNamed(verifyScreenRoute, arguments: '');
            }
          },
          child: const Text('Войти'),
        ),
      ],
    );
  }

  Widget _buildTextButton(context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: TextButton(
        onPressed: () {
          // Navigator.pushNamed(context, registerScreenRoute);
        },
        style: TextButton.styleFrom(
          primary: HexColor(textButtonHexColor),
          padding: const EdgeInsets.only(bottom: 10.0),
        ),
        child: const Text(
          'Нет аккаунта',
          style: TextStyle(
            fontWeight: FontWeight.w600,
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
