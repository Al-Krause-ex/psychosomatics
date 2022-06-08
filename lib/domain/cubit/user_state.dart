part of 'user_cubit.dart';

enum IndexPageEnum { home, favorite, profile }

abstract class UserState extends Equatable {
  final CustomUser? customUser;
  final IndexPageEnum indexPage;

  const UserState(this.customUser, this.indexPage);
}

class UserInitial extends UserState {
  const UserInitial({
    required IndexPageEnum indexPage,
    required CustomUser? customUser,
  }) : super(customUser, indexPage);

  @override
  List<Object> get props => [indexPage];
}

class UserAuthorized extends UserState {
  const UserAuthorized({
    required CustomUser? customUser,
    required IndexPageEnum indexPage,
  }) : super(customUser, indexPage);

  @override
  List<Object> get props => [indexPage];
}

class UserRun extends UserState {
  const UserRun({
    required CustomUser? customUser,
    required IndexPageEnum indexPage,
  }) : super(customUser, indexPage);

  @override
  List<Object> get props => [indexPage];
}

class UserChanged extends UserState {
  final String newName;

  const UserChanged({
    required this.newName,
    required CustomUser? customUser,
    required IndexPageEnum indexPage
  }) : super(customUser, indexPage);

  @override
  List<Object> get props => [indexPage, newName];
}
