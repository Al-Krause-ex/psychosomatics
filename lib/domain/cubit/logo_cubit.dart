import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:psychosomatics/constants/routes_str.dart';
import 'package:psychosomatics/data/repository.dart';
import 'package:psychosomatics/domain/cubit/user_cubit.dart';
import 'package:flutter/material.dart';

part 'logo_state.dart';

class LogoCubit extends Cubit<LogoState> {
  final UserCubit userCubit;
  final Repository repository;

  LogoCubit({required this.userCubit, required this.repository})
      : super(LogoInitial());

  Future<void> isLoggedIn(context) async {
    await repository.isLoggedIn().then((value) async {
      if (value != null) {
        userCubit.auth(value);
        userCubit.illnessCubit.initialize(context, value);
      } else {
        var isFirstTime = await repository.firstRunCheck();

        if (isFirstTime) {
          Navigator.of(context).pushReplacementNamed(welcomeScreen);
        } else {
          Navigator.of(context).pushReplacementNamed(authScreen);
        }
      }
    });
  }

  void changeFirstTime() {
    repository.changeFirstTime();
  }
}
