part of 'auth_cubit.dart';

abstract class AuthState extends Equatable {
  const AuthState();
}

class AuthInitial extends AuthState {
  final String phone;

  const AuthInitial({
    required this.phone,
  });

  @override
  List<Object> get props => [phone];
}

class AuthError extends AuthState {
  final String phone;

  const AuthError({required this.phone});

  AuthError copyWith({
    required String phone,
  }) {
    return AuthError(
      phone: this.phone,
    );
  }


  @override
  List<Object> get props => [phone];
}

class AuthAuthorized extends AuthState {
  final String phone;
  final Map<String, dynamic> mapData = {};

  AuthAuthorized(this.phone);

  @override
  List<Object> get props => [mapData];
}

class AuthChanged extends AuthState {
  final Map<String, dynamic> mapData;

  const AuthChanged({
    required this.mapData,
  });

  @override
  List<Object> get props => [mapData];
}
