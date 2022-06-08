import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:psychosomatics/constants/hexcolor_str.dart';
import 'package:psychosomatics/domain/cubit/logo_cubit.dart';

class LogoScreen extends StatelessWidget {
  const LogoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<LogoCubit>(context).isLoggedIn(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/images/heart_logo.svg',
              height: 150.0,
            ),
            const SizedBox(height: 15.0),
            Text(
              'SANITY',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 26.0,
                color: HexColor(primaryHexColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
