import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:psychosomatics/constants/routes_str.dart';
import 'package:psychosomatics/data/repository.dart';
import 'package:psychosomatics/domain/cubit/user_cubit.dart';
import 'package:flutter/material.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final UserCubit userCubit;
  final Repository repository;

  AuthCubit({required this.repository, required this.userCubit})
      : super(const AuthInitial(phone: ''));

  void checkPhone(context, {required String phoneCode, required String phone}) {
    var phoneError = phone.length < 10 ? true : false;

    // var nameError = isRegister
    //     ? name.isEmpty
    //         ? true
    //         : false
    //     : false;

    if (phoneError) {
      if (state is AuthError) {
        emit((state as AuthError).copyWith(phone: phone));
      } else {
        emit(AuthError(phone: phone));
      }
    } else {
      emit(AuthInitial(phone: '$phoneCode$phone'));

      Navigator.of(context).pushNamed(
        verifyScreen,
        arguments: this,
      );
    }
  }

  ///Авторизация через телефон (вход в репозиторий)
  void signIn(context, Map<String, dynamic> mapVerification) {
    // print('run signIn');
    repository.signIn(mapVerification);
  }

  Future<bool> verifyOtp(context, Map<String, dynamic> mapData) async {
    var hasError = true;

    await repository.verifyOtpRepository(context, mapData).then((value) {
      if (value != null) {
        userCubit.auth(value);
        hasError = false;
      }
    });

    return hasError;
  }
}
